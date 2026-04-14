# RMCObject Search Procedures

Search procedures find celestial objects by name and location criteria.

## search_RMCObject

Searches for celestial objects by name within a subtree, returning matches ranked by proximity and hierarchy level.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Root object to search from |
| `@dX` | FLOAT(53) | Search origin X (for proximity ranking) |
| `@dY` | FLOAT(53) | Search origin Y |
| `@dZ` | FLOAT(53) | Search origin Z |
| `@sText` | NVARCHAR(48) | Search text (prefix match) |

### Returns

Two result sets (or an error result set if validation fails):

**Result Set 0** — Up to 10 matching objects, ranked by proximity and type:

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_wClass_Parent` | INT | Parent class ID |
| `ObjectHead_twParentIx` | BIGINT | Parent object index |
| `ObjectHead_wClass_Object` | INT | Object class ID |
| `ObjectHead_twObjectIx` | BIGINT | Object index |
| `ObjectHead_wFlags` | INT | Object flags |
| `ObjectHead_twEventIz` | BIGINT | Event index |
| `Name_wsRMCObjectId` | NVARCHAR | Object name |
| `Type_bType` | TINYINT | Object type |
| `Type_bSubtype` | TINYINT | Object subtype |
| `Type_bFiction` | TINYINT | Fiction flag |
| `dFactor` | FLOAT(53) | Type-based ranking factor |
| `dDistance` | FLOAT(53) | Distance from search origin |

**Result Set 1** — Ancestor chain for each match (for navigation):

| Column | Type | Description |
|--------|------|-------------|
| `ObjectHead_wClass_Parent` | INT | Parent class ID |
| `ObjectHead_twParentIx` | BIGINT | Parent object index |
| `ObjectHead_wClass_Object` | INT | Object class ID |
| `ObjectHead_twObjectIx` | BIGINT | Object index |
| `ObjectHead_wFlags` | INT | Object flags |
| `ObjectHead_twEventIz` | BIGINT | Event index |
| `Name_wsRMCObjectId` | NVARCHAR | Object name |
| `Type_bType` | TINYINT | Object type |
| `Type_bSubtype` | TINYINT | Object subtype |
| `Type_bFiction` | TINYINT | Fiction flag |
| `nAncestor` | INT | Ancestor depth (1 = parent, 2 = grandparent, etc.) |

If `@sText` is empty, both result sets are returned empty.

### Tabs {.tabset}

#### SQL Server

```sql
-- Search for planets starting with "Ear" from Sol's position
EXEC dbo.search_RMCObject
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 1,        -- Sol (root of search)
    @dX = 0,
    @dY = 0,
    @dZ = 0,
    @sText = 'Ear'
```

#### MySQL

```sql
CALL search_RMCObject('127.0.0.1', 1, 1, 0, 0, 0, 'Ear');
```

###

### Behavior

- Searches descendants of the specified object (not ancestors or siblings)
- Matches objects where `Name_wsRMCObjectId` starts with `@sText`
- Only searches objects of type greater than the root (e.g., from a star, finds planets but not galaxies)
- Returns up to 10 results ranked by:
  - Type factor (closer types ranked higher)
  - Distance from search origin
  - Alphabetical name
- Second result set provides the ancestor chain for each match, enabling navigation

### Error Result Set

If validation fails, a single result set is returned instead:

| Column | Type | Description |
|--------|------|-------------|
| `dwError` | INT | Error code |
| `sError` | NVARCHAR | Error message |

| Code | Message |
|------|---------|
| 1 | twRMCObjectIx is invalid |

### Use Cases

- **Location search**: Find celestial bodies by name from current position
- **Autocomplete**: Provide suggestions as user types
- **Navigation**: Build path from current location to destination using ancestor chain

---

**See also:** [RMCObject](../RMCObject) | [RMCObject Get Procedures](./Get) | [RMCObject Set Procedures](./Set) | [RMCObject Call Procedures](./Call)
