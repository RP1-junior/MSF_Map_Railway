# RMPObject Set Procedures

Set procedures modify RMPObject data and manage child objects.

## Property Modification

### set_RMPObject_Name

Updates the physical object's name.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | New name |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Name
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Name_wsRMPObjectId = 'Corporate Headquarters'
```

##### MySQL

```sql
CALL set_RMPObject_Name('127.0.0.1', 1, 1000, 'Corporate Headquarters', @nResult);
```

####

---

### set_RMPObject_Type

Updates the physical object's type classification.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Type
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Type_bType = 0,
    @Type_bSubtype = 1,
    @Type_bFiction = 0,
    @Type_bMovable = 1
```

##### MySQL

```sql
CALL set_RMPObject_Type('127.0.0.1', 1, 1000, 0, 1, 0, 1, @nResult);
```

####

---

### set_RMPObject_Owner

Transfers ownership of the physical object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Owner_twRPersonaIx` | BIGINT | New owner persona index |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Owner
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Owner_twRPersonaIx = 2
```

##### MySQL

```sql
CALL set_RMPObject_Owner('127.0.0.1', 1, 1000, 2, @nResult);
```

####

---

### set_RMPObject_Transform

Updates position, rotation, and scale.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Transform_Position_dX/Y/Z` | FLOAT(53) | New position |
| `@Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | New rotation (quaternion) |
| `@Transform_Scale_dX/Y/Z` | FLOAT(53) | New scale |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Transform
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Transform_Position_dX = 100,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 50,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0.707,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 0.707,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1
```

##### MySQL

```sql
CALL set_RMPObject_Transform(
    '127.0.0.1', 1, 1000,
    100, 0, 50,
    0, 0.707, 0, 0.707,
    1, 1, 1,
    @nResult
);
```

####

---

### set_RMPObject_Bound

Updates the bounding box dimensions.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Bound_dX` | FLOAT(53) | Bounding box X dimension |
| `@Bound_dY` | FLOAT(53) | Bounding box Y dimension |
| `@Bound_dZ` | FLOAT(53) | Bounding box Z dimension |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Bound
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Bound_dX = 50,
    @Bound_dY = 120,
    @Bound_dZ = 40
```

##### MySQL

```sql
CALL set_RMPObject_Bound('127.0.0.1', 1, 1000, 50, 120, 40, @nResult);
```

####

---

### set_RMPObject_Resource

Updates the resource reference (3D model, texture, etc.).

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object index |
| `@Resource_qwResource` | BIGINT | Resource identifier |
| `@Resource_sName` | NVARCHAR(48) | Resource name |
| `@Resource_sReference` | NVARCHAR(128) | Resource path/URL |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_Resource
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,
    @Resource_qwResource = 2001,
    @Resource_sName = 'office_tower',
    @Resource_sReference = 'models/buildings/office_tower_v2.glb'
```

##### MySQL

```sql
CALL set_RMPObject_Resource(
    '127.0.0.1', 1, 1000,
    2001, 'office_tower', 'models/buildings/office_tower_v2.glb',
    @nResult
);
```

####

---

### set_RMPObject_Parent

Moves the object to a different parent. This is useful for:
- Moving furniture between rooms
- Reorganizing object hierarchies
- Transferring objects between parcels

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Object to move |
| `@wClass` | SMALLINT | New parent's class (70, 72, or 73) |
| `@twObjectIx` | BIGINT | New parent's object index |

#### Tabs {.tabset}

##### SQL Server

```sql
-- Move a desk from one building to another
EXEC dbo.set_RMPObject_Parent
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1001,     -- The desk
    @wClass = 73,              -- RMPObject
    @twObjectIx = 2000         -- Different building
```

##### MySQL

```sql
CALL set_RMPObject_Parent(
    '127.0.0.1', 1, 1001,
    73, 2000,
    @nResult
);
```

####

#### Behavior

- Rejects if the new parent equals the current parent
- Validates the new parent exists and can contain physical objects
- Runs `call_RMPObject_Validate_Type` against the new parent
- Updates the object's `ObjectHead_Parent_*` fields
- Generates Close/Open events on old and new parent with `bReparent=1` (reparent, not actual delete)
- Does NOT automatically adjust transform (object keeps same local position)

---

## Child Object Creation

### set_RMPObject_RMPObject_Open

Creates a new physical object as a child.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Parent object index |
| `@Name_wsRMPObjectId` | NVARCHAR(48) | Child name |
| `@Type_bType` | TINYINT | Physical type |
| `@Type_bSubtype` | TINYINT | Subtype |
| `@Type_bFiction` | TINYINT | 0=real, 1=fictional |
| `@Type_bMovable` | TINYINT | 0=static, 1=movable |
| `@Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `@Resource_*` | Various | Resource reference |
| `@Transform_*` | Various | Position/rotation/scale |
| `@Bound_*` | Various | Bounding box |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_RMPObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,     -- Parent building
    @Name_wsRMPObjectId = 'Office Chair',
    @Type_bType = 1,           -- Furniture
    @Type_bSubtype = 0,
    @Type_bFiction = 0,
    @Type_bMovable = 1,        -- Movable
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'chair_office',
    @Resource_sReference = 'models/furniture/chair_office.glb',
    @Transform_Position_dX = 6,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 3,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 0.6,
    @Bound_dY = 1.2,
    @Bound_dZ = 0.6
```

##### MySQL

```sql
CALL set_RMPObject_RMPObject_Open(
    '127.0.0.1', 1, 1000,
    'Office Chair', 1, 0, 0, 1,
    1,
    0, 'chair_office', 'models/furniture/chair_office.glb',
    6, 0, 3,
    0, 0, 0, 1,
    1, 1, 1,
    0.6, 1.2, 0.6,
    @nResult
);
```

####

#### Returns

Returns a single result set with column `twRMPObjectIx` (BIGINT) — the index of the newly created object.

---

## Child Object Deletion

### set_RMPObject_RMPObject_Close

Deletes a physical child object.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `@sIPAddress` | NVARCHAR(16) | Client IP address |
| `@twRPersonaIx` | BIGINT | Session persona index |
| `@twRMPObjectIx` | BIGINT | Parent object index |
| `@twRMPObjectIx_Close` | BIGINT | Child object to delete |
| `@bDeleteAll` | TINYINT | 1 = delete all descendants, 0 = fail if has children |

#### Tabs {.tabset}

##### SQL Server

```sql
EXEC dbo.set_RMPObject_RMPObject_Close
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = 1000,        -- Parent
    @twRMPObjectIx_Close = 1001,  -- Child to delete
    @bDeleteAll = 1
```

##### MySQL

```sql
CALL set_RMPObject_RMPObject_Close('127.0.0.1', 1, 1000, 1001, 1, @nResult);
```

####

#### Behavior

- Validates the parent object and access permissions
- If `@bDeleteAll = 1`, recursively deletes all physical descendants
- If `@bDeleteAll = 0`, fails if the object has children
- Generates a single RMPOBJECT_CLOSE event on the parent

---

**See also:** [RMPObject](../RMPObject) | [RMPObject Get Procedures](./Get) | [RMPObject Call Procedures](./Call)
