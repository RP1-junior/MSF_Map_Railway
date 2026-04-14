# RMTObject Get Procedures

Get procedures retrieve RMTObject data without modification.

## get_RMTObject_Update

Retrieves a terrestrial object with all child types for synchronization.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMTObjectIx` | BIGINT | Terrestrial object index |

### Returns

Three result sets, each containing a single `[Object]` column with a JSON string per row:

1. **Result Set 0**: The terrestrial object — JSON keys: `pObjectHead`, `twRMTObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `pProperties`, `nChildren`
2. **Result Set 1**: RMTObject children (terrestrial) — same JSON structure as Result Set 0
3. **Result Set 2**: RMPObject children (physical) — JSON keys: `pObjectHead`, `twRMPObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `nChildren`

### Tabs {.tabset}

#### SQL Server

```sql
EXEC dbo.get_RMTObject_Update
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100
```

#### MySQL

```sql
CALL get_RMTObject_Update('127.0.0.1', 1, 100, @nResult);
```

###

### Validation

- `@twRPersonaIx` must be >= 0
- `@twRMTObjectIx` must be > 0
- Object must exist

### Error Codes

| Code | Message |
|------|---------|
| 1 | Session is invalid |
| 2 | TObject is invalid |
| 3 | TObject does not exist |

---

## get_RMTObject_Compute

Computes a subsurface origin and bounding box for a geographic region defined by a set of boundary nodes. Requires a temporary `#Node` table populated with latitude/longitude pairs before calling. Used for calculating surface geometry on curved planetary surfaces.

### Prerequisites

Before calling this procedure:
1. Rows in `dbo.RMTMatrix` and `dbo.RMTSubsurface` for object index 999999999 must be empty
2. A temporary `#Node` table must exist and be populated with boundary nodes:

```sql
CREATE TABLE #Node
(
   dLatitude   FLOAT(53),
   dLongitude  FLOAT(53)
)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@dRad` | FLOAT(53) | Planetary radius in meters (e.g., 6371000 for Earth) |
| `@dHeight` | FLOAT(53) | Height above the surface in meters |
| `@dDepth` | FLOAT(53) | Depth below the surface in meters |

### Returns

A single result set with computed spatial values:

| Column | Type | Description |
|--------|------|-------------|
| `dLatitude` | FLOAT(53) | Computed center latitude of the region (degrees) |
| `dLongitude` | FLOAT(53) | Computed center longitude of the region (degrees) |
| `dRadius` | FLOAT(53) | Effective radius at the bottom of the bounding box |
| `Bound_dX` | FLOAT(53) | Bounding box X dimension (full width) |
| `Bound_dY` | FLOAT(53) | Bounding box Y dimension (height from depth to top) |
| `Bound_dZ` | FLOAT(53) | Bounding box Z dimension (full depth) |

### Tabs {.tabset}

#### SQL Server

```sql
EXEC dbo.get_RMTObject_Compute
    @dRad = 6371000,    -- Earth radius in meters
    @dHeight = 100,      -- 100m above surface
    @dDepth = 50         -- 50m below surface
```

#### MySQL

```sql
CALL get_RMTObject_Compute(6371000, 100, 50);
```

###

### Behavior

The procedure iterates (up to 10 times) to find the true geographic center of the boundary nodes:

1. Converts all `#Node` lat/lon coordinates to Cartesian coordinates on the sphere
2. Computes a midpoint latitude/longitude from the node extents
3. Generates a transformation matrix via `call_RMTMatrix_Geo` for the midpoint
4. Transforms all nodes into local coordinates relative to the midpoint
5. Checks if the local bounding box is centered — if not, adjusts the midpoint and repeats
6. Once centered, computes the final bounding box dimensions accounting for `@dHeight` above and `@dDepth` below the surface

### Use Cases

- **Subsurface creation**: Compute origin and bounds for a new terrestrial subsurface region
- **Spatial queries**: Determine bounding box for a geographic polygon on a curved surface
- **Coordinate transformation**: Find the optimal local origin for a set of geographic coordinates

---

**See also:** [RMTObject](../RMTObject) | [RMTObject Search Procedures](./Search) | [RMTObject Set Procedures](./Set) | [RMTObject Call Procedures](./Call)
