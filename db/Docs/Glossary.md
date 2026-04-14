# Glossary

This page defines terminology and abbreviations used throughout the MSF_Map_Db documentation.

## Abbreviations

### System Names

| Abbreviation | Full Name | Description |
|--------------|-----------|-------------|
| **MSF** | Metaverse Spatial Fabric | The overall spatial system |
| **RM** | RP1 Map | Prefix for all map-related classes |
| **RP1** | (Project name) | The overall system name |
| **MVMF** | Metaversal Model Foundation | Client-side JavaScript framework |

### Object Types

| Abbreviation | Full Name | Class ID |
|--------------|-----------|----------|
| **RMRoot** | RP1 Map Root | 70 |
| **RMCObject** | RP1 Map Celestial Object | 71 |
| **RMTObject** | RP1 Map Terrestrial Object | 72 |
| **RMPObject** | RP1 Map Physical Object | 73 |

### Coordinate Systems

| Abbreviation | Full Name | Description |
|--------------|-----------|-------------|
| **Nul** | Null | No specific coordinates |
| **Car** | Cartesian | X, Y, Z coordinates |
| **Cyl** | Cylindrical | Angle, Height, Radius |
| **Geo** | Geographic | Latitude, Longitude, Radius |

### Procedure Prefixes

| Prefix | Meaning | Description |
|--------|---------|-------------|
| **get_** | Get/Read | Retrieves data without modification |
| **set_** | Set/Write | Modifies data, generates events |
| **call_** | Call/Internal | Internal helper procedures |

### Column Prefixes

| Prefix | Meaning | Description |
|--------|---------|-------------|
| **b** | Byte | TINYINT (0-255) |
| **w** | Word | SMALLINT (16-bit) |
| **dw** | Double Word | INT (32-bit) |
| **qw** | Quad Word | BIGINT (64-bit) |
| **tw** | Tri Word | BIGINT (used for object indices) |
| **bn** | Big Number | BIGINT (signed, for matrix indices) |
| **d** | Double | FLOAT(53) (double precision) |
| **f** | Float | FLOAT(24) (single precision) |
| **s** | String | VARCHAR/NVARCHAR |
| **ws** | Wide String | NVARCHAR (Unicode) |
| **tm** | Time | BIGINT (milliseconds) |
| **dt** | DateTime | DATETIME2 |
| **tn** | Tiny Number | TINYINT |

---

## Terms

### A

**Affine Transform**
: A transformation that preserves lines and parallelism. Includes translation, rotation, scale, and shear.

**Albedo**
: The reflectivity of a surface, from 0 (absorbs all light) to 1 (reflects all light).

### B

**Bounding Box**
: A rectangular box that completely contains an object, defined by X, Y, Z dimensions.

### C

**Celestial Object**
: A universe-scale object like a galaxy, star, planet, or moon. Stored in `RMCObject`.

**Class ID**
: A numeric identifier for object types (70=Root, 71=Celestial, 72=Terrestrial, 73=Physical).

**Client**
: An application that connects to the MSF service to access map data.

### D

**Descendant**
: Any object in the hierarchy below a given object (children, grandchildren, etc.).

### E

**Event**
: A record of a change to the database, stored in `RMEvent` and pushed to clients.

**Event Sequence**
: The `twEventIx` value that orders events chronologically.

### F

**Forward Matrix**
: A transformation matrix that converts local coordinates to world coordinates.

### G

**Geographic Coordinates**
: A coordinate system using latitude, longitude, and radius for spherical surfaces.

### H

**Hierarchy**
: The parent-child relationship structure of objects in the map.

### I

**Inverse Matrix**
: A transformation matrix that converts world coordinates to local coordinates.

### J

**JSON**
: JavaScript Object Notation, used to format event data for transmission.

### L

**Local Coordinates**
: Coordinates relative to an object's parent.

### M

**Matrix**
: A 4x4 transformation matrix stored in `RMTMatrix`.

**Metaverse**
: A shared virtual world where users can interact with objects and each other.

### O

**Object Head**
: The common header fields present in all object types (`ObjectHead_*`).

**Object Index**
: The unique identifier for an object within its class (`twObjectIx`).

**Open**
: To create a new object (as in `set_*_Open` procedures).

### P

**Parent**
: The object that contains another object in the hierarchy.

**Persona**
: A user identity, referenced by `twRPersonaIx`.

**Physical Object**
: A tangible 3D item like a building or furniture. Stored in `RMPObject`.

### Q

**Quaternion**
: A four-component representation of rotation (X, Y, Z, W).

### R

**Result Set**
: A table of data returned by a stored procedure.

**Root**
: The top-level container object in a map. Stored in `RMRoot`.

### S

**Streaming**
: The architecture where objects are loaded on-demand as clients navigate.

**Subsurface**
: The coordinate system and parameters for a terrestrial object, stored in `RMTSubsurface`.

### T

**Terrestrial Object**
: A surface-level object like a continent, city, or parcel. Stored in `RMTObject`.

**Transform**
: The position, rotation, and scale of an object relative to its parent.

### W

**World Coordinates**
: Absolute coordinates in the global coordinate system.

---

## Event Types

| Event Type | Description |
|------------|-------------|
| `RMROOT_NAME` | Root name changed |
| `RMROOT_OWNER` | Root ownership changed |
| `RMCOBJECT_OPEN` | Celestial object created |
| `RMCOBJECT_CLOSE` | Celestial object deleted |
| `RMCOBJECT_NAME` | Celestial name changed |
| `RMCOBJECT_TYPE` | Celestial type changed |
| `RMCOBJECT_OWNER` | Celestial ownership changed |
| `RMCOBJECT_TRANSFORM` | Celestial position/rotation/scale changed |
| `RMCOBJECT_BOUND` | Celestial bounding box changed |
| `RMCOBJECT_RESOURCE` | Celestial resource changed |
| `RMCOBJECT_PROPERTIES` | Celestial properties changed |
| `RMCOBJECT_ORBIT_SPIN` | Celestial orbit/spin changed |
| `RMTOBJECT_OPEN` | Terrestrial object created |
| `RMTOBJECT_CLOSE` | Terrestrial object deleted |
| `RMTOBJECT_NAME` | Terrestrial name changed |
| `RMTOBJECT_TYPE` | Terrestrial type changed |
| `RMTOBJECT_OWNER` | Terrestrial ownership changed |
| `RMTOBJECT_TRANSFORM` | Terrestrial position/rotation/scale changed |
| `RMTOBJECT_BOUND` | Terrestrial bounding box changed |
| `RMTOBJECT_RESOURCE` | Terrestrial resource changed |
| `RMTOBJECT_PROPERTIES` | Terrestrial properties changed |
| `RMPOBJECT_OPEN` | Physical object created |
| `RMPOBJECT_CLOSE` | Physical object deleted |
| `RMPOBJECT_NAME` | Physical name changed |
| `RMPOBJECT_TYPE` | Physical type changed |
| `RMPOBJECT_OWNER` | Physical ownership changed |
| `RMPOBJECT_TRANSFORM` | Physical position/rotation/scale changed |
| `RMPOBJECT_BOUND` | Physical bounding box changed |
| `RMPOBJECT_RESOURCE` | Physical resource changed |

---

## Error Codes

Common error codes returned by procedures:

| Code | Message |
|------|---------|
| 1 | Session is invalid |
| 2 | Object is invalid |
| 3 | Object does not exist |
| 4 | Parent does not exist |
| 5 | Permission denied |
| 10 | Name is invalid |
| 11 | Type is invalid |
| 12 | Owner is invalid |
| 20 | Position is invalid |
| 21 | Transform value is NULL or NaN |
| 22 | Rotation is invalid |
| 23 | Scale is invalid |
| 30 | Bound is invalid |
| 40 | Resource is invalid |

---

**Previous:** [Event System](./Event-System)

**See also:** [Core Concepts](./Core-Concepts) | [Database Schema](./Database-Schema)
