# RMCObject Get Procedures

Get procedures retrieve RMCObject data without modification.

## get_RMCObject_Update

Retrieves a celestial object with all child types for synchronization.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMCObjectIx` | BIGINT | Celestial object index |

### Returns

Three result sets, each containing a single `[Object]` column with a JSON string per row:

1. **Result Set 0**: The celestial object — JSON keys: `pObjectHead`, `twRMCObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pOrbit_Spin`, `pBound`, `pProperties`, `nChildren`
2. **Result Set 1**: RMCObject children (celestial) — same JSON structure as Result Set 0
3. **Result Set 2**: RMTObject children (terrestrial) — JSON keys: `pObjectHead`, `twRMTObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `pProperties`, `nChildren`

### Tabs {.tabset}

#### SQL Server

```sql
EXEC dbo.get_RMCObject_Update
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMCObjectIx = 1
```

#### MySQL

```sql
CALL get_RMCObject_Update('127.0.0.1', 1, 1, @nResult);
```

###

### Validation

- `@twRPersonaIx` must be >= 0
- `@twRMCObjectIx` must be > 0
- Object must exist

### Error Codes

| Code | Message |
|------|---------|
| 1 | Session is invalid |
| 2 | CObject is invalid |
| 3 | CObject does not exist |

---

**See also:** [RMCObject](../RMCObject) | [RMCObject Search Procedures](./Search) | [RMCObject Set Procedures](./Set) | [RMCObject Call Procedures](./Call)
