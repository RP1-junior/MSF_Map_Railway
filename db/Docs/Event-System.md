# Event System

The event system is the backbone of MSF_Map_Db's real-time synchronization. Every modification to the database generates an event that can be pushed to connected clients, enabling a live, collaborative metaverse where changes made by one user are immediately visible to others.

## Why Events Matter

In a traditional database application, clients poll for changes or rely on application-level notifications. This approach has significant limitations:

- **Polling is inefficient** — clients waste resources checking for changes that may not exist
- **Updates are delayed** — changes aren't visible until the next poll cycle
- **State can diverge** — clients may miss updates or receive them out of order
- **Scaling is difficult** — more clients means more polling load

MSF_Map_Db solves these problems with an event-driven architecture:

- **Push-based updates** — changes are pushed to clients immediately
- **Guaranteed ordering** — events have sequence numbers ensuring consistent state
- **Selective subscription** — clients only receive events for objects they care about
- **Audit trail** — every change is recorded for debugging and rollback

## The Event Lifecycle

### 1. Modification Request

A client requests a change through a `set_*` procedure:

## Tabs {.tabset}

### SQL Server

```sql
EXEC dbo.set_RMCObject_Name
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 42,
    @Name_wsRMCObjectId = 'New Star Name'
```

### MySQL

```sql
CALL set_RMCObject_Name(
    '127.0.0.1',
    1,              -- twRPersonaIx
    42,             -- twRMCObjectIx
    'New Star Name',
    @nResult
);
```

##

### 2. Validation

The procedure validates inputs using `call_*_Validate_*` procedures:

## Tabs {.tabset}

### SQL Server

```sql
EXEC dbo.call_RMCObject_Validate_Name
    @Name_wsRMCObjectId = @Name_wsRMCObjectId,
    @nError = @nError OUTPUT
```

### MySQL

```sql
CALL call_RMCObject_Validate_Name(Name_wsRMCObjectId, nError);
```

##

### 3. Event Generation

If validation passes, the procedure calls a `call_*_Event_*` procedure to record the change:

## Tabs {.tabset}

### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Name
    @twRMCObjectIx = @twRMCObjectIx,
    @Name_wsRMCObjectId = @Name_wsRMCObjectId
```

### MySQL

```sql
CALL call_RMCObject_Event_Name(twRMCObjectIx, Name_wsRMCObjectId);
```

##

### 4. Database Update

The actual data modification occurs:

## Tabs {.tabset}

### SQL Server

```sql
UPDATE dbo.RMCObject
   SET Name_wsRMCObjectId = @Name_wsRMCObjectId
 WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx
```

### MySQL

```sql
UPDATE RMCObject
   SET Name_wsRMCObjectId = Name_wsRMCObjectId
 WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;
```

##

### 5. Event Push

Finally, the events are pushed to the event queue:

## Tabs {.tabset}

### SQL Server

```sql
EXEC @bError = dbo.call_Event_Push
```

### MySQL

```sql
CALL call_Event_Push(bError);
```

##

## The RMEvent Table

All events are stored in the `RMEvent` table:

| Column | Type | Description |
|--------|------|-------------|
| `twEventIx` | BIGINT | Auto-incrementing event sequence number |
| `sType` | VARCHAR(32) | Event type identifier |
| `Self_wClass` | TINYINT | Class ID of the parent object |
| `Self_twObjectIx` | BIGINT | Object index of the parent |
| `Child_wClass` | TINYINT | Class ID of the affected object |
| `Child_twObjectIx` | BIGINT | Object index of the affected object |
| `wFlags` | SMALLINT | Event flags (open, close, modify) |
| `twEventIz` | BIGINT | Related event sequence (for linking) |
| `sJSON_Object` | NVARCHAR(4000) | JSON data about the parent object |
| `sJSON_Child` | NVARCHAR(4000) | JSON data about the child object |
| `sJSON_Change` | NVARCHAR(4000) | JSON data describing the change |

## Event Types

Events follow a naming convention: `{OBJECT}_[ACTION]`

### Object Open Events

Generated when a new object is created:

| Event Type | Description |
|------------|-------------|
| `RMCOBJECT_OPEN` | New celestial object created |
| `RMTOBJECT_OPEN` | New terrestrial object created |
| `RMPOBJECT_OPEN` | New physical object created |

Open events include the complete object data in `sJSON_Child`:

```json
{
  "pName": { "wsRMCObjectId": "Sol" },
  "pType": { "bType": 2, "bSubtype": 0, "bFiction": 0 },
  "pOwner": { "twRPersonaIx": 1 },
  "pResource": { "qwResource": 0, "sName": "", "sReference": "" },
  "pTransform": {
    "Position": { "dX": 0, "dY": 0, "dZ": 0 },
    "Rotation": { "dX": 0, "dY": 0, "dZ": 0, "dW": 1 },
    "Scale": { "dX": 1, "dY": 1, "dZ": 1 }
  },
  "pOrbit_Spin": { "tmPeriod": 0, "tmStart": 0, "dA": 0, "dB": 0 },
  "pBound": { "dX": 100000, "dY": 100000, "dZ": 100000 },
  "pProperties": { "fMass": 1.0, "fGravity": 1.0, "fColor": 1.0, "fBrightness": 1.0, "fReflectivity": 0.0 }
}
```

### Object Close Events

Generated when an object is deleted:

| Event Type | Description |
|------------|-------------|
| `RMCOBJECT_CLOSE` | Celestial object deleted |
| `RMTOBJECT_CLOSE` | Terrestrial object deleted |
| `RMPOBJECT_CLOSE` | Physical object deleted |

Close events have minimal JSON — just enough to identify what was deleted.

### Property Change Events

Generated when an object property is modified:

| Event Type | Description |
|------------|-------------|
| `RMCOBJECT_NAME` | Celestial object name changed |
| `RMCOBJECT_TYPE` | Celestial object type changed |
| `RMCOBJECT_OWNER` | Celestial object ownership transferred |
| `RMCOBJECT_TRANSFORM` | Celestial object position/rotation/scale changed |
| `RMCOBJECT_BOUND` | Celestial object bounding box changed |
| `RMCOBJECT_RESOURCE` | Celestial object resource reference changed |
| `RMCOBJECT_PROPERTIES` | Celestial object properties changed |
| `RMCOBJECT_ORBIT_SPIN` | Celestial object orbit/spin changed |

Similar events exist for `RMTOBJECT_*` and `RMPOBJECT_*`.

Property change events include the new value in `sJSON_Change`:

```json
{
  "pName": { "wsRMCObjectId": "New Star Name" }
}
```

## Event Flags

The `wFlags` field indicates the type of change:

| Flag | Value | Description |
|------|-------|-------------|
| `OPEN` | 0x01 | Object was created |
| `CLOSE` | 0x02 | Object was deleted |
| `MODIFY` | 0x00 | Object was modified (default) |

## Event Sequencing

Events have two sequence numbers:

- **twEventIx**: The global event sequence, auto-incremented for each event
- **twEventIz**: A related event sequence, used to link related events

The `twEventIz` field is particularly important for:

1. **Linking open events to their parent's event** — when you create a child, the parent also gets an event
2. **Tracking cascading changes** — when one change triggers others
3. **Grouping related events** — multiple events from a single operation share a `twEventIz`

## The Temporary Event Table

During a procedure's execution, events accumulate in a temporary `#Event` table:

## Tabs {.tabset}

### SQL Server

```sql
SELECT * INTO #Event FROM dbo.Table_Event()
```

### MySQL

```sql
CREATE TEMPORARY TABLE Event (
    nOrder INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sType VARCHAR(32) NOT NULL,
    Self_wClass TINYINT NOT NULL,
    Self_twObjectIx BIGINT NOT NULL,
    Child_wClass TINYINT NOT NULL,
    Child_twObjectIx BIGINT NOT NULL,
    wFlags SMALLINT NOT NULL,
    twEventIz BIGINT NOT NULL,
    sJSON_Object VARCHAR(4000) NOT NULL,
    sJSON_Child VARCHAR(4000) NOT NULL,
    sJSON_Change VARCHAR(4000) NOT NULL
);
```

##

This allows:
- Multiple events to be generated in a single procedure
- Events to be ordered correctly before insertion
- Rollback if the procedure fails

## Event Procedure Pattern

All `call_*_Event_*` procedures follow a consistent pattern:

## Tabs {.tabset}

### SQL Server

```sql
CREATE PROCEDURE dbo.call_RMCObject_Event_Name
(
    @twRMCObjectIx BIGINT,
    @Name_wsRMCObjectId NVARCHAR(48)
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @SBO_CLASS_RMCOBJECT INT = 71

    -- Get the object's parent information
    DECLARE @ObjectHead_Parent_wClass SMALLINT,
            @ObjectHead_Parent_twObjectIx BIGINT

    SELECT @ObjectHead_Parent_wClass = ObjectHead_Parent_wClass,
           @ObjectHead_Parent_twObjectIx = ObjectHead_Parent_twObjectIx
      FROM dbo.RMCObject
     WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx

    -- Insert the event
    INSERT #Event
           (sType, Self_wClass, Self_twObjectIx, 
            Child_wClass, Child_twObjectIx, 
            wFlags, twEventIz, 
            sJSON_Object, sJSON_Child, sJSON_Change)
    VALUES ('RMCOBJECT_NAME',
            @ObjectHead_Parent_wClass,
            @ObjectHead_Parent_twObjectIx,
            @SBO_CLASS_RMCOBJECT,
            @twRMCObjectIx,
            0,  -- MODIFY flag
            0,  -- No related event
            '{ }',
            '{ }',
            dbo.Format_Name_C(@Name_wsRMCObjectId))
END
```

### MySQL

```sql
CREATE PROCEDURE call_RMCObject_Event_Name
(
    IN twRMCObjectIx BIGINT,
    IN Name_wsRMCObjectId VARCHAR(48)
)
BEGIN
    DECLARE SBO_CLASS_RMCOBJECT INT DEFAULT 71;
    
    DECLARE ObjectHead_Parent_wClass SMALLINT;
    DECLARE ObjectHead_Parent_twObjectIx BIGINT;

    -- Get the object's parent information
    SELECT c.ObjectHead_Parent_wClass,
           c.ObjectHead_Parent_twObjectIx
      INTO ObjectHead_Parent_wClass,
           ObjectHead_Parent_twObjectIx
      FROM RMCObject AS c
     WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx;

    -- Insert the event
    INSERT INTO Event
           (sType, Self_wClass, Self_twObjectIx, 
            Child_wClass, Child_twObjectIx, 
            wFlags, twEventIz, 
            sJSON_Object, sJSON_Child, sJSON_Change)
    VALUES ('RMCOBJECT_NAME',
            ObjectHead_Parent_wClass,
            ObjectHead_Parent_twObjectIx,
            SBO_CLASS_RMCOBJECT,
            twRMCObjectIx,
            0,
            0,
            '{ }',
            '{ }',
            Format_Name_C(Name_wsRMCObjectId));
END
```

##

## JSON Formatting Functions

MSF_Map_Db includes helper functions to format data as JSON:

| Function | Description |
|----------|-------------|
| `Format_Name_C` | Format celestial object name |
| `Format_Name_T` | Format terrestrial object name |
| `Format_Name_P` | Format physical object name |
| `Format_Type_C` | Format celestial object type |
| `Format_Type_T` | Format terrestrial object type |
| `Format_Type_P` | Format physical object type |
| `Format_Owner` | Format owner information |
| `Format_Resource` | Format resource reference |
| `Format_Transform` | Format position/rotation/scale |
| `Format_Bound` | Format bounding box |
| `Format_Properties_C` | Format celestial properties |
| `Format_Properties_T` | Format terrestrial properties |
| `Format_Orbit_Spin` | Format orbit/spin data |
| `Format_ObjectHead` | Format object header |

## Client Integration

On the client side (using MVMF), events are received through the Model's notification system:

```javascript
// Attach to a celestial object model
var model = client.attach('RMCObject', objectIx);

// Listen for changes
model.on('change', function(event) {
    if (event.type === 'RMCOBJECT_NAME') {
        console.log('Name changed to:', event.change.pName.wsRMCObjectId);
    }
});

// Listen for child additions
model.on('child:open', function(event) {
    console.log('New child:', event.child);
});

// Listen for child removals
model.on('child:close', function(event) {
    console.log('Child removed:', event.child);
});
```

## Best Practices

### Always Use Events

Never modify data directly — always go through `set_*` procedures that generate events. Direct modifications:
- Won't notify connected clients
- Won't create an audit trail
- May leave the system in an inconsistent state

### Keep Events Small

Events should contain only the changed data, not the entire object. This:
- Reduces network bandwidth
- Makes it clear what changed
- Enables efficient client-side updates

### Handle Events Idempotently

Clients should handle events idempotently — applying the same event twice should have the same result as applying it once. This protects against:
- Network retries
- Duplicate deliveries
- Reconnection replays

### Monitor Event Lag

In production, monitor the gap between event generation and delivery. Large lags indicate:
- Network issues
- Overloaded clients
- Database performance problems

## Debugging Events

To inspect recent events:

## Tabs {.tabset}

### SQL Server

```sql
SELECT TOP 100 
       twEventIx,
       sType,
       Self_wClass,
       Self_twObjectIx,
       Child_wClass,
       Child_twObjectIx,
       wFlags,
       sJSON_Change
  FROM dbo.RMEvent
 ORDER BY twEventIx DESC
```

### MySQL

```sql
SELECT twEventIx,
       sType,
       Self_wClass,
       Self_twObjectIx,
       Child_wClass,
       Child_twObjectIx,
       wFlags,
       sJSON_Change
  FROM RMEvent
 ORDER BY twEventIx DESC
 LIMIT 100;
```

##

---

**Previous:** [Database Schema](./Database-Schema) | **Next:** [Glossary](./Glossary)

**See also:** [Core Concepts](./Core-Concepts)
