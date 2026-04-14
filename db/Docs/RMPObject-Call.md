# RMPObject Call Procedures

Call procedures are internal procedures for events, validation, and utilities.

## Event Procedures

### call_RMPObject_Event_Name

Generates an event when the object's name changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Name
    @twRMPObjectIx = 1000,
    @Name_wsRMPObjectId = 'New Building Name'
```

##### MySQL

```sql
CALL call_RMPObject_Event_Name(1000, 'New Building Name');
```

####

#### Generated Event

```json
{
  "pName": {
    "wsRMPObjectId": "New Building Name"
  }
}
```

---

### call_RMPObject_Event_Type

Generates an event when the object's type classification changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Type
    @twRMPObjectIx = 1000,
    @Type_bType = 1,           -- Furniture
    @Type_bSubtype = 2,        -- Chair
    @Type_bFiction = 0,
    @Type_bMovable = 1
```

##### MySQL

```sql
CALL call_RMPObject_Event_Type(1000, 1, 2, 0, 1);
```

####

#### Generated Event

```json
{
  "pType": {
    "bType": 1,
    "bSubtype": 2,
    "bFiction": 0,
    "bMovable": 1
  }
}
```

---

### call_RMPObject_Event_Owner

Generates an event when ownership of the physical object changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Owner
    @twRMPObjectIx = 1000,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL call_RMPObject_Event_Owner(1000, 2);
```

####

#### Generated Event

```json
{
  "pOwner": {
    "twRPersonaIx": 2
  }
}
```

---

### call_RMPObject_Event_Transform

Generates an event when position/rotation/scale changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Transform
    @twRMPObjectIx = 1000,
    @Transform_Position_dX = 100,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 50,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0.707,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 0.707,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1
```

##### MySQL

```sql
CALL call_RMPObject_Event_Transform(
    1000,
    100, 0, 50,
    0, 0.707, 0, 0.707,
    1, 1, 1
);
```

####

#### Generated Event

```json
{
  "pTransform": {
    "Position": [100, 0, 50],
    "Rotation": [0, 0.707, 0, 0.707],
    "Scale": [1, 1, 1]
  }
}
```

---

### call_RMPObject_Event_Bound

Generates an event when the object's bounding box dimensions change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Bound
    @twRMPObjectIx = 1000,
    @Bound_dX = 2.5,
    @Bound_dY = 1.2,
    @Bound_dZ = 2.5
```

##### MySQL

```sql
CALL call_RMPObject_Event_Bound(1000, 2.5, 1.2, 2.5);
```

####

#### Generated Event

```json
{
  "pBound": {
    "Max": [2.5, 1.2, 2.5]
  }
}
```

---

### call_RMPObject_Event_Resource

Generates an event when the object's resource reference (3D model, texture, etc.) changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_Resource
    @twRMPObjectIx = 1000,
    @Resource_qwResource = 2001,
    @Resource_sName = 'office_chair_v2',
    @Resource_sReference = 'models/furniture/office_chair_v2.glb'
```

##### MySQL

```sql
CALL call_RMPObject_Event_Resource(
    1000,
    2001,
    'office_chair_v2',
    'models/furniture/office_chair_v2.glb'
);
```

####

#### Generated Event

```json
{
  "pResource": {
    "qwResource": 2001,
    "sName": "office_chair_v2",
    "sReference": "models/furniture/office_chair_v2.glb"
  }
}
```

---

### call_RMPObject_Event_RMPObject_Open

Generates an event when a new physical child object is created. Inserts the new object into the database (unless reparenting) and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Parent object index |
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
DECLARE @twChildIx BIGINT

EXEC dbo.call_RMPObject_Event_RMPObject_Open
    @twRMPObjectIx = 1000,
    @Name_wsRMPObjectId = 'Desk Lamp',
    @Type_bType = 2,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 1,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'lamp_desk',
    @Resource_sReference = 'models/furniture/lamp_desk.glb',
    @Transform_Position_dX = 0.5,
    @Transform_Position_dY = 0.8,
    @Transform_Position_dZ = 0.3,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 0.2,
    @Bound_dY = 0.4,
    @Bound_dZ = 0.2,
    @twRMPObjectIx_Open = @twChildIx OUTPUT,
    @bReparent = 0
```

##### MySQL

```sql
SET @twChildIx = 0;

CALL call_RMPObject_Event_RMPObject_Open(
    1000,
    'Desk Lamp', 2, 0, 0, 1, 1,
    0, 'lamp_desk', 'models/furniture/lamp_desk.glb',
    0.5, 0.8, 0.3,
    0, 0, 0, 1,
    1, 1, 1,
    0.2, 0.4, 0.2,
    @twChildIx,
    0
);
```

####

#### Generated Event

The event includes complete child object data in `sJSON_Child`:

```json
{
  "pName": { "wsRMPObjectId": "Desk Lamp" },
  "pType": { "bType": 2, "bSubtype": 0, "bFiction": 0, "bMovable": 1 },
  "pOwner": { "twRPersonaIx": 1 },
  "pResource": { "qwResource": 0, "sName": "lamp_desk", "sReference": "models/furniture/lamp_desk.glb" },
  "pTransform": { "Position": [0.5, 0.8, 0.3], "Rotation": [0, 0, 0, 1], "Scale": [1, 1, 1] },
  "pBound": { "Max": [0.2, 0.4, 0.2] }
}
```

---

### call_RMPObject_Event_RMPObject_Close

Generates an event when a physical child object is deleted. Recursively deletes all descendants (unless reparenting) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx_Close` | BIGINT | Child object index to delete |
| `@bReparent` | TINYINT | 1=reparenting (don't delete), 0=delete object and descendants |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Event_RMPObject_Close
    @twRMPObjectIx = 1000,
    @twRMPObjectIx_Close = 1001,
    @bReparent = 0
```

##### MySQL

```sql
CALL call_RMPObject_Event_RMPObject_Close(1000, 1001, 0);
```

####

#### Behavior

1. Creates a temporary `#PObject` table for tracking deletions
2. Gets the next event sequence number from the parent
3. If `@bReparent = 0`, calls `call_RMPObject_Delete_Descendants` to recursively delete all children
4. Inserts a `RMPOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

## Validation Procedures

### call_RMPObject_Validate

Main validation procedure that validates access permissions and retrieves parent information.

#### Validation Rules

- `@twRPersonaIx` must be > 0
- `@twRMPObjectIx` must be > 0
- Object must exist in database
- Persona must have admin rights

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@ObjectHead_Parent_wClass` | SMALLINT OUTPUT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT OUTPUT | Parent object index |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @ObjectHead_Parent_wClass SMALLINT
DECLARE @ObjectHead_Parent_twObjectIx BIGINT
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @ObjectHead_Parent_wClass = @ObjectHead_Parent_wClass OUTPUT,
    @ObjectHead_Parent_twObjectIx = @ObjectHead_Parent_twObjectIx OUTPUT,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate(1, 1000, @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @nError);
```

####

---

### call_RMPObject_Validate_Name

Validates a physical object name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | Name to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Name must not be NULL

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate_Name
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMPObjectIx = 0,
    @Name_wsRMPObjectId = 'Office Chair',
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate_Name(72, 100, 0, 'Office Chair', @nError);
```

####

---

### call_RMPObject_Validate_Type

Validates type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Type must not be NULL
- Subtype must not be NULL
- Fiction flag must not be NULL
- Fiction flag must be 0 or 1
- Movable flag must not be NULL
- Movable flag must be 0 or 1
- If parent is RMTObject: parent type must be PARCEL (11)

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate_Type
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMPObjectIx = 0,
    @Type_bType = 1,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate_Type(72, 100, 0, 1, 0, 0, 1, @nError);
```

####

---

### call_RMPObject_Validate_Owner

Validates owner persona index.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Owner_twRPersonaIx` must not be NULL
- `Owner_twRPersonaIx` must be between 1 and 0x0000FFFFFFFFFFFC

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate_Owner
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMPObjectIx = 0,
    @Owner_twRPersonaIx = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate_Owner(72, 100, 0, 1, @nError);
```

####

---

### call_RMPObject_Validate_Transform

Validates position, rotation, and scale values.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All position values must not be NULL or NaN
- All rotation values must not be NULL or NaN
- All scale values must not be NULL or NaN

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Validate_Transform
    @Transform_Position_dX = 100,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 50,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
CALL call_RMPObject_Validate_Transform(
    100, 0, 50,
    0, 0, 0, 1,
    1, 1, 1,
    nError
);
```

####

---

### call_RMPObject_Validate_Bound

Validates bounding box dimensions.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All dimensions must be >= 0
- Values must not be NULL or NaN

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate_Bound
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMPObjectIx = 0,
    @Bound_dX = 2.5,
    @Bound_dY = 1.2,
    @Bound_dZ = 2.5,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate_Bound(72, 100, 0, 2.5, 1.2, 2.5, @nError);
```

####

---

### call_RMPObject_Validate_Resource

Validates the resource reference fields for a physical object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Resource_qwResource` must not be NULL
- `Resource_sName` must not be NULL
- `Resource_sReference` must not be NULL

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMPObject_Validate_Resource
    @ObjectHead_Parent_wClass = 73,
    @ObjectHead_Parent_twObjectIx = 1000,
    @twRMPObjectIx = 0,
    @Resource_qwResource = 2001,
    @Resource_sName = 'chair_office',
    @Resource_sReference = 'models/furniture/chair_office.glb',
    @nError = @nError OUTPUT

IF @nError > 0
    SELECT dwError, sError FROM #Error
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMPObject_Validate_Resource(
    73, 1000, 0,
    2001, 'chair_office', 'models/furniture/chair_office.glb',
    @nError
);

IF @nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;
```

####

---

## Utility Procedures

### call_RMPObject_Event

Gets the next event sequence number for the object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Object index |
| `@twEventIz` | BIGINT OUTPUT | Event sequence number |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twEventIz BIGINT

EXEC @bError = dbo.call_RMPObject_Event
    @twRMPObjectIx = 1000,
    @twEventIz = @twEventIz OUTPUT
```

##### MySQL

```sql
CALL call_RMPObject_Event(1000, @twEventIz);
```

####

---

### call_RMPObject_Select

Outputs physical object data from the temporary results table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@nResultSet` | INT | Result set number to output |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Select 0
```

##### MySQL

```sql
CALL call_RMPObject_Select(0);
```

####

---

### call_RMPObject_Log

Logs an operation on the physical object for auditing purposes.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bOp` | TINYINT | Operation code |
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Log
    @bOp = 1,                  -- Read operation
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000
```

##### MySQL

```sql
CALL call_RMPObject_Log(1, '127.0.0.1', 1, 1000);
```

####

---

### call_RMPObject_Delete_Descendants

Recursively deletes all descendants of a physical object using a common table expression (CTE) to traverse the hierarchy.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMPObjectIx` | BIGINT | Root object index to delete from (NULL to use `#TObject` table) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMPObject_Delete_Descendants
    @twRMPObjectIx = 1000
```

##### MySQL

```sql
CALL call_RMPObject_Delete_Descendants(1000);
```

####

#### Behavior

1. If `@twRMPObjectIx` is NULL, uses the `#TObject` temporary table to find terrestrial parents
2. Uses a recursive CTE to find all physical descendants in the hierarchy
3. Inserts all found object indices into the `#PObject` temporary table
4. Deletes all objects from `RMPObject` that match the collected indices
5. Returns error if fewer rows were deleted than expected

#### Dependencies

This procedure expects the following temporary tables to exist:
- `#PObject` — Stores object indices to delete
- `#TObject` — (Optional) Contains terrestrial objects when `@twRMPObjectIx` is NULL

---

## Complete Event Flow Example

Here's a complete example showing how events flow when modifying a physical object:

### Tabs {.tabset}

#### SQL Server

```sql
-- User wants to move a chair
-- This happens inside set_RMPObject_Transform:

-- 1. Create temporary tables
SELECT * INTO #Error FROM dbo.Table_Error()
SELECT * INTO #Event FROM dbo.Table_Event()

DECLARE @nError INT = 0

-- 2. Validate input
EXEC dbo.call_RMPObject_Validate_Transform
    @Transform_Position_dX = 10,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 5,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @nError = @nError OUTPUT

IF @nError = 0
BEGIN
    -- 3. Generate event record
    EXEC dbo.call_RMPObject_Event_Transform
        @twRMPObjectIx = 1001,
        @Transform_Position_dX = 10,
        @Transform_Position_dY = 0,
        @Transform_Position_dZ = 5,
        @Transform_Rotation_dX = 0,
        @Transform_Rotation_dY = 0,
        @Transform_Rotation_dZ = 0,
        @Transform_Rotation_dW = 1,
        @Transform_Scale_dX = 1,
        @Transform_Scale_dY = 1,
        @Transform_Scale_dZ = 1
    
    -- 4. Update the database
    UPDATE dbo.RMPObject
       SET Transform_Position_dX = 10,
           Transform_Position_dY = 0,
           Transform_Position_dZ = 5,
           Transform_Rotation_dX = 0,
           Transform_Rotation_dY = 0,
           Transform_Rotation_dZ = 0,
           Transform_Rotation_dW = 1,
           Transform_Scale_dX = 1,
           Transform_Scale_dY = 1,
           Transform_Scale_dZ = 1
     WHERE ObjectHead_Self_twObjectIx = 1001
    
    -- 5. Push events to the queue
    EXEC @bError = dbo.call_Event_Push
END

-- 6. Return result
IF @nError > 0
    SELECT dwError, sError FROM #Error
```

#### MySQL

```sql
-- User wants to move a chair
-- This happens inside set_RMPObject_Transform:

-- 1. Create temporary tables
CREATE TEMPORARY TABLE Error (...);
CREATE TEMPORARY TABLE Event (...);

SET nError = 0;

-- 2. Validate input
CALL call_RMPObject_Validate_Transform(
    10, 0, 5,
    0, 0, 0, 1,
    1, 1, 1,
    nError
);

IF nError = 0 THEN
    -- 3. Generate event record
    CALL call_RMPObject_Event_Transform(
        1001,
        10, 0, 5,
        0, 0, 0, 1,
        1, 1, 1
    );
    
    -- 4. Update the database
    UPDATE RMPObject
       SET Transform_Position_dX = 10,
           Transform_Position_dY = 0,
           Transform_Position_dZ = 5,
           Transform_Rotation_dX = 0,
           Transform_Rotation_dY = 0,
           Transform_Rotation_dZ = 0,
           Transform_Rotation_dW = 1,
           Transform_Scale_dX = 1,
           Transform_Scale_dY = 1,
           Transform_Scale_dZ = 1
     WHERE ObjectHead_Self_twObjectIx = 1001;
    
    -- 5. Push events to the queue
    CALL call_Event_Push(bError);
END IF;

-- 6. Return result
IF nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;

DROP TEMPORARY TABLE Error;
DROP TEMPORARY TABLE Event;
```

###

---

**See also:** [RMPObject](../RMPObject) | [RMPObject Get Procedures](./Get) | [RMPObject Set Procedures](./Set) | [Event System](../Event-System)
