# RMCObject Set Procedures

Set procedures modify RMCObject data and manage child objects. All set procedures generate events.

## Property Modification

### set_RMCObject_Name

Updates the celestial object's name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Name
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Name_wsRMCObjectId = 'Terra'
```

##### MySQL

```sql
CALL set_RMCObject_Name('127.0.0.1', 1, 4, 'Terra', @nResult);
```

####

---

### set_RMCObject_Type

Updates the celestial object's type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | New type (0-8) |
| `@Type_bSubtype` | TINYINT | New subtype |
| `@Type_bFiction` | TINYINT | Fiction flag |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Type
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Type_bType = 3,
    @Type_bSubtype = 1,
    @Type_bFiction = 0
```

##### MySQL

```sql
CALL set_RMCObject_Type('127.0.0.1', 1, 4, 3, 1, 0, @nResult);
```

####

---

### set_RMCObject_Owner

Transfers ownership of the celestial object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Owner
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL set_RMCObject_Owner('127.0.0.1', 1, 4, 2, @nResult);
```

####

---

### set_RMCObject_Transform

Updates position, rotation, and scale.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | New position |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | New rotation (quaternion) |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | New scale |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Transform
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
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
CALL set_RMCObject_Transform(
    '127.0.0.1', 1, 4,
    149597870.7, 0, 0,
    0, 0, 0.119, 0.993,
    1, 1, 1,
    @nResult
);
```

####

---

### set_RMCObject_Bound

Updates the bounding box dimensions.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Bound
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Bound_dX = 6371,
    @Bound_dY = 6371,
    @Bound_dZ = 6371
```

##### MySQL

```sql
CALL set_RMCObject_Bound('127.0.0.1', 1, 4, 6371, 6371, 6371, @nResult);
```

####

---

### set_RMCObject_Resource

Updates the resource reference (3D model, texture, etc.).

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Resource
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Resource_qwResource = 1001,
    @Resource_sName = 'earth_hd',
    @Resource_sReference = 'models/planets/earth_8k.glb'
```

##### MySQL

```sql
CALL set_RMCObject_Resource(
    '127.0.0.1', 1, 4,
    1001, 'earth_hd', 'models/planets/earth_8k.glb',
    @nResult
);
```

####

---

### set_RMCObject_Properties

Updates physical properties (mass, gravity, color, brightness, reflectivity).

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Properties_fMass` | FLOAT(24) | Mass |
| `@Properties_fGravity` | FLOAT(24) | Surface gravity |
| `@Properties_fColor` | FLOAT(24) | Color temperature |
| `@Properties_fBrightness` | FLOAT(24) | Brightness |
| `@Properties_fReflectivity` | FLOAT(24) | Reflectivity (0-1) |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Properties
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Properties_fMass = 0.000003,
    @Properties_fGravity = 9.8,
    @Properties_fColor = 288,
    @Properties_fBrightness = 0,
    @Properties_fReflectivity = 0.3
```

##### MySQL

```sql
CALL set_RMCObject_Properties(
    '127.0.0.1', 1, 4,
    0.000003, 9.8, 288, 0, 0.3,
    @nResult
);
```

####

---

### set_RMCObject_Orbit_Spin

Updates orbital and rotational parameters.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Object index |
| `@Orbit_Spin_tmPeriod` | FLOAT(53) | Orbital period (milliseconds) |
| `@Orbit_Spin_tmStart` | FLOAT(53) | Start time for orbit calculation |
| `@Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `@Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_Orbit_Spin
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,
    @Orbit_Spin_tmPeriod = 31557600000,    -- 1 year
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 149597870.7,
    @Orbit_Spin_dB = 149577000
```

##### MySQL

```sql
CALL set_RMCObject_Orbit_Spin(
    '127.0.0.1', 1, 4,
    31557600000, 0, 149597870.7, 149577000,
    @nResult
);
```

####

---

## Child Object Creation

### set_RMCObject_RMCObject_Open

Creates a new celestial object as a child (e.g., moon under planet).

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Parent object index |
| `@Name_wsRMCObjectId` | NVARCHAR(48) | Child name |
| `@Type_bType` | TINYINT | Celestial type (0-8) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | Fiction flag |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Orbit_Spin_*` | Various | Orbital parameters |
| `@Bound_*` | Various | Bounding box |
| `@Properties_*` | Various | Physical properties |

#### Returns

Returns a single result set with column `twRMCObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,        -- Earth
    @Name_wsRMCObjectId = 'Luna',
    @Type_bType = 4,           -- Moon
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'moon',
    @Resource_sReference = '',
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
    @Orbit_Spin_tmPeriod = 2360592000,     -- 27.3 days
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
    @Properties_fReflectivity = 0.12
```

##### MySQL

```sql
CALL set_RMCObject_RMCObject_Open(
    '127.0.0.1', 1, 4,
    'Luna', 4, 0, 0, 1,
    0, 'moon', '',
    384400, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    2360592000, 0, 384400, 383000,
    1737, 1737, 1737,
    0.0123, 1.62, 250, 0, 0.12
);
```

####

---

### set_RMCObject_RMTObject_Open

Creates a new terrestrial object on a celestial surface.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Parent celestial object index |
| `@Name_wsRMTObjectId` | NVARCHAR(48) | Child name |
| `@Type_bType` | TINYINT | Terrestrial type (0-10) |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | Fiction flag |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Bound_*` | Various | Bounding box |
| `@Properties_*` | Various | Terrain properties |
| `@bCoord` | TINYINT | Coordinate system (0=Geo, 1=Cyl, 2=Car, 3=Nul) |
| `@dA` | FLOAT(53) | Coordinate A value |
| `@dB` | FLOAT(53) | Coordinate B value |
| `@dC` | FLOAT(53) | Coordinate C value |

#### Returns

Returns a single result set with column `twRMTObjectIx` (BIGINT) — the index of the newly created object.

#### Tabs {.tabset}

##### SQL Server

```sql
-- First create a surface on Earth
EXEC dbo.set_RMCObject_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,        -- Earth
    @Name_wsRMCObjectId = 'Earth Surface',
    @Type_bType = 8,           -- Surface
    -- ... parameters ...

-- Then create a continent on the surface
EXEC dbo.set_RMCObject_RMTObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = @twSurfaceIx,
    @Name_wsRMTObjectId = 'North America',
    @Type_bType = 1,           -- Continent
    -- ... parameters ...
```

##### MySQL

```sql
-- Create surface, then continent
CALL set_RMCObject_RMCObject_Open(
    '127.0.0.1', 1, 4,
    'Earth Surface', 8, 0, 0, 1,
    -- ... parameters ...
);

CALL set_RMCObject_RMTObject_Open(
    '127.0.0.1', 1, @twSurfaceIx,
    'North America', 1, 0, 1,
    -- ... parameters ...
);
```

####

---

## Child Object Deletion

### set_RMCObject_RMCObject_Close

Deletes a celestial child object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Parent object index |
| `@twRMCObjectIx_Close` | BIGINT | Child object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_RMCObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 4,           -- Parent (Earth)
    @twRMCObjectIx_Close = 5,     -- Child to delete (Luna)
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMCObject_RMCObject_Close('127.0.0.1', 1, 4, 5, 1, @nResult);
```

####

#### Behavior

- Validates the parent object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates close events for all deleted objects
- Cannot be undone

---

### set_RMCObject_RMTObject_Close

Deletes a terrestrial child object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Parent object index |
| `@twRMTObjectIx_Close` | BIGINT | Child object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMCObject_RMTObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 10,          -- Surface
    @twRMTObjectIx_Close = 100,   -- Continent to delete
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMCObject_RMTObject_Close('127.0.0.1', 1, 10, 100, 1, @nResult);
```

####

#### Behavior

- Validates the parent object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all terrestrial and physical descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates close events for all deleted objects
- Cannot be undone

---

**See also:** [RMCObject](../RMCObject) | [RMCObject Get Procedures](./Get) | [RMCObject Search Procedures](./Search) | [RMCObject Call Procedures](./Call)
