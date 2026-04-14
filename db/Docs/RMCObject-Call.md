# RMCObject Call Procedures

Call procedures are internal procedures for events, validation, and utilities.

## Event Procedures

### call_RMCObject_Event_Name

Generates an event when the object's name changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Name
    @twRMCObjectIx = 4,
    @Name_wsRMCObjectId = 'Terra'
```

##### MySQL

```sql
CALL call_RMCObject_Event_Name(4, 'Terra');
```

####

#### Generated Event

```json
{
  "pName": {
    "wsRMCObjectId": "Terra"
  }
}
```

---

### call_RMCObject_Event_Type

Generates an event when the celestial object's type classification changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | Celestial type (0-8) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Type
    @twRMCObjectIx = 4,
    @Type_bType = 3,           -- Planet
    @Type_bSubtype = 1,        -- Terrestrial
    @Type_bFiction = 0
```

##### MySQL

```sql
CALL call_RMCObject_Event_Type(4, 3, 1, 0);
```

####

#### Generated Event

```json
{
  "pType": {
    "bType": 3,
    "bSubtype": 1,
    "bFiction": 0
  }
}
```

---

### call_RMCObject_Event_Owner

Generates an event when ownership of the celestial object changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Owner
    @twRMCObjectIx = 4,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL call_RMCObject_Event_Owner(4, 2);
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

### call_RMCObject_Event_Transform

Generates an event when position/rotation/scale changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Transform
    @twRMCObjectIx = 4,
    @Transform_Position_dX = 149597870.7,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 0,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0.119,
    @Transform_Rotation_dW = 0.993,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1
```

##### MySQL

```sql
CALL call_RMCObject_Event_Transform(
    4,
    149597870.7, 0, 0,
    0, 0, 0.119, 0.993,
    1, 1, 1
);
```

####

#### Generated Event

```json
{
  "pTransform": {
    "Position": [149597870.7, 0, 0],
    "Rotation": [0, 0, 0.119, 0.993],
    "Scale": [1, 1, 1]
  }
}
```

---

### call_RMCObject_Event_Bound

Generates an event when the celestial object's bounding box dimensions change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension (radius) |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension (radius) |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension (radius) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Bound
    @twRMCObjectIx = 4,
    @Bound_dX = 6371,          -- Earth radius in km
    @Bound_dY = 6371,
    @Bound_dZ = 6371
```

##### MySQL

```sql
CALL call_RMCObject_Event_Bound(4, 6371, 6371, 6371);
```

####

#### Generated Event

```json
{
  "pBound": {
    "Max": [6371, 6371, 6371]
  }
}
```

---

### call_RMCObject_Event_Resource

Generates an event when the celestial object's resource reference (3D model, texture, etc.) changes. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Resource
    @twRMCObjectIx = 4,
    @Resource_qwResource = 1001,
    @Resource_sName = 'earth_hd',
    @Resource_sReference = 'models/planets/earth_8k.glb'
```

##### MySQL

```sql
CALL call_RMCObject_Event_Resource(
    4,
    1001,
    'earth_hd',
    'models/planets/earth_8k.glb'
);
```

####

#### Generated Event

```json
{
  "pResource": {
    "qwResource": 1001,
    "sName": "earth_hd",
    "sReference": "models/planets/earth_8k.glb"
  }
}
```

---

### call_RMCObject_Event_Properties

Generates an event when physical properties change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Properties_fMass` | FLOAT(24) | Mass |
| `@Properties_fGravity` | FLOAT(24) | Surface gravity |
| `@Properties_fColor` | FLOAT(24) | Color temperature |
| `@Properties_fBrightness` | FLOAT(24) | Brightness |
| `@Properties_fReflectivity` | FLOAT(24) | Reflectivity (0-1) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Properties
    @twRMCObjectIx = 4,
    @Properties_fMass = 0.000003,
    @Properties_fGravity = 9.8,
    @Properties_fColor = 288,
    @Properties_fBrightness = 0,
    @Properties_fReflectivity = 0.3
```

##### MySQL

```sql
CALL call_RMCObject_Event_Properties(4, 0.000003, 9.8, 288, 0, 0.3);
```

####

#### Generated Event

```json
{
  "pProperties": {
    "fMass": 0.000003,
    "fGravity": 9.8,
    "fColor": 288,
    "fBrightness": 0,
    "fReflectivity": 0.3
  }
}
```

---

### call_RMCObject_Event_Orbit_Spin

Generates an event when orbital parameters change. Updates the database and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Orbit_Spin_tmPeriod` | FLOAT(53) | Orbital period (milliseconds) |
| `@Orbit_Spin_tmStart` | FLOAT(53) | Orbit start time |
| `@Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `@Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_Orbit_Spin
    @twRMCObjectIx = 4,
    @Orbit_Spin_tmPeriod = 31557600000,
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 149597870.7,
    @Orbit_Spin_dB = 149577000
```

##### MySQL

```sql
CALL call_RMCObject_Event_Orbit_Spin(4, 31557600000, 0, 149597870.7, 149577000);
```

####

#### Generated Event

```json
{
  "pOrbit_Spin": {
    "tmPeriod": 31557600000,
    "tmStart": 0,
    "dA": 149597870.7,
    "dB": 149577000
  }
}
```

---

### call_RMCObject_Event_RMCObject_Open

Generates an event when a new celestial child object is created (e.g., a moon under a planet). Inserts the new object into the database and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Parent celestial object index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | Child object name |
| `@Type_bType` | TINYINT | Celestial type (0-8) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@Orbit_Spin_tmPeriod` | BIGINT | Orbital period (milliseconds) |
| `@Orbit_Spin_tmStart` | BIGINT | Orbit start time |
| `@Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `@Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |
| `@Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |
| `@Properties_fMass` | FLOAT(24) | Mass |
| `@Properties_fGravity` | FLOAT(24) | Surface gravity |
| `@Properties_fColor` | FLOAT(24) | Color temperature |
| `@Properties_fBrightness` | FLOAT(24) | Brightness |
| `@Properties_fReflectivity` | FLOAT(24) | Reflectivity (0-1) |
| `@twRMCObjectIx_Open` | BIGINT OUTPUT | Created child object index |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twMoonIx BIGINT

EXEC dbo.call_RMCObject_Event_RMCObject_Open
    @twRMCObjectIx = 4,        -- Earth
    @Name_wsRMCObjectId = 'Luna',
    @Type_bType = 4,           -- Moon
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'moon',
    @Resource_sReference = 'models/moons/luna.glb',
    @Transform_Position_dX = 384400,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 0,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Orbit_Spin_tmPeriod = 2360592000,
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 384400,
    @Orbit_Spin_dB = 383000,
    @Bound_dX = 1737,
    @Bound_dY = 1737,
    @Bound_dZ = 1737,
    @Properties_fMass = 0.0123,
    @Properties_fGravity = 1.62,
    @Properties_fColor = 250,
    @Properties_fBrightness = 0,
    @Properties_fReflectivity = 0.12,
    @twRMCObjectIx_Open = @twMoonIx OUTPUT
```

##### MySQL

```sql
SET @twMoonIx = 0;

CALL call_RMCObject_Event_RMCObject_Open(
    4, 'Luna', 4, 0, 0, 1,
    0, 'moon', 'models/moons/luna.glb',
    384400, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    2360592000, 0, 384400, 383000,
    1737, 1737, 1737,
    0.0123, 1.62, 250, 0, 0.12,
    @twMoonIx
);
```

####

---

### call_RMCObject_Event_RMCObject_Close

Generates an event when a celestial child object is deleted. Recursively deletes all descendants (celestial, terrestrial, and physical) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Parent celestial object index |
| `@twRMCObjectIx_Close` | BIGINT | Child celestial object index to delete |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_RMCObject_Close
    @twRMCObjectIx = 4,
    @twRMCObjectIx_Close = 5
```

##### MySQL

```sql
CALL call_RMCObject_Event_RMCObject_Close(4, 5);
```

####

#### Behavior

1. Creates temporary tables for tracking deletions (`#CObject`, `#TObject`, `#PObject`)
2. Gets the next event sequence number from the parent
3. Calls `call_RMCObject_Delete_Descendants` to recursively delete all celestial descendants
4. Calls `call_RMTObject_Delete_Descendants` to delete terrestrial descendants
5. Calls `call_RMPObject_Delete_Descendants` to delete physical descendants
6. Inserts a `RMCOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

### call_RMCObject_Event_RMTObject_Open

Generates an event when a new terrestrial child object is created on a celestial surface. Inserts the new object into the database and inserts an event record into the `#Event` temporary table with complete child object data.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Parent celestial object index |
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
DECLARE @twContinentIx BIGINT

EXEC dbo.call_RMCObject_Event_RMTObject_Open
    @twRMCObjectIx = 10,       -- Earth Surface
    @Name_wsRMTObjectId = 'North America',
    @Type_bType = 1,           -- Continent
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
    @Bound_dX = 5000000,
    @Bound_dY = 1000,
    @Bound_dZ = 5000000,
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1,
    @twRMTObjectIx = @twContinentIx OUTPUT
```

##### MySQL

```sql
SET @twContinentIx = 0;

CALL call_RMCObject_Event_RMTObject_Open(
    10, 'North America', 1, 0, 0, 1,
    0, '', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    5000000, 1000, 5000000,
    1, 1, 0, 1,
    @twContinentIx
);
```

####

---

### call_RMCObject_Event_RMTObject_Close

Generates an event when a terrestrial child object is deleted from a celestial surface. Recursively deletes all descendants (terrestrial and physical) and inserts an event record into the `#Event` temporary table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Parent celestial object index |
| `@twRMTObjectIx_Close` | BIGINT | Child terrestrial object index to delete |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Event_RMTObject_Close
    @twRMCObjectIx = 10,
    @twRMTObjectIx_Close = 100
```

##### MySQL

```sql
CALL call_RMCObject_Event_RMTObject_Close(10, 100);
```

####

#### Behavior

1. Creates temporary tables for tracking deletions (`#TObject`, `#PObject`)
2. Gets the next event sequence number from the parent
3. Calls `call_RMTObject_Delete_Descendants` to recursively delete all terrestrial descendants
4. Calls `call_RMPObject_Delete_Descendants` to delete physical descendants
5. Inserts a `RMTOBJECT_CLOSE` event with flag `0x02` (CLOSE)

---

## Validation Procedures

### call_RMCObject_Validate

Main validation procedure that validates access permissions and retrieves parent information.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@ObjectHead_Parent_wClass` | SMALLINT OUTPUT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT OUTPUT | Parent object index |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @ObjectHead_Parent_wClass SMALLINT
DECLARE @ObjectHead_Parent_twObjectIx BIGINT
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @ObjectHead_Parent_wClass = @ObjectHead_Parent_wClass OUTPUT,
    @ObjectHead_Parent_twObjectIx = @ObjectHead_Parent_twObjectIx OUTPUT,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate(1, 4, @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @nError);
```

####

---

### call_RMCObject_Validate_Name

Validates a celestial object name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | Name to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Name must not be NULL

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate_Name
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Name_wsRMCObjectId = 'Earth',
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Name(70, 1, 0, 'Earth', @nError);
```

####

---

### call_RMCObject_Validate_Type

Validates type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Type_bType` | TINYINT | Celestial type (0-8) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Type must not be NULL
- Subtype must not be NULL
- Fiction flag must not be NULL
- Fiction flag must be 0 or 1
- If parent is RMCObject: child type must be greater than parent type
- If parent is RMCObject and same type: child subtype must be greater than parent subtype

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate_Type
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Type_bType = 3,
    @Type_bSubtype = 1,
    @Type_bFiction = 0,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Type(70, 1, 0, 3, 1, 0, @nError);
```

####

---

### call_RMCObject_Validate_Owner

Validates the owner persona index for a celestial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index to validate |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- `Owner_twRPersonaIx` must not be NULL
- `Owner_twRPersonaIx` must be between 1 and 0x0000FFFFFFFFFFFC

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate_Owner
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Owner_twRPersonaIx = 1,
    @nError = @nError OUTPUT

IF @nError > 0
    SELECT dwError, sError FROM #Error
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Owner(70, 1, 0, 1, @nError);

IF @nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;
```

####

---

### call_RMCObject_Validate_Transform

Validates position, rotation, and scale values.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All values must not be NULL
- All values must not be NaN

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Validate_Transform
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
    @nError = @nError OUTPUT
```

##### MySQL

```sql
CALL call_RMCObject_Validate_Transform(
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    nError
);
```

####

---

### call_RMCObject_Validate_Bound

Validates bounding box dimensions.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
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

EXEC dbo.call_RMCObject_Validate_Bound
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Bound_dX = 6371,
    @Bound_dY = 6371,
    @Bound_dZ = 6371,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Bound(70, 1, 0, 6371, 6371, 6371, @nError);
```

####

---

### call_RMCObject_Validate_Resource

Validates the resource reference fields for a celestial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
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

EXEC dbo.call_RMCObject_Validate_Resource
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Resource_qwResource = 1001,
    @Resource_sName = 'earth_hd',
    @Resource_sReference = 'models/planets/earth_8k.glb',
    @nError = @nError OUTPUT

IF @nError > 0
    SELECT dwError, sError FROM #Error
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Resource(
    70, 1, 0,
    1001, 'earth_hd', 'models/planets/earth_8k.glb',
    @nError
);

IF @nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;
```

####

---

### call_RMCObject_Validate_Properties

Validates physical properties.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Properties_fMass` | FLOAT(24) | Mass |
| `@Properties_fGravity` | FLOAT(24) | Surface gravity |
| `@Properties_fColor` | FLOAT(24) | Color temperature |
| `@Properties_fBrightness` | FLOAT(24) | Brightness |
| `@Properties_fReflectivity` | FLOAT(24) | Reflectivity (0-1) |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- All properties must not be NULL
- Mass must be >= 0
- Gravity must be >= 0
- Color (temperature) must be >= 0
- Brightness must be >= 0
- Reflectivity must be >= 0

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate_Properties
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Properties_fMass = 0.000003,
    @Properties_fGravity = 9.8,
    @Properties_fColor = 288,
    @Properties_fBrightness = 0,
    @Properties_fReflectivity = 0.3,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Properties(70, 1, 0, 0.000003, 9.8, 288, 0, 0.3, @nError);
```

####

---

### call_RMCObject_Validate_Orbit_Spin

Validates orbital parameters.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@ObjectHead_Parent_wClass` | SMALLINT | Parent class ID |
| `@ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx` | BIGINT | Object index (0 for new objects) |
| `@Orbit_Spin_tmPeriod` | FLOAT(53) | Orbital period (milliseconds) |
| `@Orbit_Spin_tmStart` | FLOAT(53) | Orbit start time |
| `@Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `@Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |
| `@nError` | INT OUTPUT | Error count (default 0) |

#### Validation Rules

- Period must be >= 0
- Start time must be between 0 and period
- Semi-major axis (dA) must be >= 0
- Semi-minor axis (dB) must be >= 0

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @nError INT = 0

EXEC dbo.call_RMCObject_Validate_Orbit_Spin
    @ObjectHead_Parent_wClass = 70,
    @ObjectHead_Parent_twObjectIx = 1,
    @twRMCObjectIx = 0,
    @Orbit_Spin_tmPeriod = 31557600000,
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 149597870.7,
    @Orbit_Spin_dB = 149577000,
    @nError = @nError OUTPUT
```

##### MySQL

```sql
SET @nError = 0;

CALL call_RMCObject_Validate_Orbit_Spin(70, 1, 0, 31557600000, 0, 149597870.7, 149577000, @nError);
```

####

---

## Utility Procedures

### call_RMCObject_Event

Gets the next event sequence number for the object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Object index |
| `@twEventIz` | BIGINT OUTPUT | Event sequence number |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twEventIz BIGINT

EXEC @bError = dbo.call_RMCObject_Event
    @twRMCObjectIx = 4,
    @twEventIz = @twEventIz OUTPUT
```

##### MySQL

```sql
CALL call_RMCObject_Event(4, @twEventIz);
```

####

---

### call_RMCObject_Select

Outputs celestial object data from the temporary results table.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@nResultSet` | INT | Result set number to output |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Select 0
```

##### MySQL

```sql
CALL call_RMCObject_Select(0);
```

####

---

### call_RMCObject_Log

Logs an operation on the celestial object for auditing purposes.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@bOp` | TINYINT | Operation code |
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Log
    @bOp = 1,                  -- Read operation
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4
```

##### MySQL

```sql
CALL call_RMCObject_Log(1, '127.0.0.1', 1, 4);
```

####

---

### call_RMCObject_Delete_Descendants

Recursively deletes all celestial descendants of a celestial object using a common table expression (CTE) to traverse the hierarchy.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@twRMCObjectIx` | BIGINT | Root object index to delete from (NULL to use `#Roots` table) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.call_RMCObject_Delete_Descendants
    @twRMCObjectIx = 4
```

##### MySQL

```sql
CALL call_RMCObject_Delete_Descendants(4);
```

####

#### Behavior

1. If `@twRMCObjectIx` is NULL, uses the `#Roots` temporary table to find root objects
2. Uses a recursive CTE to find all celestial descendants in the hierarchy
3. Inserts all found object indices into the `#CObject` temporary table
4. Deletes all objects from `RMCObject` that match the collected indices
5. Returns error if fewer rows were deleted than expected

#### Dependencies

This procedure expects the following temporary tables to exist:
- `#CObject` — Stores object indices to delete
- `#Roots` — (Optional) Contains root objects when `@twRMCObjectIx` is NULL

---

**See also:** [RMCObject](../RMCObject) | [RMCObject Get Procedures](./Get) | [RMCObject Search Procedures](./Search) | [RMCObject Set Procedures](./Set) | [Event System](../Event-System)
