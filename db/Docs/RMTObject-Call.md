# RMTObject Call Procedures

Call procedures are internal procedures for events, validation, geo operations, and matrix calculations.

## Event Procedures

### call_RMTObject_Event_Name

Generates an event when the terrestrial object's name changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Name
    @twRMTObjectIx = 100,
    @Name_wsRMTObjectId = 'New York City'
```

##### MySQL

```sql
CALL call_RMTObject_Event_Name(100, 'New York City');
```

####

#### Generated Event

```json
{
  "pName": {
    "wsRMTObjectId": "New York City"
  }
}
```

---

### call_RMTObject_Event_Type

Generates an event when the terrestrial object's type classification changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Type
    @twRMTObjectIx = 100,
    @Type_bType = 6,           -- City
    @Type_bSubtype = 0,
    @Type_bFiction = 0
```

##### MySQL

```sql
CALL call_RMTObject_Event_Type(100, 6, 0, 0);
```

####

#### Generated Event

```json
{
  "pType": {
    "bType": 6,
    "bSubtype": 0,
    "bFiction": 0
  }
}
```

---

### call_RMTObject_Event_Owner

Generates an event when ownership of the terrestrial object changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Owner
    @twRMTObjectIx = 100,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL call_RMTObject_Event_Owner(100, 2);
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

### call_RMTObject_Event_Transform

Generates an event when the terrestrial object's position, rotation, or scale changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Transform
    @twRMTObjectIx = 100,
    @Transform_Position_dX = 1000,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 500,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1
```

##### MySQL

```sql
CALL call_RMTObject_Event_Transform(
    100,
    1000, 0, 500,
    0, 0, 0, 1,
    1, 1, 1
);
```

####

#### Generated Event

```json
{
  "pTransform": {
    "Position": [1000, 0, 500],
    "Rotation": [0, 0, 0, 1],
    "Scale": [1, 1, 1]
  }
}
```

---

### call_RMTObject_Event_Bound

Generates an event when the terrestrial object's bounding box dimensions change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension (height) |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Bound
    @twRMTObjectIx = 100,
    @Bound_dX = 50000,
    @Bound_dY = 1000,
    @Bound_dZ = 50000
```

##### MySQL

```sql
CALL call_RMTObject_Event_Bound(100, 50000, 1000, 50000);
```

####

#### Generated Event

```json
{
  "pBound": {
    "Max": [50000, 1000, 50000]
  }
}
```

---

### call_RMTObject_Event_Resource

Generates an event when the terrestrial object's resource reference (terrain data, texture, etc.) changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Resource
    @twRMTObjectIx = 100,
    @Resource_qwResource = 3001,
    @Resource_sName = 'nyc_terrain',
    @Resource_sReference = 'terrain/cities/nyc_heightmap.bin'
```

##### MySQL

```sql
CALL call_RMTObject_Event_Resource(
    100,
    3001,
    'nyc_terrain',
    'terrain/cities/nyc_heightmap.bin'
);
```

####

#### Generated Event

```json
{
  "pResource": {
    "qwResource": 3001,
    "sName": "nyc_terrain",
    "sReference": "terrain/cities/nyc_heightmap.bin"
  }
}
```

---

### call_RMTObject_Event_Properties

Generates an event when the terrestrial object's properties change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Properties_bLockToGround` | TINYINT | Lock to ground surface (0/1) |
| `@Properties_bYouth` | TINYINT | Youth content rating (0/1) |
| `@Properties_bAdult` | TINYINT | Adult content rating (0/1) |
| `@Properties_bAvatar` | TINYINT | Avatar access allowed (0/1) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_Properties
    @twRMTObjectIx = 100,
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1
```

##### MySQL

```sql
CALL call_RMTObject_Event_Properties(100, 1, 1, 0, 1);
```

####

#### Generated Event

```json
{
  "pProperties": {
    "bLockToGround": 1,
    "bYouth": 1,
    "bAdult": 0,
    "bAvatar": 1
  }
}
```

---

### call_RMTObject_Event_RMTObject_Open

Generates an event when a new terrestrial child object is created. Inserts the new object into the database and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Parent terrestrial object index |
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
| `@twRMTObjectIx_Open` | BIGINT OUTPUT | Created child object index |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twDistrictIx BIGINT

EXEC dbo.call_RMTObject_Event_RMTObject_Open
    @twRMTObjectIx = 100,
    @Name_wsRMTObjectId = 'Manhattan',
    @Type_bType = 7,           -- District
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = '',
    @Resource_sReference = '',
    @Transform_Position_dX = 0,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 0,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 10000,
    @Bound_dY = 500,
    @Bound_dZ = 5000,
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1,
    @twRMTObjectIx_Open = @twDistrictIx OUTPUT
```

##### MySQL

```sql
SET @twDistrictIx = 0;

CALL call_RMTObject_Event_RMTObject_Open(
    100, 'Manhattan', 7, 0, 0, 1,
    0, '', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    10000, 500, 5000,
    1, 1, 0, 1,
    @twDistrictIx
);
```

####

---

### call_RMTObject_Event_RMTObject_Close

Generates an event when a terrestrial child object is deleted. Recursively deletes all descendants (terrestrial and physical) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Parent terrestrial object index |
| `@twRMTObjectIx_Close` | BIGINT | Child terrestrial object index to delete |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_RMTObject_Close
    @twRMTObjectIx = 100,
    @twRMTObjectIx_Close = 101
```

##### MySQL

```sql
CALL call_RMTObject_Event_RMTObject_Close(100, 101);
```

####

#### Behavior

1. Creates temporary tables for tracking deletions (`#TObject`, `#PObject`)
2. Gets the next event sequence number from the parent
3. Calls `call_RMTObject_Delete_Descendants` to recursively delete all terrestrial descendants
4. Calls `call_RMPObject_Delete_Descendants` to delete physical descendants
5. Inserts a `RMTOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

### call_RMTObject_Event_RMPObject_Open

Generates an event when a new physical child object is created on a terrestrial surface. Inserts the new object into the database (unless reparenting) and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Parent terrestrial object index |
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
DECLARE @twBuildingIx BIGINT

EXEC dbo.call_RMTObject_Event_RMPObject_Open
    @twRMTObjectIx = 100,
    @Name_wsRMPObjectId = 'Empire State Building',
    @Type_bType = 1,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'esb',
    @Resource_sReference = 'models/buildings/esb.glb',
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
    @Bound_dX = 50,
    @Bound_dY = 443,
    @Bound_dZ = 50,
    @twRMPObjectIx_Open = @twBuildingIx OUTPUT,
    @bReparent = 0
```

##### MySQL

```sql
SET @twBuildingIx = 0;

CALL call_RMTObject_Event_RMPObject_Open(
    100, 'Empire State Building', 1, 0, 0, 0, 1,
    0, 'esb', 'models/buildings/esb.glb',
    100, 0, 50,
    0, 0, 0, 1,
    1, 1, 1,
    50, 443, 50,
    @twBuildingIx,
    0
);
```

####

---

### call_RMTObject_Event_RMPObject_Close

Generates an event when a physical child object is deleted from a terrestrial surface. Recursively deletes all descendants (unless reparenting) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Parent terrestrial object index |
| `@twRMPObjectIx_Close` | BIGINT | Child physical object index to delete |
| `@bReparent` | TINYINT | 1=reparenting (don't delete), 0=delete object and descendants |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Event_RMPObject_Close
    @twRMTObjectIx = 100,
    @twRMPObjectIx_Close = 1001,
    @bReparent = 0
```

##### MySQL

```sql
CALL call_RMTObject_Event_RMPObject_Close(100, 1001, 0);
```

####

#### Behavior

1. Creates a temporary `#PObject` table for tracking deletions
2. Gets the next event sequence number from the parent
3. If `@bReparent = 0`, calls `call_RMPObject_Delete_Descendants` to recursively delete all children
4. Inserts a `RMPOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

## Validation Procedures

### call_RMTObject_Validate

Main validation procedure that validates access permissions and retrieves parent information.

#### Validation Rules

- `@twRPersonaIx` must be > 0
- `@twRMTObjectIx` must be > 0
- Object must exist in database
- Persona must have admin rights

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@ObjectHead_Parent_wClass` | SMALLINT OUTPUT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT OUTPUT | Parent object index |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @ObjectHead_Parent_wClass SMALLINT
DECLARE @ObjectHead_Parent_twObjectIx BIGINT
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @ObjectHead_Parent_wClass = @ObjectHead_Parent_wClass OUTPUT,
    @ObjectHead_Parent_twObjectIx = @ObjectHead_Parent_twObjectIx OUTPUT,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate(1, 100, @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @nError);
```

####

---

### call_RMTObject_Validate_Name

Validates the name for a terrestrial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Name to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Name_wsRMTObjectId` must not be NULL

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Name
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Name_wsRMTObjectId = 'Manhattan',
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Name(72, 100, 0, 'Manhattan', @nError);
```

####

---

### call_RMTObject_Validate_Type

Validates type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Type must not be NULL
- Subtype must not be NULL
- Fiction flag must not be NULL
- Fiction flag must be 0 or 1
- If parent is RMCObject: parent type must be SURFACE (17)
- If parent is RMTObject: child type must be >= parent type
- If parent is RMTObject and same type: child subtype must be > parent subtype

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Type
    @ObjectHead_Parent_wClass = 71,
    @ObjectHead_Parent_twObjectIx = 10,
    @twRMTObjectIx = 0,
    @Type_bType = 8,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Type(71, 10, 0, 8, 0, 0, @nError);
```

####

---

### call_RMTObject_Validate_Owner

Validates the owner persona index for a terrestrial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Owner_twRPersonaIx` must not be NULL
- `Owner_twRPersonaIx` must be between 1 and 0x0000FFFFFFFFFFFC

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Owner
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Owner_twRPersonaIx = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Owner(72, 100, 0, 1, @nError);
```

####

---

### call_RMTObject_Validate_Transform

Validates position, rotation, and scale values.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Validate_Transform
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 101,
    @Transform_Position_dX = 1000,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 500,
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
CALL call_RMTObject_Validate_Transform(
    72, 100, 101,
    1000, 0, 500,
    0, 0, 0, 1,
    1, 1, 1,
    nError
);
```

####

---

### call_RMTObject_Validate_Bound

Validates the bounding box dimensions for a terrestrial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Bound_dX`, `Bound_dY`, `Bound_dZ` must not be NULL or NaN
- All dimensions must be >= 0
- Bound must fit inside parent's bound (planned)
- Bound must contain all children's bounds (planned)

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Bound
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Bound_dX = 10000,
    @Bound_dY = 500,
    @Bound_dZ = 5000,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Bound(72, 100, 0, 10000, 500, 5000, @nError);
```

####

---

### call_RMTObject_Validate_Resource

Validates the resource reference fields for a terrestrial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
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

EXEC dbo.call_RMTObject_Validate_Resource
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Resource_qwResource = 3001,
    @Resource_sName = 'manhattan_terrain',
    @Resource_sReference = 'terrain/nyc/manhattan.bin',
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Resource(
    72, 100, 0,
    3001, 'manhattan_terrain', 'terrain/nyc/manhattan.bin',
    @nError
);
```

####

---

### call_RMTObject_Validate_Properties

Validates the properties for a terrestrial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Properties_bLockToGround` | TINYINT | Lock to ground surface |
| `@Properties_bYouth` | TINYINT | Youth content rating |
| `@Properties_bAdult` | TINYINT | Adult content rating |
| `@Properties_bAvatar` | TINYINT | Avatar access allowed |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All properties must not be NULL
- All properties must be 0 or 1

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Properties
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Properties(72, 100, 0, 1, 1, 0, 1, @nError);
```

####

---

### call_RMTObject_Validate_Coord_Geo

Validates geographic coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@dLatitude` | FLOAT(53) | Latitude in degrees |
| `@dLongitude` | FLOAT(53) | Longitude in degrees |
| `@dRadius` | FLOAT(53) | Radius (distance from center) |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Latitude must be -180 to +180
- Longitude must be -180 to +180
- Radius must not be 0

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Coord_Geo
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @dLatitude = 40.7128,
    @dLongitude = -74.0060,
    @dRadius = 6371,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Coord_Geo(72, 100, 0, 40.7128, -74.0060, 6371, @nError);
```

####

---

### call_RMTObject_Validate_Coord_Cyl

Validates cylindrical coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@dTheta` | FLOAT(53) | Angle in degrees (-180 to +180) |
| `@dY` | FLOAT(53) | Y coordinate |
| `@dRadius` | FLOAT(53) | Distance from axis |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Theta must be -180 to +180
- Y can be any value
- Radius must not be 0

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Coord_Cyl
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @dTheta = 45,
    @dY = 100,
    @dRadius = 500,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Coord_Cyl(72, 100, 0, 45, 100, 500, @nError);
```

####

---

### call_RMTObject_Validate_Coord_Car

Validates Cartesian coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@dX` | FLOAT(53) | X coordinate |
| `@dY` | FLOAT(53) | Y coordinate |
| `@dZ` | FLOAT(53) | Z coordinate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- X, Y, Z can be any finite values
- Values must not be NULL or NaN

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Coord_Car
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @dX = 1000,
    @dY = 0,
    @dZ = 500,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMTObject_Validate_Coord_Car(72, 100, 0, 1000, 0, 500, @nError);
```

####

---

### call_RMTObject_Validate_Coord_Nul

Validates transform values for the null coordinate system (direct Cartesian positioning without coordinate conversion).

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All position, rotation, and scale values must not be NULL or NaN

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMTObject_Validate_Coord_Nul
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 0,
    @Transform_Position_dX = 1000,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 500,
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
SET @nError = 0;

CALL call_RMTObject_Validate_Coord_Nul(
    72, 100, 0,
    1000, 0, 500,
    0, 0, 0, 1,
    1, 1, 1,
    @nError
);
```

####

---

## Geo Procedures

Geographic procedures handle Earth-like spherical coordinate systems.

### call_RMTObject_Parent_Geo

Finds the best parent object for a given geographic location. Used when placing objects on a surface.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx_Root` | BIGINT | Root terrestrial object to search from |
| `@bType_Min` | TINYINT | Minimum type level to consider |
| `@dLatitude` | FLOAT(53) | Latitude in degrees |
| `@dLongitude` | FLOAT(53) | Longitude in degrees |
| `@dRadius` | FLOAT(53) | Radius (distance from center) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Parent_Geo
    @twRMTObjectIx_Root = 100,
    @bType_Min = 5,            -- Minimum type (e.g., City level)
    @dLatitude = 40.7128,
    @dLongitude = -74.0060,
    @dRadius = 6371
```

##### MySQL

```sql
CALL call_RMTObject_Parent_Geo(100, 5, 40.7128, -74.0060, 6371);
```

####

---

## Matrix Procedures

Matrix procedures manage the 4x4 transformation matrices stored in `RMTMatrix`.

### call_RMTMatrix_Geo

Creates transformation matrices from geographic coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@dLatitude` | FLOAT(53) | Latitude in degrees |
| `@dLongitude` | FLOAT(53) | Longitude in degrees |
| `@dRadius` | FLOAT(53) | Radius (distance from center) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Geo
    @twRMTObjectIx = 101,
    @dLatitude = 40.7128,      -- NYC latitude
    @dLongitude = -74.0060,    -- NYC longitude
    @dRadius = 6371            -- Earth radius (km)
```

##### MySQL

```sql
CALL call_RMTMatrix_Geo(101, 40.7128, -74.0060, 6371);
```

####

#### How It Works

The procedure:
1. Converts lat/lon to radians
2. Calculates the position on the sphere
3. Builds a rotation matrix aligning local Y-up with surface normal
4. Stores the forward matrix in `RMTMatrix` (positive index)
5. Calculates and stores the inverse matrix (negative index)
6. Records the coordinate parameters in `RMTSubsurface`

---

### call_RMTMatrix_Cyl

Creates transformation matrices from cylindrical coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@dAngle` | FLOAT(53) | Angle in degrees (0-360) |
| `@dHeight` | FLOAT(53) | Height along axis |
| `@dRadius` | FLOAT(53) | Distance from axis |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Cyl
    @twRMTObjectIx = 101,
    @dAngle = 45,
    @dHeight = 100,
    @dRadius = 500
```

##### MySQL

```sql
CALL call_RMTMatrix_Cyl(101, 45, 100, 500);
```

####

---

### call_RMTMatrix_Car

Creates transformation matrices from Cartesian coordinates.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@dX` | FLOAT(53) | X coordinate |
| `@dY` | FLOAT(53) | Y coordinate |
| `@dZ` | FLOAT(53) | Z coordinate |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Car
    @twRMTObjectIx = 101,
    @dX = 1000,
    @dY = 0,
    @dZ = 500
```

##### MySQL

```sql
CALL call_RMTMatrix_Car(101, 1000, 0, 500);
```

####

---

### call_RMTMatrix_Nul

Creates transformation matrices for the null coordinate system. Applies position, rotation, and scale directly without coordinate conversion.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Nul
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 101,
    @Transform_Position_dX = 1000,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 500,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1
```

##### MySQL

```sql
CALL call_RMTMatrix_Nul(
    72, 100, 101,
    1000, 0, 500,
    0, 0, 0, 1,
    1, 1, 1
);
```

####

#### Behavior

1. Creates a `RMTSubsurface` record with coordinate type `NUL` (0)
2. Creates an identity matrix in `RMTMatrix`
3. If parent is a terrestrial object, multiplies by parent's matrix
4. Applies translation, rotation, and scale transformations
5. Creates the inverse matrix (negative index)

---

### call_RMTMatrix_Translate

Applies a translation to an existing matrix.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index (matrix index) |
| `@dX` | FLOAT(53) | Translation X |
| `@dY` | FLOAT(53) | Translation Y |
| `@dZ` | FLOAT(53) | Translation Z |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Translate
    @twRMTObjectIx = 101,
    @dX = 10,
    @dY = 0,
    @dZ = 5
```

##### MySQL

```sql
CALL call_RMTMatrix_Translate(101, 10, 0, 5);
```

####

---

### call_RMTMatrix_Rotate

Applies a rotation to an existing matrix using a quaternion.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bnMatrix_L` | BIGINT | Matrix index to modify |
| `@dX` | FLOAT(53) | Quaternion X component |
| `@dY` | FLOAT(53) | Quaternion Y component |
| `@dZ` | FLOAT(53) | Quaternion Z component |
| `@dW` | FLOAT(53) | Quaternion W component |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Rotate
    @bnMatrix_L = 101,
    @dX = 0,
    @dY = 0.7071,
    @dZ = 0,
    @dW = 0.7071
```

##### MySQL

```sql
CALL call_RMTMatrix_Rotate(101, 0, 0.7071, 0, 0.7071);
```

####

#### Behavior

Converts the quaternion to a 3x3 rotation matrix and multiplies it with the existing matrix using standard matrix multiplication.

---

### call_RMTMatrix_Scale

Applies a scale transformation to an existing matrix.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bnMatrix_L` | BIGINT | Matrix index to modify |
| `@dX` | FLOAT(53) | Scale factor X |
| `@dY` | FLOAT(53) | Scale factor Y |
| `@dZ` | FLOAT(53) | Scale factor Z |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Scale
    @bnMatrix_L = 101,
    @dX = 2.0,
    @dY = 2.0,
    @dZ = 2.0
```

##### MySQL

```sql
CALL call_RMTMatrix_Scale(101, 2.0, 2.0, 2.0);
```

####

#### Behavior

Creates a diagonal scale matrix and multiplies it with the existing matrix.

---

### call_RMTMatrix_Mult

Multiplies two matrices together, storing the result in the right matrix.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bnMatrix_R` | BIGINT | Right matrix index (result stored here) |
| `@bnMatrix_L` | BIGINT | Left matrix index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Mult
    @bnMatrix_R = 101,
    @bnMatrix_L = 100
```

##### MySQL

```sql
CALL call_RMTMatrix_Mult(101, 100);
```

####

#### Behavior

Performs standard 4x4 matrix multiplication: `R = L × R`

This is used to combine transformations, such as applying a parent's transformation to a child object.

---

### call_RMTMatrix_Inverse

Calculates the inverse of a matrix.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index (matrix index) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC @nResult = dbo.call_RMTMatrix_Inverse
    @twRMTObjectIx = 101
```

##### MySQL

```sql
CALL call_RMTMatrix_Inverse(101, @nResult);
```

####

This procedure:
1. Reads the forward matrix (positive index)
2. Calculates its inverse
3. Stores the inverse matrix (negative index)

---

### call_RMTMatrix_Relative

Calculates the relative transformation of an object with respect to its parent and updates the object's transform fields.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx` | BIGINT | Object index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTMatrix_Relative
    @ObjectHead_Parent_wClass = 72,
    @ObjectHead_Parent_twObjectIx = 100,
    @twRMTObjectIx = 101
```

##### MySQL

```sql
CALL call_RMTMatrix_Relative(72, 100, 101);
```

####

#### Behavior

1. If the parent is a terrestrial object, multiplies the object's matrix by the parent's inverse matrix
2. Otherwise, uses the object's matrix directly
3. Extracts translation from the matrix (column 3)
4. Extracts rotation as a quaternion from the rotation portion of the matrix
5. Extracts scale from the column magnitudes
6. Updates the object's `Transform_Position`, `Transform_Rotation`, and `Transform_Scale` fields

This procedure is used when reparenting objects to recalculate their local transform relative to a new parent.

---

## Utility Procedures

### call_RMTObject_Event

Gets the next event sequence number for the object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Object index |
| `@twEventIz` | BIGINT OUTPUT | Event sequence number |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twEventIz BIGINT

EXEC @bError = dbo.call_RMTObject_Event
    @twRMTObjectIx = 100,
    @twEventIz = @twEventIz OUTPUT
```

##### MySQL

```sql
CALL call_RMTObject_Event(100, @twEventIz);
```

####

---

### call_RMTObject_Select

Outputs terrestrial object data from the temporary results table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@nResultSet` | INT | Result set number to output |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Select 0
```

##### MySQL

```sql
CALL call_RMTObject_Select(0);
```

####

---

### call_RMTObject_Log

Logs an operation on the terrestrial object for auditing purposes.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bOp` | TINYINT | Operation code |
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Log
    @bOp = 1,                  -- Read operation
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100
```

##### MySQL

```sql
CALL call_RMTObject_Log(1, '127.0.0.1', 1, 100);
```

####

---

### call_RMTObject_Delete_Descendants

Recursively deletes all terrestrial descendants of a terrestrial object using a common table expression (CTE) to traverse the hierarchy.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMTObjectIx` | BIGINT | Root object index to delete from (NULL to use `#CObject` table) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMTObject_Delete_Descendants
    @twRMTObjectIx = 100
```

##### MySQL

```sql
CALL call_RMTObject_Delete_Descendants(100);
```

####

#### Behavior

1. If `@twRMTObjectIx` is NULL, uses the `#CObject` temporary table to find celestial parents
2. Uses a recursive CTE to find all terrestrial descendants in the hierarchy
3. Inserts all found object indices into the `#TObject` temporary table
4. Deletes associated `RMTMatrix` records (both forward and inverse matrices)
5. Deletes associated `RMTSubsurface` records
6. Deletes all objects from `RMTObject` that match the collected indices
7. Returns error if fewer rows were deleted than expected

#### Dependencies

This procedure expects the following temporary tables to exist:
- `#TObject` — Stores object indices to delete
- `#CObject` — (Optional) Contains celestial objects when `@twRMTObjectIx` is NULL

---

## Matrix Storage

Matrices are stored in the `RMTMatrix` table with the following structure:

| Column | Description |
|--------|-------------|
| `bnMatrix` | Object index (positive = forward, negative = inverse) |
| `d00` - `d33` | 4x4 matrix elements |

The matrix layout follows standard 3D graphics conventions:

```
| d00  d01  d02  d03 |   | Xx  Yx  Zx  Tx |
| d10  d11  d12  d13 | = | Xy  Yy  Zy  Ty |
| d20  d21  d22  d23 |   | Xz  Yz  Zz  Tz |
| d30  d31  d32  d33 |   | 0   0   0   1  |
```

Where:
- **X, Y, Z columns**: Rotation/scale (basis vectors)
- **T column**: Translation
- **Bottom row**: Always [0, 0, 0, 1] for affine transforms

---

**See also:** [RMTObject](../RMTObject) | [RMTObject Get Procedures](./Get) | [RMTObject Search Procedures](./Search) | [RMTObject Set Procedures](./Set) | [Event System](../Event-System)
