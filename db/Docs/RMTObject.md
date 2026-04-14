# RMTObject

**RMTObject** (Class ID: 72) represents terrestrial objects in the MSF_Map_Db hierarchy. These are surface-level entities like continents, countries, cities, and parcels.

## Overview

Terrestrial objects form the second tier of the spatial hierarchy. They exist on the surfaces of celestial bodies and define regions using geographic or Cartesian coordinates.

## Types

| Type ID | Type | Description |
|---------|------|-------------|
| 0 | Void | Empty region |
| 1 | Continent | Major landmass |
| 2 | Ocean | Large body of water |
| 3 | Country | Political boundary |
| 4 | State | Administrative region |
| 5 | County | Local administrative region |
| 6 | City | Urban area |
| 7 | District | City subdivision |
| 8 | Parcel | Individual lot or property |
| 9 | Zone | Functional area within a parcel |
| 10 | Room | Interior space |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70, 71, or 72) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 72 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Unique object index |
| `Name_wsRMTObjectId` | NVARCHAR(48) | Object name |
| `Type_bType` | TINYINT | Terrestrial type (0-10) |
| `Type_bSubtype` | TINYINT | Subtype |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `Resource_*` | Various | Resource reference |
| `Transform_*` | Various | Position, rotation, scale |
| `Bound_*` | Various | Bounding box |
| `Properties_*` | Various | Terrain properties |
| `Control_*` | Various | Control flags |

## Coordinate Systems

Terrestrial objects support multiple coordinate systems stored in `RMTSubsurface`:

| System | ID | Description |
|--------|-----|-------------|
| Null | 0 | No specific coordinates |
| Cartesian | 1 | X, Y, Z coordinates |
| Cylindrical | 2 | Angle, Height, Radius |
| Geographic | 3 | Latitude, Longitude, Radius |

## Transformation Matrices

Each terrestrial object has transformation matrices stored in `RMTMatrix`:

- **Forward matrix** (positive index): Converts local → world coordinates
- **Inverse matrix** (negative index): Converts world → local coordinates

These matrices enable efficient spatial queries and hierarchical transformations.

## Parent-Child Relationships

RMTObject can be a child of:
- **RMRoot** (Class 70)
- **RMCObject** (Class 71) — Typically a surface
- **RMTObject** (Class 72) — Nested regions

RMTObject can contain:
- **RMTObject** — Child regions (e.g., city within country)
- **RMPObject** — Physical objects (e.g., buildings in a parcel)

## Procedures

### Get Procedures

- [get_RMTObject_Update](./RMTObject/Get#get_rmtobject_update) — Get object with full child list
- [get_RMTObject_Compute](./RMTObject/Get#get_rmtobject_compute) — Get computed spatial data

### Search Procedures

- [search_RMTObject](./RMTObject/Search#search_rmtobject) — Find terrestrial objects by name and proximity

### Set Procedures

- [set_RMTObject_Name](./RMTObject/Set#set_rmtobject_name) — Update name
- [set_RMTObject_Type](./RMTObject/Set#set_rmtobject_type) — Update type
- [set_RMTObject_Owner](./RMTObject/Set#set_rmtobject_owner) — Transfer ownership
- [set_RMTObject_Transform](./RMTObject/Set#set_rmtobject_transform) — Update position/rotation/scale
- [set_RMTObject_Bound](./RMTObject/Set#set_rmtobject_bound) — Update bounding box
- [set_RMTObject_Resource](./RMTObject/Set#set_rmtobject_resource) — Update resource reference
- [set_RMTObject_Properties](./RMTObject/Set#set_rmtobject_properties) — Update terrain properties
- [set_RMTObject_RMTObject_Open](./RMTObject/Set#set_rmtobject_rmtobject_open) — Create terrestrial child
- [set_RMTObject_RMTObject_Close](./RMTObject/Set#set_rmtobject_rmtobject_close) — Delete terrestrial child
- [set_RMTObject_RMPObject_Open](./RMTObject/Set#set_rmtobject_rmpobject_open) — Create physical child
- [set_RMTObject_RMPObject_Close](./RMTObject/Set#set_rmtobject_rmpobject_close) — Delete physical child
- [set_RMTObject_Fabric_*](./RMTObject/Set#fabric-procedures) — Fabric configuration

### Call Procedures

- [Event Procedures](./RMTObject/Call#event-procedures) — Generate change events
- [Validation Procedures](./RMTObject/Call#validation-procedures) — Validate input data
- [Geo Procedures](./RMTObject/Call#geo-procedures) — Geographic coordinate operations
- [Matrix Procedures](./RMTObject/Call#matrix-procedures) — Transformation matrix operations
- [Utility Procedures](./RMTObject/Call#utility-procedures) — Helper functions

## Quick Example

### Tabs {.tabset}

#### SQL Server

```sql
-- Create a parcel with geographic coordinates
DECLARE @twParcelIx BIGINT

EXEC dbo.set_RMTObject_RMTObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,      -- Parent (city)
    @Name_wsRMTObjectId = 'Central Park',
    @Type_bType = 8,           -- Parcel
    @Type_bSubtype = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'park',
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
    @Bound_dX = 4000,          -- 4km x 800m
    @Bound_dY = 100,
    @Bound_dZ = 800,
    @Properties_bTerrain = 1,
    @Properties_bClimate = 2,
    @Control_wFlags = 0,
    @twRMTObjectIx = @twParcelIx OUTPUT

-- Set geographic coordinates (NYC: 40.7829° N, 73.9654° W)
EXEC dbo.call_RMTMatrix_Geo
    @twRMTObjectIx = @twParcelIx,
    @dLatitude = 40.7829,
    @dLongitude = -73.9654,
    @dRadius = 6371           -- Earth radius in km
```

#### MySQL

```sql
SET @twParcelIx = 0;

CALL set_RMTObject_RMTObject_Open(
    '127.0.0.1', 1, 100,
    'Central Park', 8, 0, 1,
    0, 'park', '',
    0, 0, 0,
    0, 0, 0, 1,
    1, 1, 1,
    4000, 100, 800,
    1, 2,
    0,
    @twParcelIx
);

-- Set geographic coordinates
CALL call_RMTMatrix_Geo(@twParcelIx, 40.7829, -73.9654, 6371);
```

###

---

**Previous:** [RMCObject](./RMCObject) | **Next:** [RMPObject](./RMPObject)

**See also:** [RMTObject Get Procedures](./RMTObject/Get) | [RMTObject Search Procedures](./RMTObject/Search) | [RMTObject Set Procedures](./RMTObject/Set) | [RMTObject Call Procedures](./RMTObject/Call)
