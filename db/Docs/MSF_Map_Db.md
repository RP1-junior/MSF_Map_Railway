# MSF_Map_Db

**MSF_Map_Db** is a SQL database project that provides persistent storage for the **Metaverse Spatial Fabric (MSF)** — a hierarchical 3D spatial object system designed for metaverse applications.

## Overview

MSF_Map_Db manages a three-tier hierarchy of spatial objects that represent everything from galaxies and planets down to individual buildings and furniture. The database supports:

- **Streaming Architecture**: Clients discover and load objects on-demand as they navigate the world, rather than loading everything at once
- **Hierarchical Navigation**: Objects are organized in parent-child relationships, enabling efficient spatial queries and progressive loading
- **Event-Driven Updates**: All changes generate events that can be pushed to connected clients in real-time
- **Dual Database Support**: Full implementations for both SQL Server and MySQL

## Documentation

| Page | Description |
|------|-------------|
| [Core Concepts](./MSF_Map_Db/Core-Concepts) | Architecture, streaming, and the object hierarchy |
| [Database Schema](./MSF_Map_Db/Database-Schema) | Table definitions and relationships |
| [Event System](./MSF_Map_Db/Event-System) | How events work and why they matter |
| [Glossary](./MSF_Map_Db/Glossary) | Terminology and abbreviations |

## Object Hierarchy

The spatial fabric consists of four object types arranged in a hierarchy:

| Object Type | Class | Description | Examples |
|-------------|----------|-------------|----------|
| [RMRoot](./MSF_Map_Db/RMRoot) | 70 | Root container | World, Universe |
| [RMCObject](./MSF_Map_Db/RMCObject) | 71 | Celestial Object | Galaxy, Star, Planet, Moon |
| [RMTObject](./MSF_Map_Db/RMTObject) | 72 | Terrestrial Object | Continent, Country, City, Parcel |
| [RMPObject](./MSF_Map_Db/RMPObject) | 73 | Physical Object | Building, Tree, Furniture, Vehicle |

**Celestial objects** exist at the universe scale — galaxies containing stars, stars with orbiting planets, planets with moons. These objects have properties like orbit, spin, mass, and gravity.

**Terrestrial objects** exist on the surface of celestial bodies — continents, countries, cities, parcels of land. These objects define regions using geographic or Cartesian coordinates.

**Physical objects** are tangible 3D items placed in the world — buildings, trees, furniture, vehicles. These are the objects users directly interact with.

### Object Reference

Each object type has detailed documentation for its stored procedures:

**RMRoot (Root Container)**
- [Get Procedures](./MSF_Map_Db/RMRoot/Get) — Retrieve root and child objects
- [Set Procedures](./MSF_Map_Db/RMRoot/Set) — Create, modify, and delete objects
- [Call Procedures](./MSF_Map_Db/RMRoot/Call) — Events, validation, and utilities

**RMCObject (Celestial Object)**
- [Get Procedures](./MSF_Map_Db/RMCObject/Get) — Retrieve celestial objects
- [Search Procedures](./MSF_Map_Db/RMCObject/Search) — Find celestial objects by name
- [Set Procedures](./MSF_Map_Db/RMCObject/Set) — Create and modify celestial objects
- [Call Procedures](./MSF_Map_Db/RMCObject/Call) — Events, validation, and utilities

**RMTObject (Terrestrial Object)**
- [Get Procedures](./MSF_Map_Db/RMTObject/Get) — Retrieve terrestrial objects
- [Search Procedures](./MSF_Map_Db/RMTObject/Search) — Find terrestrial objects by name
- [Set Procedures](./MSF_Map_Db/RMTObject/Set) — Create and modify terrestrial objects
- [Call Procedures](./MSF_Map_Db/RMTObject/Call) — Events, validation, geo, and matrix operations

**RMPObject (Physical Object)**
- [Get Procedures](./MSF_Map_Db/RMPObject/Get) — Retrieve physical objects
- [Set Procedures](./MSF_Map_Db/RMPObject/Set) — Create and modify physical objects
- [Call Procedures](./MSF_Map_Db/RMPObject/Call) — Events, validation, and utilities

## Quick Start

### Retrieving the Root Object

## Tabs {.tabset}

### SQL Server

```sql
EXEC dbo.get_RMRoot @sIPAddress = '127.0.0.1', @twRMRootIx = 1
```

### MySQL

```sql
CALL get_RMRoot('127.0.0.1', 1);
```

##

### Creating a Celestial Object

## Tabs {.tabset}

### SQL Server

```sql
DECLARE @twRMCObjectIx BIGINT

EXEC dbo.set_RMRoot_RMCObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1,
    @Name_wsRMCObjectId = 'Sol',
    @Type_bType = 2,           -- Star
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Owner_twRPersonaIx = 1,
    -- ... additional parameters ...
    @twRMCObjectIx = @twRMCObjectIx OUTPUT
```

### MySQL

```sql
SET @twRMCObjectIx = 0;

CALL set_RMRoot_RMCObject_Open(
    '127.0.0.1',
    1,                         -- twRPersonaIx
    1,                         -- twRMRootIx
    'Sol',                     -- Name
    2,                         -- Type (Star)
    0,                         -- Subtype
    0,                         -- Fiction
    1,                         -- Owner
    -- ... additional parameters ...
    @twRMCObjectIx
);
```

##

## Naming Conventions

MSF_Map_Db follows a consistent naming convention:

- **get_** prefix: Read procedures that retrieve data
- **search_** prefix: Search procedures that retrieve data
- **set_** prefix: Write procedures that modify data
- **call_** prefix: Internal procedures (events, validation, utilities)

## Related Projects

- **[MVMF](/en/MVMF)** — Metaversal Model Foundation, the client-side JavaScript framework for connecting to MSF services
- **[MSF_Map_Svc](/en/MSF_Map_Svc)** — The service layer that exposes MSF_Map_Db to MVMF clients

## License

Copyright 2025 Metaversal Corporation. Licensed under the Apache License, Version 2.0.
