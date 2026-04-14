# RMRoot Call Procedures

Call procedures are internal procedures used by set procedures. They handle event generation, validation, and utility functions. These procedures are not typically called directly by clients.

## Event Procedures

Event procedures generate records in the `#Event` temporary table, which are later pushed to the `RMEvent` table.

### call_RMRoot_Event_Name

Generates an event when the root's name changes.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Root object index |
| `@Name_wsRMRootId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Event_Name
    @twRMRootIx = 1,
    @Name_wsRMRootId = 'New Universe Name'
```

##### MySQL

```sql
CALL call_RMRoot_Event_Name(1, 'New Universe Name');
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `NAME` |
| Self_wClass | 70 |
| Self_twObjectIx | (root index) |
| Child_wClass | 0 |
| Child_twObjectIx | 0 |
| wFlags | 0x10 (PARTIAL) |
| sJSON_Object | `{ "pName": { "wsRMRootId": "New Universe Name" } }` |

---

### call_RMRoot_Event_Owner

Generates an event when the root's owner changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Root object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Event_Owner
    @twRMRootIx = 1,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL call_RMRoot_Event_Owner(1, 2);
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `OWNER` |
| Self_wClass | 70 |
| Self_twObjectIx | (root index) |
| Child_wClass | 0 |
| Child_twObjectIx | 0 |
| wFlags | 0x10 (PARTIAL) |
| sJSON_Object | `{ "pOwner": { "twRPersonaIx": 2 } }` |

---

### call_RMRoot_Event_RMCObject_Open

Generates an event when a celestial object is created under the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | Child name |
| `@Type_*` | Various | Type information |
| `@Owner_*` | Various | Owner information |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Orbit_Spin_*` | Various | Orbital parameters |
| `@Bound_*` | Various | Bounding box |
| `@Properties_*` | Various | Physical properties |
| `@twRMCObjectIx` | BIGINT OUTPUT | Created object index |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twRMCObjectIx BIGINT

EXEC dbo.call_RMRoot_Event_RMCObject_Open
    @twRMRootIx = 1,
    @Name_wsRMCObjectId = 'Sol',
    @Type_bType = 2,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
    @twRMCObjectIx = @twRMCObjectIx OUTPUT
```

##### MySQL

```sql
SET @twRMCObjectIx = 0;

CALL call_RMRoot_Event_RMCObject_Open(
    1, 'Sol', 2, 0, 0, 1,
    -- ... additional parameters ...
    @twRMCObjectIx
);
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `RMCOBJECT_OPEN` |
| Self_wClass | 70 (RMRoot) |
| Self_twObjectIx | (root index) |
| Child_wClass | 71 (RMCObject) |
| Child_twObjectIx | (new object index) |
| wFlags | 0x01 (OPEN) |
| sJSON_Child | Complete object data as JSON |

---

### call_RMRoot_Event_RMCObject_Close

Generates an event when a celestial object is deleted.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMCObjectIx_Close` | BIGINT | Object being deleted |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Event_RMCObject_Close
    @twRMRootIx = 1,
    @twRMCObjectIx_Close = 42
```

##### MySQL

```sql
CALL call_RMRoot_Event_RMCObject_Close(1, 42);
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `RMCOBJECT_CLOSE` |
| Self_wClass | 70 (RMRoot) |
| Child_wClass | 71 (RMCObject) |
| wFlags | 0x02 (CLOSE) |

---

### call_RMRoot_Event_RMTObject_Open

Generates an event when a terrestrial object is created directly under the root. Inserts the new object into the database and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Child object name |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |
| `@Properties_bLockToGround` | TINYINT | Lock to ground surface |
| `@Properties_bYouth` | TINYINT | Youth content rating |
| `@Properties_bAdult` | TINYINT | Adult content rating |
| `@Properties_bAvatar` | TINYINT | Avatar access allowed |
| `@twRMTObjectIx` | BIGINT OUTPUT | Created child object index |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twRMTObjectIx BIGINT

EXEC dbo.call_RMRoot_Event_RMTObject_Open
    @twRMRootIx = 1,
    @Name_wsRMTObjectId = 'Test Region',
    @Type_bType = 8,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
    @twRMTObjectIx = @twRMTObjectIx OUTPUT
```

##### MySQL

```sql
SET @twRMTObjectIx = 0;

CALL call_RMRoot_Event_RMTObject_Open(
    1, 'Test Region', 8, 0, 0, 1,
    -- ... additional parameters ...
    @twRMTObjectIx
);
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `RMTOBJECT_OPEN` |
| Self_wClass | 70 (RMRoot) |
| Child_wClass | 72 (RMTObject) |
| wFlags | 0x01 (OPEN) |
| sJSON_Child | Complete object data as JSON |

---

### call_RMRoot_Event_RMTObject_Close

Generates an event when a terrestrial object is deleted from the root. Recursively deletes all descendants (terrestrial and physical) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMTObjectIx_Close` | BIGINT | Child terrestrial object index to delete |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Event_RMTObject_Close
    @twRMRootIx = 1,
    @twRMTObjectIx_Close = 100
```

##### MySQL

```sql
CALL call_RMRoot_Event_RMTObject_Close(1, 100);
```

####

#### Behavior

1. Creates temporary tables for tracking deletions (`#TObject`, `#PObject`)
2. Gets the next event sequence number from the root
3. Calls `call_RMTObject_Delete_Descendants` to recursively delete all terrestrial descendants
4. Calls `call_RMPObject_Delete_Descendants` to delete physical descendants
5. Inserts a `RMTOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

### call_RMRoot_Event_RMPObject_Open

Generates an event when a physical object is created directly under the root. Inserts the new object into the database (unless reparenting) and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | Child object name |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |
| `@twRMPObjectIx_Open` | BIGINT OUTPUT | Created child object index |
| `@bReparent` | TINYINT | 1=reparenting existing object, 0=new object |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twRMPObjectIx BIGINT

EXEC dbo.call_RMRoot_Event_RMPObject_Open
    @twRMRootIx = 1,
    @Name_wsRMPObjectId = 'Test Object',
    @Type_bType = 0,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
    @twRMPObjectIx_Open = @twRMPObjectIx OUTPUT,
    @bReparent = 0
```

##### MySQL

```sql
SET @twRMPObjectIx = 0;

CALL call_RMRoot_Event_RMPObject_Open(
    1, 'Test Object', 0, 0, 0, 0, 1,
    -- ... additional parameters ...
    @twRMPObjectIx,
    0
);
```

####

#### Generated Event

| Field | Value |
|-------|-------|
| sType | `RMPOBJECT_OPEN` |
| Self_wClass | 70 (RMRoot) |
| Child_wClass | 73 (RMPObject) |
| wFlags | 0x01 (OPEN) |
| sJSON_Child | Complete object data as JSON |

---

### call_RMRoot_Event_RMPObject_Close

Generates an event when a physical object is deleted from the root. Recursively deletes all descendants (unless reparenting) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMPObjectIx_Close` | BIGINT | Child physical object index to delete |
| `@bReparent` | TINYINT | 1=reparenting (don't delete), 0=delete object and descendants |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Event_RMPObject_Close
    @twRMRootIx = 1,
    @twRMPObjectIx_Close = 1000,
    @bReparent = 0
```

##### MySQL

```sql
CALL call_RMRoot_Event_RMPObject_Close(1, 1000, 0);
```

####

#### Behavior

1. Creates a temporary `#PObject` table for tracking deletions
2. Gets the next event sequence number from the root
3. If `@bReparent = 0`, calls `call_RMPObject_Delete_Descendants` to recursively delete all children
4. Inserts a `RMPOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

## Validation Procedures

Validation procedures check input parameters and accumulate errors in the `#Error` temporary table.

### call_RMRoot_Validate

Main validation procedure that validates access permissions and retrieves parent information.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Root object index |
| `@ObjectHead_Parent_wClass` | SMALLINT OUTPUT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT OUTPUT | Parent object index |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `@twRPersonaIx` must be > 0
- `@twRMRootIx` must be > 0
- Root object must exist in database
- Persona must have admin rights (checked against `dbo.Admin` table)

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @ObjectHead_Parent_wClass SMALLINT
DECLARE @ObjectHead_Parent_twObjectIx BIGINT
DECLARE @nError INT = 0

EXEC dbo.call_RMRoot_Validate
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @ObjectHead_Parent_wClass = @ObjectHead_Parent_wClass OUTPUT,
    @ObjectHead_Parent_twObjectIx = @ObjectHead_Parent_twObjectIx OUTPUT,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMRoot_Validate(1, 1, @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @nError);
```

####

---

### call_RMRoot_Validate_Name

Validates a root name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMRootIx` | BIGINT | Root object index |
| `@Name_wsRMRootId` | NVARCHAR(48) | Name to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Name must not be NULL

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMRoot_Validate_Name
    @ObjectHead_Parent_wClass = 0,
    @ObjectHead_Parent_twObjectIx = 0,
    @twRMRootIx = 1,
    @Name_wsRMRootId = 'My Universe',
    @nError = @nError OUTPUT

IF @nError > 0
    SELECT dwError, sError FROM #Error
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMRoot_Validate_Name(0, 0, 1, 'My Universe', @nError);

IF @nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;
```

####

---

### call_RMRoot_Validate_Owner

Validates an owner persona index.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMRootIx` | BIGINT | Root object index |
| `@Owner_twRPersonaIx` | BIGINT | Owner to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Owner must not be NULL
- Owner must be between 1 and 0x0000FFFFFFFFFFFC

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMRoot_Validate_Owner
    @ObjectHead_Parent_wClass = 0,
    @ObjectHead_Parent_twObjectIx = 0,
    @twRMRootIx = 1,
    @Owner_twRPersonaIx = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMRoot_Validate_Owner(0, 0, 1, 1, @nError);
```

####

---

## Utility Procedures

### call_RMRoot_Log

Logs an operation on the root object for auditing purposes.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bOp` | TINYINT | Operation code |
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Root object index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMRoot_Log
    @bOp = 1,                  -- Read operation
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1
```

##### MySQL

```sql
CALL call_RMRoot_Log(1, '127.0.0.1', 1, 1);
```

####

---

### call_RMRoot_Event

Gets the next event sequence number for the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMRootIx` | BIGINT | Root object index |
| `@twEventIz` | BIGINT OUTPUT | Event sequence number |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twEventIz BIGINT

EXEC @bError = dbo.call_RMRoot_Event
    @twRMRootIx = 1,
    @twEventIz = @twEventIz OUTPUT
```

##### MySQL

```sql
CALL call_RMRoot_Event(1, @twEventIz);
```

####

---

### call_RMRoot_Select

Outputs root object data from the temporary results table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@nResultSet` | INT | Result set number to output |

#### Tabs {.tabset}

##### SQL Server

```sql
-- After populating #Results with root IDs
EXEC dbo.call_RMRoot_Select 0
```

##### MySQL

```sql
-- After populating Results with root IDs
CALL call_RMRoot_Select(0);
```

####

This procedure:
1. Reads object IDs from `#Results` where `nResultSet` matches
2. Joins with `RMRoot` table to get full object data
3. Outputs the result set

---

## Event Flow Example

Here's how events flow through a typical set operation:

### Tabs {.tabset}

#### SQL Server

```sql
-- Inside set_RMRoot_Name:

-- 1. Create temporary tables
SELECT * INTO #Error FROM dbo.Table_Error()
SELECT * INTO #Event FROM dbo.Table_Event()

BEGIN TRANSACTION

-- 2. Validate
EXEC dbo.call_RMRoot_Validate @twRPersonaIx, @twRMRootIx,
    @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

IF @nError = 0
    EXEC dbo.call_RMRoot_Validate_Name @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx,
        @twRMRootIx, @Name_wsRMRootId, @nError OUTPUT

-- 3. Generate event (UPDATE happens inside)
IF @nError = 0
    EXEC @bError = dbo.call_RMRoot_Event_Name @twRMRootIx, @Name_wsRMRootId

-- 4. Log and push events
IF @bError = 0
BEGIN
    EXEC @bError = dbo.call_RMRoot_Log @RMROOT_OP_NAME, @sIPAddress, @twRPersonaIx, @twRMRootIx

    IF @bError = 0
        EXEC @bError = dbo.call_Event_Push
END

IF @bError = 0
    COMMIT TRANSACTION
ELSE
    ROLLBACK TRANSACTION
```

#### MySQL

```sql
-- Inside set_RMRoot_Name:

-- 1. Create temporary tables
CREATE TEMPORARY TABLE Error (...);
CREATE TEMPORARY TABLE Event (...);

START TRANSACTION;

-- 2. Validate
CALL call_RMRoot_Validate(twRPersonaIx, twRMRootIx,
    @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @nError);

IF @nError = 0 THEN
    CALL call_RMRoot_Validate_Name(@ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx,
        twRMRootIx, Name_wsRMRootId, @nError);
END IF;

-- 3. Generate event (UPDATE happens inside)
IF @nError = 0 THEN
    CALL call_RMRoot_Event_Name(twRMRootIx, Name_wsRMRootId);
END IF;

-- 4. Log and push events
IF @bError = 0 THEN
    CALL call_RMRoot_Log(@RMROOT_OP_NAME, sIPAddress, twRPersonaIx, twRMRootIx);

    IF @bError = 0 THEN
        CALL call_Event_Push(@bError);
    END IF;
END IF;

IF @bError = 0 THEN
    COMMIT;
ELSE
    ROLLBACK;
END IF;
```

###

---

**See also:** [RMRoot](../RMRoot) | [RMRoot Get Procedures](./Get) | [RMRoot Set Procedures](./Set) | [Event System](../Event-System)
