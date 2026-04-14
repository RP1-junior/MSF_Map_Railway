# RMPObject Get Procedures

Get procedures retrieve RMPObject data without modification.

## get_RMPObject_Update

Retrieves a physical object with all children for synchronization.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Physical object index |

### Returns

Two result sets, each containing a single `[Object]` column with a JSON string per row:

1. **Result Set 0**: The physical object — JSON keys: `pObjectHead`, `twRMPObjectIx`, `pName`, `pType`, `pOwner`, `pResource`, `pTransform`, `pBound`, `nChildren`
2. **Result Set 1**: RMPObject children — same JSON structure as Result Set 0

### Tabs {.tabset}

#### SQL Server

```sql
EXEC dbo.get_RMPObject_Update
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000
```

#### MySQL

```sql
CALL get_RMPObject_Update('127.0.0.1', 1, 1000, @nResult);
```

###

### Validation

- `@twRPersonaIx` must be >= 0
- `@twRMPObjectIx` must be > 0
- Object must exist

### Error Codes

| Code | Message |
|------|---------|
| 1 | Session is invalid |
| 2 | PObject is invalid |
| 3 | PObject does not exist |

---

**See also:** [RMPObject](../RMPObject) | [RMPObject Set Procedures](./Set) | [RMPObject Call Procedures](./Call)
