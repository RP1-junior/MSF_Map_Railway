# RMTObject Set Procedures

Set procedures modify RMTObject data and manage child objects.

## Property Modification

### set_RMTObject_Name

Updates the terrestrial object's name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Name
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Name_wsRMTObjectId = 'New York'
```

##### MySQL

```sql
CALL set_RMTObject_Name('127.0.0.1', 1, 100, 'New York', @nResult);
```

####

---

### set_RMTObject_Type

Updates the terrestrial object's type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Type
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Type_bType = 6,           -- City
    @Type_bSubtype = 0,
    @Type_bFiction = 0
```

##### MySQL

```sql
CALL set_RMTObject_Type('127.0.0.1', 1, 100, 6, 0, 0, @nResult);
```

####

---

### set_RMTObject_Owner

Transfers ownership of the terrestrial object to a new persona. Validates the new owner and generates an ownership change event.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address for audit logging |
| `@twRPersonaIx` | BIGINT | Session persona index (must have permission) |
| `@twRMTObjectIx` | BIGINT | Terrestrial object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Owner
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Owner_twRPersonaIx = 42
```

##### MySQL

```sql
CALL set_RMTObject_Owner('127.0.0.1', 1, 100, 42, @nResult);
SELECT @nResult;
```

####

#### Behavior

1. Validates the calling persona has permission to modify the object
2. Validates the owner persona index is not NULL and within valid range
3. Updates the owner and generates an `OWNER` event
4. Logs the operation with operation code `RMTOBJECT_OP_OWNER` (3)
5. Pushes events to connected clients

---

### set_RMTObject_Transform

Updates position, rotation, and scale. This also updates the transformation matrices.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | New position |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | New rotation (quaternion) |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | New scale |
| `@bCoord` | TINYINT | Coordinate system (0=Geo, 1=Cyl, 2=Car, 3=Nul). Note: the SQL declares constants with the inverse mapping, but the IF-chain uses this order |
| `@dA` | FLOAT(53) | First coordinate (x, angle, or latitude) |
| `@dB` | FLOAT(53) | Second coordinate (y, height, or longitude) |
| `@dC` | FLOAT(53) | Third coordinate (z, radius, or radius) |

#### Tabs {.tabset}

##### SQL Server

```sql
-- Using Geographic coordinates
EXEC dbo.set_RMTObject_Transform
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
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
    @bCoord = 3,               -- Geographic
    @dA = 40.7128,             -- Latitude
    @dB = -74.0060,            -- Longitude
    @dC = 6371                 -- Radius
```

##### MySQL

```sql
CALL set_RMTObject_Transform(
    '127.0.0.1', 1, 100,
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    3,                         -- Geographic
    40.7128, -74.0060, 6371,
    @nResult
);
```

####

---

### set_RMTObject_Bound

Updates the bounding box dimensions for a terrestrial object. The bounding box defines the spatial extent used for visibility culling and collision detection.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address for audit logging |
| `@twRPersonaIx` | BIGINT | Session persona index (must have permission) |
| `@twRMTObjectIx` | BIGINT | Terrestrial object index |
| `@Bound_dX` | FLOAT(53) | Bounding box width (X dimension) |
| `@Bound_dY` | FLOAT(53) | Bounding box height (Y dimension) |
| `@Bound_dZ` | FLOAT(53) | Bounding box depth (Z dimension) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Bound
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Bound_dX = 1000.0,
    @Bound_dY = 500.0,
    @Bound_dZ = 1000.0
```

##### MySQL

```sql
CALL set_RMTObject_Bound('127.0.0.1', 1, 100, 1000.0, 500.0, 1000.0, @nResult);
SELECT @nResult;
```

####

#### Behavior

1. Validates the calling persona has permission to modify the object
2. Validates the bounding box dimensions are acceptable
3. Updates the bounding box and generates a `BOUND` event
4. Logs the operation with operation code `RMTOBJECT_OP_BOUND` (8)
5. Pushes events to connected clients

---

### set_RMTObject_Resource

Updates the resource reference for a terrestrial object. Resources define the visual representation or data associated with the object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address for audit logging |
| `@twRPersonaIx` | BIGINT | Session persona index (must have permission) |
| `@twRMTObjectIx` | BIGINT | Terrestrial object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path or URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Resource
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Resource_qwResource = 5001,
    @Resource_sName = 'terrain_heightmap',
    @Resource_sReference = '/assets/terrain/heightmap_001.png'
```

##### MySQL

```sql
CALL set_RMTObject_Resource('127.0.0.1', 1, 100, 5001, 'terrain_heightmap', '/assets/terrain/heightmap_001.png', @nResult);
SELECT @nResult;
```

####

#### Behavior

1. Validates the calling persona has permission to modify the object
2. Validates the resource reference is valid
3. Updates the resource and generates a `RESOURCE` event
4. Logs the operation with operation code `RMTOBJECT_OP_RESOURCE` (4)
5. Pushes events to connected clients

---

### set_RMTObject_Properties

Updates terrestrial object properties.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Object index |
| `@Properties_bLockToGround` | TINYINT | Lock to ground surface |
| `@Properties_bYouth` | TINYINT | Youth content rating |
| `@Properties_bAdult` | TINYINT | Adult content rating |
| `@Properties_bAvatar` | TINYINT | Avatar access allowed |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Properties
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1
```

##### MySQL

```sql
CALL set_RMTObject_Properties('127.0.0.1', 1, 100, 1, 1, 0, 1, @nResult);
```

####

---

## Child Object Creation

### set_RMTObject_RMTObject_Open

Creates a new terrestrial object as a child.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Parent object index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Child name |
| `@Type_bType` | TINYINT | Terrestrial type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Bound_*` | Various | Bounding box |
| `@Properties_bLockToGround` | TINYINT | Lock to ground |
| `@Properties_bYouth` | TINYINT | Youth content |
| `@Properties_bAdult` | TINYINT | Adult content |
| `@Properties_bAvatar` | TINYINT | Avatar access |
| `@bCoord` | TINYINT | Coordinate system (0=Geo, 1=Cyl, 2=Car, 3=Nul). Note: the SQL declares constants with the inverse mapping, but the IF-chain uses this order |
| `@dA`, `@dB`, `@dC` | FLOAT(53) | Coordinates |

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twDistrictIx BIGINT

EXEC dbo.set_RMTObject_RMTObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,      -- Parent (city)
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
    @Bound_dX = 21600,         -- ~21.6km long
    @Bound_dY = 100,
    @Bound_dZ = 3700,          -- ~3.7km wide
    @Properties_bLockToGround = 1,
    @Properties_bYouth = 1,
    @Properties_bAdult = 0,
    @Properties_bAvatar = 1,
    @bCoord = 3,               -- Geographic
    @dA = 40.7831,             -- Latitude
    @dB = -73.9712,            -- Longitude
    @dC = 6371                 -- Radius
```

##### MySQL

```sql
SET @twDistrictIx = 0;

CALL set_RMTObject_RMTObject_Open(
    '127.0.0.1', 1, 100,
    'Manhattan', 7, 0, 0, 1,
    0, '', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    21600, 100, 3700,
    1, 1, 0, 1,
    3, 40.7831, -73.9712, 6371,
    @twDistrictIx
);
```

####

---

### set_RMTObject_RMPObject_Open

Creates a new physical object as a child.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Parent terrestrial object index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | Child name |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Bound_*` | Various | Bounding box |

#### Returns

Returns a single result set with column `twRMPObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
DECLARE @twBuildingIx BIGINT

EXEC dbo.set_RMTObject_RMPObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 101,      -- Parent (Manhattan)
    @Name_wsRMPObjectId = 'Empire State Building',
    @Type_bType = 0,           -- Building
    @Type_bSubtype = 1,        -- Skyscraper
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'esb',
    @Resource_sReference = 'models/buildings/esb.glb',
    @Transform_Position_dX = 500,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 200,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 57,            -- 57m x 443m x 129m
    @Bound_dY = 443,
    @Bound_dZ = 129,
    @twRMPObjectIx = @twBuildingIx OUTPUT
```

##### MySQL

```sql
SET @twBuildingIx = 0;

CALL set_RMTObject_RMPObject_Open(
    '127.0.0.1', 1, 101,
    'Empire State Building', 0, 1, 1,
    0, 'esb', 'models/buildings/esb.glb',
    500, 0, 200,
    0, 0, 0, 1,
    1, 1, 1,
    57, 443, 129,
    @twBuildingIx
);
```

####

---

## Child Object Deletion

### set_RMTObject_RMTObject_Close

Deletes a terrestrial child object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx_Close` | BIGINT | Child object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_RMTObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @twRMTObjectIx_Close = 101,
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMTObject_RMTObject_Close('127.0.0.1', 1, 100, 101, 1, @nResult);
```

####

#### Behavior

- Validates the parent object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all terrestrial and physical descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates close events for all deleted objects
- Cannot be undone

---

### set_RMTObject_RMPObject_Close

Deletes a physical child object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx_Close` | BIGINT | Child object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_RMPObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,
    @twRMPObjectIx_Close = 1001,
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMTObject_RMPObject_Close('127.0.0.1', 1, 100, 1001, 1, @nResult);
```

####

#### Behavior

- Validates the parent object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all physical descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates close events for all deleted objects
- Cannot be undone

---

## Fabric Procedures

Fabric procedures manage the spatial fabric configuration for terrestrial objects. These create pre-configured terrestrial hierarchies.

### set_RMTObject_Fabric_Open_Earth / set_RMTObject_Fabric_Open_Misc

Creates a new fabric (terrestrial object hierarchy) with specified coordinate system. There is no single `set_RMTObject_Fabric_Open` procedure — there are two variant procedures: `set_RMTObject_Fabric_Open_Earth` for Earth-like geographic coordinates and `set_RMTObject_Fabric_Open_Misc` for custom configurations.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx_Root` | BIGINT | Root terrestrial object |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Fabric name |
| `@Type_bType` | TINYINT | Terrestrial type |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Bound_*` | Various | Bounding box |
| `@Transform_Rotate` | FLOAT(53) | Rotation offset |
| `@bCoord` | TINYINT | Coordinate system |
| `@dA`, `@dB`, `@dC` | FLOAT(53) | Coordinates |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Fabric_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx_Root = 100,
    @Name_wsRMTObjectId = 'New York Region',
    @Type_bType = 5,           -- Region
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
    @Bound_dX = 100000,
    @Bound_dY = 1000,
    @Bound_dZ = 100000,
    @Transform_Rotate = 0,
    @bCoord = 3,               -- Geographic
    @dA = 40.7128,             -- Latitude
    @dB = -74.0060,            -- Longitude
    @dC = 6371                 -- Radius
```

##### MySQL

```sql
CALL set_RMTObject_Fabric_Open(
    '127.0.0.1', 1, 100,
    'New York Region', 5, 1,
    0, '', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    100000, 1000, 100000,
    0,
    3, 40.7128, -74.0060, 6371
);
```

####

---

### set_RMTObject_Fabric_Configure

Configures fabric parameters for an existing physical object that acts as a fabric container.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx_Configure` | BIGINT | Physical object to configure |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Fabric name |
| `@Type_bType` | TINYINT | Terrestrial type |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Fabric_Configure
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx_Configure = 1000,
    @Name_wsRMTObjectId = 'Building Interior',
    @Type_bType = 10,          -- Parcel
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = '',
    @Resource_sReference = ''
```

##### MySQL

```sql
CALL set_RMTObject_Fabric_Configure(
    '127.0.0.1', 1, 1000,
    'Building Interior', 10, 1,
    0, '', ''
);
```

####

---

### set_RMTObject_Fabric_Close

Removes fabric configuration from a physical object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx_Close` | BIGINT | Physical object to unconfigure |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMTObject_Fabric_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx_Close = 1000
```

##### MySQL

```sql
CALL set_RMTObject_Fabric_Close('127.0.0.1', 1, 1000);
```

####

---

**See also:** [RMTObject](../RMTObject) | [RMTObject Get Procedures](./Get) | [RMTObject Search Procedures](./Search) | [RMTObject Call Procedures](./Call)
