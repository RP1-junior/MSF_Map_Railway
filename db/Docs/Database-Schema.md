# Database Schema

This page documents all tables in the MSF_Map_Db database.

## Object Tables

### RMRoot

The root container table. Each map has one root object.

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (always 0 for root) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent index (always 0 for root) |
| `ObjectHead_Self_wClass` | SMALLINT | Always 70 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Primary key, auto-increment |
| `ObjectHead_twEventIz` | BIGINT | Last event sequence |
| `ObjectHead_wFlags` | SMALLINT | Object flags |
| `Name_wsRMRootId` | NVARCHAR(48) | Root name |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |

---

### RMCObject

Celestial objects (galaxies, stars, planets, moons).

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70 or 71) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 71 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Primary key, auto-increment |
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
| `Transform_Position_dX` | FLOAT(53) | X position |
| `Transform_Position_dY` | FLOAT(53) | Y position |
| `Transform_Position_dZ` | FLOAT(53) | Z position |
| `Transform_Rotation_dX` | FLOAT(53) | Quaternion X |
| `Transform_Rotation_dY` | FLOAT(53) | Quaternion Y |
| `Transform_Rotation_dZ` | FLOAT(53) | Quaternion Z |
| `Transform_Rotation_dW` | FLOAT(53) | Quaternion W |
| `Transform_Scale_dX` | FLOAT(53) | X scale |
| `Transform_Scale_dY` | FLOAT(53) | Y scale |
| `Transform_Scale_dZ` | FLOAT(53) | Z scale |
| `Orbit_Spin_tmPeriod` | BIGINT | Orbital period (ms) |
| `Orbit_Spin_tmStart` | BIGINT | Orbit start time |
| `Orbit_Spin_dA` | FLOAT(53) | Semi-major axis |
| `Orbit_Spin_dB` | FLOAT(53) | Semi-minor axis |
| `Bound_dX` | FLOAT(53) | Bounding box X |
| `Bound_dY` | FLOAT(53) | Bounding box Y |
| `Bound_dZ` | FLOAT(53) | Bounding box Z |
| `Properties_fMass` | FLOAT(24) | Mass |
| `Properties_fGravity` | FLOAT(24) | Surface gravity |
| `Properties_fColor` | FLOAT(24) | Color temperature |
| `Properties_fBrightness` | FLOAT(24) | Luminosity |
| `Properties_fReflectivity` | FLOAT(24) | Albedo |

---

### RMTObject

Terrestrial objects (continents, cities, parcels).

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70, 71, or 72) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 72 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Primary key, auto-increment |
| `ObjectHead_twEventIz` | BIGINT | Last event sequence |
| `ObjectHead_wFlags` | SMALLINT | Object flags |
| `Name_wsRMTObjectId` | NVARCHAR(48) | Object name |
| `Type_bType` | TINYINT | Terrestrial type (0-10) |
| `Type_bSubtype` | TINYINT | Subtype |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `Resource_*` | Various | Resource reference |
| `Transform_*` | Various | Position, rotation, scale |
| `Bound_*` | Various | Bounding box |
| `Properties_bTerrain` | TINYINT | Terrain type |
| `Properties_bClimate` | TINYINT | Climate type |
| `Control_wFlags` | SMALLINT | Control flags |

---

### RMPObject

Physical objects (buildings, furniture, items).

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70, 72, or 73) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 73 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Primary key, auto-increment |
| `ObjectHead_twEventIz` | BIGINT | Last event sequence |
| `ObjectHead_wFlags` | SMALLINT | Object flags |
| `Name_wsRMPObjectId` | NVARCHAR(48) | Object name |
| `Type_bType` | TINYINT | Physical type |
| `Type_bSubtype` | TINYINT | Subtype |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `Resource_qwResource` | BIGINT | Resource identifier |
| `Resource_sName` | NVARCHAR(48) | Resource name |
| `Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `Transform_Position_dX` | FLOAT(53) | X position |
| `Transform_Position_dY` | FLOAT(53) | Y position |
| `Transform_Position_dZ` | FLOAT(53) | Z position |
| `Transform_Rotation_dX` | FLOAT(53) | Quaternion X |
| `Transform_Rotation_dY` | FLOAT(53) | Quaternion Y |
| `Transform_Rotation_dZ` | FLOAT(53) | Quaternion Z |
| `Transform_Rotation_dW` | FLOAT(53) | Quaternion W |
| `Transform_Scale_dX` | FLOAT(53) | X scale |
| `Transform_Scale_dY` | FLOAT(53) | Y scale |
| `Transform_Scale_dZ` | FLOAT(53) | Z scale |
| `Bound_dX` | FLOAT(53) | Bounding box X |
| `Bound_dY` | FLOAT(53) | Bounding box Y |
| `Bound_dZ` | FLOAT(53) | Bounding box Z |

---

## Event Table

### RMEvent

Stores all change events for real-time synchronization.

| Column | Type | Description |
|--------|------|-------------|
| `twEventIx` | BIGINT | Primary key, auto-increment |
| `sType` | VARCHAR(32) | Event type (e.g., "RMCOBJECT_NAME") |
| `Self_wClass` | TINYINT | Parent object class |
| `Self_twObjectIx` | BIGINT | Parent object index |
| `Child_wClass` | TINYINT | Affected object class |
| `Child_twObjectIx` | BIGINT | Affected object index |
| `wFlags` | SMALLINT | Event flags (OPEN=0x01, CLOSE=0x02) |
| `twEventIz` | BIGINT | Related event sequence |
| `sJSON_Object` | NVARCHAR(4000) | Parent object JSON |
| `sJSON_Child` | NVARCHAR(4000) | Child object JSON |
| `sJSON_Change` | NVARCHAR(4000) | Change data JSON |

---

## Spatial Tables

### RMTSubsurface

Stores coordinate system parameters for terrestrial objects.

| Column | Type | Description |
|--------|------|-------------|
| `twRMTObjectIx` | BIGINT | Primary key, references RMTObject |
| `tnGeometry` | TINYINT | Coordinate system (0=Nul, 1=Car, 2=Cyl, 3=Geo) |
| `dA` | FLOAT(53) | First coordinate (x, angle, or latitude) |
| `dB` | FLOAT(53) | Second coordinate (y, height, or longitude) |
| `dC` | FLOAT(53) | Third coordinate (z, radius, or radius) |

### RMTMatrix

Stores 4x4 transformation matrices for terrestrial objects.

| Column | Type | Description |
|--------|------|-------------|
| `bnMatrix` | BIGINT | Primary key (positive=forward, negative=inverse) |
| `d00` - `d33` | FLOAT(53) | Matrix elements (16 total) |

The matrix is stored in row-major order:

```
| d00  d01  d02  d03 |
| d10  d11  d12  d13 |
| d20  d21  d22  d23 |
| d30  d31  d32  d33 |
```

For an object with index N:
- Forward matrix: `bnMatrix = N`
- Inverse matrix: `bnMatrix = -N`

---

## Administrative Tables

### Admin

Stores administrative settings.

| Column | Type | Description |
|--------|------|-------------|
| `sKey` | VARCHAR(32) | Setting key |
| `sValue` | VARCHAR(255) | Setting value |

### Version

Stores database version information.

| Column | Type | Description |
|--------|------|-------------|
| `nVersion` | INT | Version number |
| `dtCreated` | DATETIME2 | Creation timestamp |
| `sDescription` | VARCHAR(255) | Version description |

---

## Log Tables

Each object table has a corresponding log table for audit purposes:

- `RMRootLog`
- `RMCObjectLog`
- `RMTObjectLog`
- `RMPObjectLog`

Log tables record:
- `dtCreated` — Timestamp
- `twLogIx` — Log sequence number
- `bOp` — Operation code
- `dwIPAddress` — Client IP address
- `twRPersonaIx` — User persona
- `tw*ObjectIx` — Affected object

---

## Type Reference Tables

### RMCType

Celestial object type definitions.

| Type ID | Name |
|---------|------|
| 0 | Void |
| 1 | Galaxy |
| 2 | Star |
| 3 | Planet |
| 4 | Moon |
| 5 | Asteroid |
| 6 | Comet |
| 7 | Station |
| 8 | Surface |

### RMTType

Terrestrial object type definitions.

| Type ID | Name |
|---------|------|
| 0 | Void |
| 1 | Continent |
| 2 | Ocean |
| 3 | Country |
| 4 | State |
| 5 | County |
| 6 | City |
| 7 | District |
| 8 | Parcel |
| 9 | Zone |
| 10 | Room |

### RMPType

Physical object type definitions (application-specific).

---

## Class IDs

| Class | ID | Table |
|-------|-----|-------|
| RMRoot | 70 | RMRoot |
| RMCObject | 71 | RMCObject |
| RMTObject | 72 | RMTObject |
| RMPObject | 73 | RMPObject |

---

## Indexes

Primary indexes are on `ObjectHead_Self_twObjectIx` for all object tables.

Additional indexes recommended for performance:

### Tabs {.tabset}

#### SQL Server

```sql
-- Parent lookup index
CREATE INDEX IX_RMCObject_Parent ON dbo.RMCObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx)

CREATE INDEX IX_RMTObject_Parent ON dbo.RMTObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx)

CREATE INDEX IX_RMPObject_Parent ON dbo.RMPObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx)

-- Event sequence index
CREATE INDEX IX_RMEvent_Sequence ON dbo.RMEvent
    (Self_wClass, Self_twObjectIx, twEventIx)
```

#### MySQL

```sql
-- Parent lookup index
CREATE INDEX IX_RMCObject_Parent ON RMCObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx);

CREATE INDEX IX_RMTObject_Parent ON RMTObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx);

CREATE INDEX IX_RMPObject_Parent ON RMPObject
    (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx);

-- Event sequence index
CREATE INDEX IX_RMEvent_Sequence ON RMEvent
    (Self_wClass, Self_twObjectIx, twEventIx);
```

###

---

**Previous:** [Core Concepts](./Core-Concepts) | **Next:** [Event System](./Event-System)

**See also:** [Glossary](./Glossary)
