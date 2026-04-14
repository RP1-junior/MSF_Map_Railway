# RMCObject

**RMCObject** (Class ID: 71) represents celestial objects in the MSF_Map_Db hierarchy. These are universe-scale entities like galaxies, stars, planets, and moons.

## Overview

Celestial objects form the first tier of the spatial hierarchy. They represent:

- Galaxies containing star systems
- Stars with orbiting planets
- Planets with moons
- Surfaces where terrestrial objects exist

## Types

| Type ID | Type | Description |
|---------|------|-------------|
| 0 | Void | Empty space region |
| 1 | Galaxy | Collection of star systems |
| 2 | Star | Luminous celestial body |
| 3 | Planet | Body orbiting a star |
| 4 | Moon | Body orbiting a planet |
| 5 | Asteroid | Small rocky body |
| 6 | Comet | Icy body with tail |
| 7 | Station | Artificial structure in space |
| 8 | Surface | Walkable surface of a celestial body |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70=Root, 71=CObject) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 71 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Unique object index |
| `ObjectHead_twEventIz` | BIGINT | Last event sequence |
| `ObjectHead_wFlags` | SMALLINT | Object flags |
| `Name_wsRMCObjectId` | NVARCHAR(48) | Object name |
| `Type_bType` | TINYINT | Celestial type (0-8) |
| `Type_bSubtype` | TINYINT | Subtype |
| `Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `Resource_qwResource` | BIGINT | Resource identifier |
| `Resource_sName` | NVARCHAR(48) | Resource name |
| `Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `Transform_Position_dX/Y/Z` | FLOAT(53) | Position relative to parent |
| `Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `Orbit_Spin_tmPeriod` | BIGINT | Orbital/spin period (ms) |
| `Orbit_Spin_tmStart` | BIGINT | Orbit/spin start time |
| `Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |
| `Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |
| `Properties_fMass` | FLOAT(24) | Mass |
| `Properties_fGravity` | FLOAT(24) | Surface gravity |
| `Properties_fColor` | FLOAT(24) | Color temperature (K) |
| `Properties_fBrightness` | FLOAT(24) | Luminosity |
| `Properties_fReflectivity` | FLOAT(24) | Albedo |

## Parent-Child Relationships

RMCObject can be a child of:
- **RMRoot** (Class 70) — Top-level celestial objects
- **RMCObject** (Class 71) — Nested celestial objects (e.g., planet under star)

RMCObject can contain:
- **RMCObject** — Child celestial objects (e.g., moons under planet)
- **RMTObject** — Terrestrial objects on surfaces

## Procedures

### Get Procedures

- [get_RMCObject_Update](./RMCObject/Get#get_rmcobject_update) — Get object with full child list

### Search Procedures

- [search_RMCObject](./RMCObject/Search#search_rmcobject) — Find celestial objects by name and proximity

### Set Procedures

- [set_RMCObject_Name](./RMCObject/Set#set_rmcobject_name) — Update name
- [set_RMCObject_Type](./RMCObject/Set#set_rmcobject_type) — Update type
- [set_RMCObject_Owner](./RMCObject/Set#set_rmcobject_owner) — Transfer ownership
- [set_RMCObject_Transform](./RMCObject/Set#set_rmcobject_transform) — Update position/rotation/scale
- [set_RMCObject_Bound](./RMCObject/Set#set_rmcobject_bound) — Update bounding box
- [set_RMCObject_Resource](./RMCObject/Set#set_rmcobject_resource) — Update resource reference
- [set_RMCObject_Properties](./RMCObject/Set#set_rmcobject_properties) — Update physical properties
- [set_RMCObject_Orbit_Spin](./RMCObject/Set#set_rmcobject_orbit_spin) — Update orbital parameters
- [set_RMCObject_RMCObject_Open](./RMCObject/Set#set_rmcobject_rmcobject_open) — Create celestial child
- [set_RMCObject_RMCObject_Close](./RMCObject/Set#set_rmcobject_rmcobject_close) — Delete celestial child
- [set_RMCObject_RMTObject_Open](./RMCObject/Set#set_rmcobject_rmtobject_open) — Create terrestrial child
- [set_RMCObject_RMTObject_Close](./RMCObject/Set#set_rmcobject_rmtobject_close) — Delete terrestrial child

### Call Procedures

- [Event Procedures](./RMCObject/Call#event-procedures) — Generate change events
- [Validation Procedures](./RMCObject/Call#validation-procedures) — Validate input data
- [Utility Procedures](./RMCObject/Call#utility-procedures) — Helper functions

## Quick Example

### Tabs {.tabset}

#### SQL Server

```sql
-- Create a solar system: Star with planet
DECLARE @twStarIx BIGINT, @twPlanetIx BIGINT

-- Create the star under root
EXEC dbo.set_RMRoot_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMCObjectId = 'Sol',
    @Type_bType = 2,           -- Star
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'star_g',
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
    @Orbit_Spin_tmPeriod = 0,
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 0,
    @Orbit_Spin_dB = 0,
    @Bound_dX = 696340,
    @Bound_dY = 696340,
    @Bound_dZ = 696340,
    @Properties_fMass = 1.0,
    @Properties_fGravity = 274,
    @Properties_fColor = 5778,
    @Properties_fBrightness = 1.0,
    @Properties_fReflectivity = 0,
    @twRMCObjectIx = @twStarIx OUTPUT

-- Create Earth orbiting the star
EXEC dbo.set_RMCObject_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = @twStarIx,
    @Name_wsRMCObjectId = 'Earth',
    @Type_bType = 3,           -- Planet
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'planet_earth',
    @Resource_sReference = '',
    @Transform_Position_dX = 149597870.7,  -- 1 AU in km
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 0,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0.119,        -- 23.4° axial tilt
    @Transform_Rotation_dW = 0.993,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Orbit_Spin_tmPeriod = 31557600000,    -- 1 year in ms
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 149597870.7,          -- Semi-major axis
    @Orbit_Spin_dB = 149577000,            -- Semi-minor axis
    @Bound_dX = 6371,
    @Bound_dY = 6371,
    @Bound_dZ = 6371,
    @Properties_fMass = 0.000003,          -- Relative to Sun
    @Properties_fGravity = 9.8,
    @Properties_fColor = 288,              -- Average temp K
    @Properties_fBrightness = 0,
    @Properties_fReflectivity = 0.3,
    @twRMCObjectIx = @twPlanetIx OUTPUT

SELECT @twStarIx AS StarId, @twPlanetIx AS PlanetId
```

#### MySQL

```sql
SET @twStarIx = 0;
SET @twPlanetIx = 0;

-- Create the star under root
CALL set_RMRoot_RMCObject_Open(
    '127.0.0.1', 1, 1,
    'Sol', 2, 0, 0, 1,
    0, 'star_g', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    0, 0, 0, 0,
    696340, 696340, 696340,
    1.0, 274, 5778, 1.0, 0,
    @twStarIx
);

-- Create Earth orbiting the star
CALL set_RMCObject_RMCObject_Open(
    '127.0.0.1', 1, @twStarIx,
    'Earth', 3, 0, 0, 1,
    0, 'planet_earth', '',
    149597870.7, 0, 0,
    0, 0, 0.119, 0.993,
    1, 1, 1,
    31557600000, 0, 149597870.7, 149577000,
    6371, 6371, 6371,
    0.000003, 9.8, 288, 0, 0.3,
    @twPlanetIx
);

SELECT @twStarIx AS StarId, @twPlanetIx AS PlanetId;
```

###

---

**Previous:** [RMRoot](./RMRoot) | **Next:** [RMTObject](./RMTObject)

**See also:** [RMCObject Get Procedures](./RMCObject/Get) | [RMCObject Search Procedures](./RMCObject/Search) | [RMCObject Set Procedures](./RMCObject/Set) | [RMCObject Call Procedures](./RMCObject/Call)
