# RMRoot

**RMRoot** (Class ID: 70) is the root container object in the MSF_Map_Db hierarchy. It represents the top-level "world" or "universe" that contains all other objects.

## Overview

Every MSF map has exactly one root object. The root serves as:

- **The entry point** for clients connecting to the map
- **The container** for top-level celestial, terrestrial, and physical objects
- **The anchor** for the coordinate system

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `ObjectHead_Self_wClass` | SMALLINT | Always 70 (RMRoot class ID) |
| `ObjectHead_Self_twObjectIx` | BIGINT | Unique object index |
| `Name_wsRMRootId` | NVARCHAR(48) | Root name/identifier |
| `Owner_twRPersonaIx` | BIGINT | Owner's persona index |

## Child Objects

RMRoot can contain:

| Child Type | Description |
|------------|-------------|
| RMCObject | Celestial objects (galaxies, stars, planets) |
| RMTObject | Terrestrial objects (continents, cities, parcels) |
| RMPObject | Physical objects (buildings, items) |

## Procedures

### Get Procedures

Retrieve root object data:

- [get_RMRoot_Update](./RMRoot/Get#get_rmroot_update) — Get root with all child types

### Set Procedures

Modify root and create/delete children:

- [set_RMRoot_Name](./RMRoot/Set#set_rmroot_name) — Update root name
- [set_RMRoot_Owner](./RMRoot/Set#set_rmroot_owner) — Transfer ownership
- [set_RMRoot_RMCObject_Open](./RMRoot/Set#set_rmroot_rmcobject_open) — Create celestial child
- [set_RMRoot_RMCObject_Close](./RMRoot/Set#set_rmroot_rmcobject_close) — Delete celestial child
- [set_RMRoot_RMTObject_Open](./RMRoot/Set#set_rmroot_rmtobject_open) — Create terrestrial child
- [set_RMRoot_RMTObject_Close](./RMRoot/Set#set_rmroot_rmtobject_close) — Delete terrestrial child
- [set_RMRoot_RMPObject_Open](./RMRoot/Set#set_rmroot_rmpobject_open) — Create physical child
- [set_RMRoot_RMPObject_Close](./RMRoot/Set#set_rmroot_rmpobject_close) — Delete physical child

### Call Procedures

Internal procedures for events and validation:

- [Event Procedures](./RMRoot/Call#event-procedures) — Generate change events
- [Validation Procedures](./RMRoot/Call#validation-procedures) — Validate input data
- [Utility Procedures](./RMRoot/Call#utility-procedures) — Helper functions

## Quick Example

### Tabs {.tabset}

#### SQL Server

```sql
-- Get the root object
EXEC dbo.get_RMRoot 
    @sIPAddress = '127.0.0.1',
    @twRMRootIx = 1

-- Create a galaxy under the root
DECLARE @twRMCObjectIx BIGINT

EXEC dbo.set_RMRoot_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMCObjectId = 'Milky Way',
    @Type_bType = 1,           -- Galaxy
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
    @Orbit_Spin_tmPeriod = 0,
    @Orbit_Spin_tmStart = 0,
    @Orbit_Spin_dA = 0,
    @Orbit_Spin_dB = 0,
    @Bound_dX = 100000,
    @Bound_dY = 100000,
    @Bound_dZ = 100000,
    @Properties_fMass = 1.0,
    @Properties_fGravity = 0,
    @Properties_fColor = 1.0,
    @Properties_fBrightness = 0.5,
    @Properties_fReflectivity = 0,
    @twRMCObjectIx = @twRMCObjectIx OUTPUT

SELECT @twRMCObjectIx AS NewGalaxyId
```

#### MySQL

```sql
-- Get the root object
CALL get_RMRoot('127.0.0.1', 1);

-- Create a galaxy under the root
SET @twRMCObjectIx = 0;

CALL set_RMRoot_RMCObject_Open(
    '127.0.0.1',
    1,                         -- twRPersonaIx
    1,                         -- twRMRootIx
    'Milky Way',               -- Name
    1,                         -- Type (Galaxy)
    0,                         -- Subtype
    0,                         -- Fiction
    1,                         -- Owner
    0,                         -- Resource
    '',                        -- Resource Name
    '',                        -- Resource Reference
    0, 0, 0,                   -- Position
    0, 0, 0, 1,                -- Rotation (quaternion)
    1, 1, 1,                   -- Scale
    0, 0, 0, 0,                -- Orbit/Spin
    100000, 100000, 100000,    -- Bound
    1.0, 0, 1.0, 0.5, 0,       -- Properties
    @twRMCObjectIx
);

SELECT @twRMCObjectIx AS NewGalaxyId;
```

###

---

**Next:** [RMCObject](./RMCObject)

**See also:** [RMRoot Get Procedures](./RMRoot/Get) | [RMRoot Set Procedures](./RMRoot/Set) | [RMRoot Call Procedures](./RMRoot/Call)
