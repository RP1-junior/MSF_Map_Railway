# Core Concepts

This page explains the fundamental architecture of MSF_Map_Db and how its components work together to support a streaming metaverse.

## The Streaming Paradigm

Traditional game worlds load all content at startup or during level transitions. MSF takes a fundamentally different approach: **streaming**.

In a streaming architecture:

1. **Clients start with minimal data** — typically just the root object
2. **Objects are discovered through navigation** — opening a parent reveals its children
3. **Data loads on-demand** — only objects the client needs are transferred
4. **Updates flow in real-time** — changes propagate to all interested clients

This approach enables worlds of unlimited scale. A client exploring Earth doesn't need to load data about Mars. A user in New York doesn't need building data from Tokyo.

## The Three-Tier Hierarchy

MSF organizes spatial objects into three tiers based on scale:

### Tier 1: Celestial Objects (RMCObject)

Celestial objects represent universe-scale entities:

| Type ID | Type | Description |
|---------|------|-------------|
| 0 | Void | Empty space |
| 1 | Galaxy | Collection of star systems |
| 2 | Star | Luminous celestial body |
| 3 | Planet | Body orbiting a star |
| 4 | Moon | Body orbiting a planet |
| 5 | Asteroid | Small rocky body |
| 6 | Comet | Icy body with tail |
| 7 | Station | Artificial structure in space |
| 8 | Surface | Walkable surface of a celestial body |

Celestial objects have unique properties:
- **Orbit/Spin**: Period, start time, and elliptical parameters
- **Mass/Gravity**: Physical properties affecting child objects
- **Transform**: Position, rotation, and scale relative to parent

### Tier 2: Terrestrial Objects (RMTObject)

Terrestrial objects exist on celestial surfaces:

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

Terrestrial objects have:
- **Geographic coordinates**: Latitude, longitude, radius for Earth-like surfaces
- **Cartesian coordinates**: X, Y, Z for flat or non-spherical surfaces
- **Subsurface geometry**: Transformation matrices for precise positioning
- **Properties**: Terrain type, climate, and other surface characteristics

### Tier 3: Physical Objects (RMPObject)

Physical objects are tangible 3D items:

- Buildings and structures
- Vegetation (trees, plants)
- Furniture and props
- Vehicles
- Interactive items

Physical objects have:
- **Transform**: Position, rotation, scale
- **Bound**: Bounding box dimensions
- **Resource**: Reference to 3D model/asset
- **Owner**: User who owns/controls the object

## Parent-Child Relationships

Every object (except the root) has a parent. The `ObjectHead` structure defines this relationship:

```
ObjectHead_Parent_wClass      -- Class ID of parent (70-73)
ObjectHead_Parent_twObjectIx  -- Object index of parent
ObjectHead_Self_wClass        -- Class ID of this object
ObjectHead_Self_twObjectIx    -- Object index of this object
```

Valid parent-child relationships:

| Parent | Can Contain |
|--------|-------------|
| RMRoot | RMCObject, RMTObject, RMPObject |
| RMCObject | RMCObject, RMTObject |
| RMTObject | RMTObject, RMPObject |
| RMPObject | RMPObject |

This hierarchy enables:
- A galaxy containing stars
- A star containing planets
- A planet containing a surface
- A surface containing continents
- A continent containing countries
- A country containing cities
- A city containing parcels
- A parcel containing buildings
- A building containing furniture

## Object Discovery

Clients discover objects by "opening" parents. When you open an object, you receive:

1. **The object's full data** — all properties and attributes
2. **A list of child object IDs** — what children exist (but not their full data)

To get a child's data, you must open that child. This creates a progressive loading pattern:

```
Open Root
  → Receive Root data + list of celestial children
  
Open Galaxy
  → Receive Galaxy data + list of star children
  
Open Star
  → Receive Star data + list of planet children
  
Open Planet
  → Receive Planet data + list of surface children
  
... and so on
```

## Coordinate Systems

MSF supports multiple coordinate systems for terrestrial objects:

### Geographic (Geo)
For Earth-like spherical surfaces:
- **Latitude**: -90° to +90° (south to north)
- **Longitude**: -180° to +180° (west to east)
- **Radius**: Distance from center (for altitude)

### Cylindrical (Cyl)
For cylindrical surfaces:
- **Angle**: 0° to 360° around the axis
- **Height**: Position along the axis
- **Radius**: Distance from the axis

### Cartesian (Car)
For flat or arbitrary surfaces:
- **X, Y, Z**: Standard 3D coordinates

### Null (Nul)
For objects without specific coordinates (positioned relative to parent transform only).

## Transformation Matrices

Terrestrial objects use 4x4 transformation matrices stored in the `RMTMatrix` table. These matrices:

- Convert between local and world coordinates
- Enable efficient spatial queries
- Support hierarchical transformations

Each terrestrial object has two matrices:
- **Forward matrix** (positive index): Local → World
- **Inverse matrix** (negative index): World → Local

## The Event System

Every modification to the database generates an event. Events are:

1. **Recorded in the RMEvent table** — creating an audit log
2. **Formatted as JSON** — for easy transmission to clients
3. **Ordered by sequence** — ensuring consistent state

See [Event System](./Event-System) for a comprehensive explanation.

## Procedure Categories

MSF_Map_Db procedures follow a consistent naming pattern:

### get_* Procedures
Read operations that retrieve data without modification:
- `get_RMRoot` — Get root object and immediate children
- `get_RMCObject` — Get celestial object data
- `get_*_Update` — Get object with full child list for synchronization

### set_* Procedures
Write operations that modify data:
- `set_*_Open` — Create a new child object
- `set_*_Close` — Delete an object
- `set_*_Name` — Update object name
- `set_*_Transform` — Update position/rotation/scale
- `set_*_Owner` — Transfer ownership

### call_* Procedures
Internal procedures not called directly by clients:
- `call_*_Event_*` — Generate event records
- `call_*_Validate_*` — Validate input parameters
- `call_*_Select` — Format output result sets
- `call_RMTMatrix_*` — Matrix operations (terrestrial only)

## Error Handling

All procedures use a consistent error handling pattern:

1. Create temporary `#Error` table
2. Validate inputs, calling `call_Error` for each failure
3. If no errors, perform operation
4. If errors occurred, return error result set
5. Return status code: 0 = success, negative = error count

## Tabs {.tabset}

### SQL Server

```sql
-- Error handling pattern
SELECT * INTO #Error FROM dbo.Table_Error()

DECLARE @nError INT = 0

IF @twRMRootIx <= 0
    EXEC dbo.call_Error 1, 'Root is invalid', @nError OUTPUT

IF @nError = 0
BEGIN
    -- Perform operation
END

IF @nError > 0
    SELECT dwError, sError FROM #Error

RETURN -@nError
```

### MySQL

```sql
-- Error handling pattern
CREATE TEMPORARY TABLE Error (
    nOrder INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dwError INT NOT NULL,
    sError VARCHAR(255) NOT NULL
);

SET nError = 0;

IF twRMRootIx <= 0 THEN
    CALL call_Error(1, 'Root is invalid', nError);
END IF;

IF nError = 0 THEN
    -- Perform operation
END IF;

IF nError > 0 THEN
    SELECT dwError, sError FROM Error;
END IF;

DROP TEMPORARY TABLE Error;
```

##

---

**Next:** [Database Schema](./Database-Schema)

**See also:** [Event System](./Event-System) | [Glossary](./Glossary)
