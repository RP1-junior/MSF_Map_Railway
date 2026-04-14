# MSF_Map_Db

**Metaverse Spatial Fabric Map Database** — a SQL database that provides persistent storage for a hierarchical 3D spatial object system designed for metaverse applications.

## Overview

MSF_Map_Db manages a three-tier hierarchy of spatial objects that represent everything from galaxies and planets down to individual buildings and furniture. It is the storage layer of the Metaverse Spatial Fabric stack:

```
MVMF (client) ←→ MSF_Map_Svc (service) ←→ MSF_Map_Db (this project)
```

### Key Features

- **Streaming architecture** — Clients discover and load objects on-demand as they navigate the world
- **Hierarchical navigation** — Objects are organized in parent-child relationships for efficient spatial queries
- **Event-driven updates** — All changes generate events that can be pushed to connected clients in real time
- **Dual database support** — Full implementations for both SQL Server and MySQL

## Object Hierarchy

| Object Type | Class | Scale | Examples |
|-------------|-------|-------|----------|
| **RMRoot** | 70 | Container | World, Universe |
| **RMCObject** | 71 | Celestial | Galaxy, Star, Planet, Moon |
| **RMTObject** | 72 | Terrestrial | Continent, Country, City, Parcel |
| **RMPObject** | 73 | Physical | Building, Tree, Furniture, Vehicle |

**Celestial objects** exist at the universe scale — galaxies containing stars, stars with orbiting planets, planets with moons.

**Terrestrial objects** exist on the surface of celestial bodies — continents, countries, cities, parcels of land.

**Physical objects** are tangible 3D items placed in the world — buildings, trees, furniture, vehicles.

## Repository Structure

```
MSF_Map_Db/
├── SQL_Server/             SQL Server implementation
│   ├── Tables/             Table definitions
│   ├── Procedures/         Stored procedures (by object type)
│   │   ├── RMRoot/
│   │   ├── RMCObject/
│   │   ├── RMTObject/
│   │   └── RMPObject/
│   ├── Functions/          User-defined functions
│   └── _Create/            Build scripts for install SQL
├── MySQL/                  MySQL implementation (parallel structure)
│   ├── Tables/
│   ├── Procedures/
│   ├── Functions/
│   └── _Create/
└── Docs/                   Documentation source files
```

The SQL Server and MySQL implementations are structurally parallel — every table, procedure, and function exists in both.

## Installation

MSF_Map_Db is typically installed automatically as part of [MSF_Map_Svc](https://github.com/MetaversalCorp/MSF_Map_Svc) setup. The service project includes this repository as a git submodule and runs the database install during its build process.

For complete installation instructions, see: **[Installation Guide](https://omb.wiki/en/install)**

### Quick Start

The fastest way to get a working database is through the MSF_Map_Svc installation:

1. Clone MSF_Map_Svc with submodules:
   ```bash
   git clone --recurse-submodules https://github.com/MetaversalCorp/MSF_Map_Svc.git
   ```
2. Build for your platform (e.g., Linux + MySQL):
   ```bash
   cd MSF_Map_Svc
   npm install
   npm run build:linux:mysql
   ```
3. Configure `dist/settings.json` with your database connection
4. Install the schema:
   ```bash
   cd dist
   npm install
   npm run install:svc
   ```

## Usage

MSF_Map_Db is designed to be accessed through [MSF_Map_Svc](https://github.com/MetaversalCorp/MSF_Map_Svc), which wraps the stored procedures in REST and Socket.IO endpoints. Direct SQL access is also possible for administration and custom integrations.

### Procedure Naming Convention

| Prefix | Purpose | Example |
|--------|---------|---------|
| `get_` | Read-only retrieval | `get_RMCObject_Update` |
| `search_` | Query by criteria | `search_RMCObject` |
| `set_` | Modifications | `set_RMCObject_Name` |
| `call_` | Internal helpers | `call_RMCObject_Event_Name` |

### Procedure Counts

| Object Type | Get | Set | Call | Search | Total |
|-------------|-----|-----|------|--------|-------|
| RMRoot      | 2   | 8   | 14   | —      | 24    |
| RMCObject   | 2   | 12  | 25   | 1      | 40    |
| RMTObject   | 3   | 14  | 38   | 1      | 56    |
| RMPObject   | 2   | 9   | 19   | —      | 30    |
| **Total**   | **9** | **43** | **96** | **2** | **150** |

## Documentation

Full documentation is available on the **[Open Metaverse Browser Wiki](https://omb.wiki/en/MSF_Map_Db)**:

- [Core Concepts](https://omb.wiki/en/MSF_Map_Db/Core-Concepts) — Architecture, streaming, and the object hierarchy
- [Database Schema](https://omb.wiki/en/MSF_Map_Db/Database-Schema) — Table definitions and relationships
- [Event System](https://omb.wiki/en/MSF_Map_Db/Event-System) — How events work and why they matter
- [Glossary](https://omb.wiki/en/MSF_Map_Db/Glossary) — Terminology and abbreviations

### Object Reference

- [RMRoot](https://omb.wiki/en/MSF_Map_Db/RMRoot) — Root container
- [RMCObject](https://omb.wiki/en/MSF_Map_Db/RMCObject) — Celestial objects
- [RMTObject](https://omb.wiki/en/MSF_Map_Db/RMTObject) — Terrestrial objects
- [RMPObject](https://omb.wiki/en/MSF_Map_Db/RMPObject) — Physical objects

## Related Projects

| Project | Description |
|---------|-------------|
| [MSF_Map_Svc](https://github.com/MetaversalCorp/MSF_Map_Svc) | Node.js service layer that exposes MSF_Map_Db over REST and Socket.IO |
| [MVMF](https://omb.wiki/en/MVMF) | Client-side JavaScript framework for connecting to MSF services |
| [SceneAssembler](https://github.com/MetaversalCorp/SceneAssembler) | Web-based 3D scene editing interface |

## License

Copyright 2025 Metaversal Corporation. Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
