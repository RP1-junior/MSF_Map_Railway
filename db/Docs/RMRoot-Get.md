# RMRoot Get Procedures

Get procedures retrieve RMRoot data without modification. They return result sets containing the root object and optionally its children.

## get_RMRoot_Update

Retrieves the root object with all child types for synchronization. This is the primary procedure for clients to get a complete view of the root's children.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address for logging |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMRootIx` | BIGINT | Root object index to retrieve |

### Returns

Four result sets, each containing a single `[Object]` column with a JSON string per row:

1. **Result Set 0**: The root object — JSON keys: `pObjectHead`, `twRMRootIx`, `pName`, `pOwner`
2. **Result Set 1**: RMCObject children (celestial) — JSON keys: `pObjectHead`, `twRMCObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pOrbit_Spin`, `pBound`, `pProperties`, `nChildren`
3. **Result Set 2**: RMTObject children (terrestrial) — JSON keys: `pObjectHead`, `twRMTObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `pProperties`, `nChildren`
4. **Result Set 3**: RMPObject children (physical) — JSON keys: `pObjectHead`, `twRMPObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `nChildren`

### Tabs {.tabset}

#### SQL Server

```sql
EXEC dbo.get_RMRoot_Update
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMRootIx = 1
```

#### MySQL

```sql
CALL get_RMRoot_Update('127.0.0.1', 1, 1, @nResult);
SELECT @nResult;
```

###

### Validation

- `@twRPersonaIx` must be >= 0
- `@twRMRootIx` must be > 0
- Root must exist

### Error Codes

| Code | Message |
|------|---------|
| 1 | Session is invalid |
| 2 | Root is invalid |
| 3 | Root does not exist |

---

**See also:** [RMRoot](../RMRoot) | [RMRoot Set Procedures](./Set) | [RMRoot Call Procedures](./Call)
