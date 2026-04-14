# RMRoot Set Procedures

Set procedures modify RMRoot data and create or delete child objects. All set procedures generate events for real-time synchronization.

## Property Modification

### set_RMRoot_Name

Updates the root object's name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Root object index |
| `@Name_wsRMRootId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_Name
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMRootId = 'My Universe'
```

##### MySQL

```sql
CALL set_RMRoot_Name('127.0.0.1', 1, 1, 'My Universe', @nResult);
```

####

---

### set_RMRoot_Owner

Transfers ownership of the root object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Root object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner's persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_Owner
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL set_RMRoot_Owner('127.0.0.1', 1, 1, 2, @nResult);
```

####

---

## Child Object Creation

### set_RMRoot_RMCObject_Open

Creates a new celestial object as a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | Object name |
| `@Type_bType` | TINYINT | Celestial type (0-8) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | Fiction flag (0=real, 1=fictional) |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource reference/path |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | Position coordinates |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `@Orbit_Spin_tmPeriod` | BIGINT | Orbit/spin period (ms) |
| `@Orbit_Spin_tmStart` | BIGINT | Orbit/spin start time |
| `@Orbit_Spin_dA` | FLOAT(53) | Orbit semi-major axis |
| `@Orbit_Spin_dB` | FLOAT(53) | Orbit semi-minor axis |
| `@Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |
| `@Properties_fMass` | FLOAT(24) | Mass |
| `@Properties_fGravity` | FLOAT(24) | Gravity |
| `@Properties_fColor` | FLOAT(24) | Color temperature |
| `@Properties_fBrightness` | FLOAT(24) | Brightness |
| `@Properties_fReflectivity` | FLOAT(24) | Reflectivity |
| `@twRMCObjectIx` | BIGINT | Created object index (returned via SELECT result set) |

#### Returns

Returns a single result set with column `twRMCObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMCObjectId = 'Sol',
    @Type_bType = 2,           -- Star
    @Type_bSubtype = 0,        -- G-type main sequence
    @Type_bFiction = 0,        -- Real
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'star_yellow',
    @Resource_sReference = 'models/stars/g-type.glb',
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
    @Orbit_Spin_tmPeriod = 2160000000,  -- 25 days in ms
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 0,
    @Orbit_Spin_dB = 0,
    @Bound_dX = 696340,        -- Solar radius in km
    @Bound_dY = 696340,
    @Bound_dZ = 696340,
    @Properties_fMass = 1.0,
    @Properties_fGravity = 274,
    @Properties_fColor = 5778,  -- Kelvin
    @Properties_fBrightness = 1.0,
    @Properties_fReflectivity = 0
-- Returns result set: twRMCObjectIx
```

##### MySQL

```sql
SET @twRMCObjectIx = 0;

CALL set_RMRoot_RMCObject_Open(
    '127.0.0.1',
    1, 1,                      -- Persona, Root
    'Sol',                     -- Name
    2, 0, 0,                   -- Type, Subtype, Fiction
    1,                         -- Owner
    0, 'star_yellow', 'models/stars/g-type.glb',  -- Resource
    0, 0, 0,                   -- Position
    0, 0, 0, 1,                -- Rotation
    1, 1, 1,                   -- Scale
    2160000000, 0, 0, 0,       -- Orbit/Spin
    696340, 696340, 696340,    -- Bound
    1.0, 274, 5778, 1.0, 0,    -- Properties
    @twRMCObjectIx
);

SELECT @twRMCObjectIx AS NewStarId;
```

####

---

### set_RMRoot_RMTObject_Open

Creates a new terrestrial object as a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Object name |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position, rotation, scale |
| `@Bound_*` | Various | Bounding box |
| `@Properties_*` | Various | Terrain properties |
| `@bCoord` | TINYINT | Coordinate system (0=Geo, 1=Cyl, 2=Car, 3=Nul) |
| `@dA` | FLOAT(53) | Coordinate A value |
| `@dB` | FLOAT(53) | Coordinate B value |
| `@dC` | FLOAT(53) | Coordinate C value |
| `@twRMTObjectIx` | BIGINT | Created object index (returned via SELECT result set) |

#### Returns

Returns a single result set with column `twRMTObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMTObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMTObjectId = 'Test Region',
    @Type_bType = 8,           -- Parcel
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
    @bCoord = 0,               -- Geo
    @dA = 0, @dB = 0, @dC = 0
-- Returns result set: twRMTObjectIx
```

##### MySQL

```sql
SET @twRMTObjectIx = 0;

CALL set_RMRoot_RMTObject_Open(
    '127.0.0.1',
    1, 1,
    'Test Region',
    8, 0,
    1,
    -- ... additional parameters ...
    @twRMTObjectIx
);
```

####

---

### set_RMRoot_RMPObject_Open

Creates a new physical object as a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | Object name |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position, rotation, scale |
| `@Bound_*` | Various | Bounding box |
| `@twRMPObjectIx` | BIGINT | Created object index (returned via SELECT result set) |

#### Returns

Returns a single result set with column `twRMPObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMPObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMPObjectId = 'Test Object',
    @Type_bType = 0,
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
-- Returns result set: twRMPObjectIx
```

##### MySQL

```sql
SET @twRMPObjectIx = 0;

CALL set_RMRoot_RMPObject_Open(
    '127.0.0.1',
    1, 1,
    'Test Object',
    0, 0,
    1,
    -- ... additional parameters ...
    @twRMPObjectIx
);
```

####

---

## Child Object Deletion

### set_RMRoot_RMCObject_Close

Deletes a celestial object that is a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMCObjectIx_Close` | BIGINT | Object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMCObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @twRMCObjectIx_Close = 42,
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMRoot_RMCObject_Close('127.0.0.1', 1, 1, 42, 1, @nResult);
```

####

#### Behavior

- Validates the root object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates close events for all deleted objects
- Cannot be undone

---

### set_RMRoot_RMTObject_Close

Deletes a terrestrial object that is a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMTObjectIx_Close` | BIGINT | Object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMTObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @twRMTObjectIx_Close = 42,
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMRoot_RMTObject_Close('127.0.0.1', 1, 1, 42, 1, @nResult);
```

####

#### Behavior

- Validates the root object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all terrestrial and physical descendants
- If `@bDeleteAll = 0`, fails if the object has any children
- Generates close events for all deleted objects
- Logs the operation with operation code `RMROOT_OP_RMTOBJECT_CLOSE`
- Cannot be undone

---

### set_RMRoot_RMPObject_Close

Deletes a physical object that is a child of the root.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Parent root index |
| `@twRMPObjectIx_Close` | BIGINT | Object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMRoot_RMPObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @twRMPObjectIx_Close = 42,
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMRoot_RMPObject_Close('127.0.0.1', 1, 1, 42, 1, @nResult);
```

####

#### Behavior

- Validates the root object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all physical object descendants
- If `@bDeleteAll = 0`, fails if the object has any children
- Generates close events for all deleted objects
- Logs the operation with operation code `RMROOT_OP_RMPOBJECT_CLOSE`
- Cannot be undone

---

**See also:** [RMRoot](../RMRoot) | [RMRoot Get Procedures](./Get) | [RMRoot Call Procedures](./Call)
