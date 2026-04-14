# RMPObject

**RMPObject** (Class ID: 73) represents physical objects in the MSF_Map_Db hierarchy. These are tangible 3D items like buildings, trees, furniture, and vehicles.

## Overview

Physical objects form the third tier of the spatial hierarchy. They are the objects users directly interact with in the metaverse.

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `ObjectHead_Parent_wClass` | SMALLINT | Parent class (70, 72, or 73) |
| `ObjectHead_Parent_twObjectIx` | BIGINT | Parent object index |
| `ObjectHead_Self_wClass` | SMALLINT | Always 73 |
| `ObjectHead_Self_twObjectIx` | BIGINT | Unique object index |
| `Name_wsRMPObjectId` | NVARCHAR(48) | Object name |
| `Type_bType` | TINYINT | Physical type |
| `Type_bSubtype` | TINYINT | Subtype |
| `Owner_twRPersonaIx` | BIGINT | Owner persona index |
| `Resource_qwResource` | BIGINT | Resource identifier |
| `Resource_sName` | NVARCHAR(48) | Resource name |
| `Resource_sReference` | NVARCHAR(128) | Resource path/URL |
| `Transform_Position_dX/Y/Z` | FLOAT(53) | Position relative to parent |
| `Transform_Rotation_dX/Y/Z/W` | FLOAT(53) | Rotation quaternion |
| `Transform_Scale_dX/Y/Z` | FLOAT(53) | Scale factors |
| `Bound_dX/Y/Z` | FLOAT(53) | Bounding box dimensions |

## Parent-Child Relationships

RMPObject can be a child of:
- **RMRoot** (Class 70)
- **RMTObject** (Class 72) — Most common
- **RMPObject** (Class 73) — Nested objects

RMPObject can contain:
- **RMPObject** — Child objects (e.g., furniture inside building)

## Procedures

### Get Procedures

- [get_RMPObject_Update](./RMPObject/Get#get_rmpobject_update) — Get object with full child list

### Set Procedures

- [set_RMPObject_Name](./RMPObject/Set#set_rmpobject_name) — Update name
- [set_RMPObject_Type](./RMPObject/Set#set_rmpobject_type) — Update type
- [set_RMPObject_Owner](./RMPObject/Set#set_rmpobject_owner) — Transfer ownership
- [set_RMPObject_Transform](./RMPObject/Set#set_rmpobject_transform) — Update position/rotation/scale
- [set_RMPObject_Bound](./RMPObject/Set#set_rmpobject_bound) — Update bounding box
- [set_RMPObject_Resource](./RMPObject/Set#set_rmpobject_resource) — Update resource reference
- [set_RMPObject_Parent](./RMPObject/Set#set_rmpobject_parent) — Move to different parent
- [set_RMPObject_RMPObject_Open](./RMPObject/Set#set_rmpobject_rmpobject_open) — Create physical child
- [set_RMPObject_RMPObject_Close](./RMPObject/Set#set_rmpobject_rmpobject_close) — Delete physical child

### Call Procedures

- [Event Procedures](./RMPObject/Call#event-procedures) — Generate change events
- [Validation Procedures](./RMPObject/Call#validation-procedures) — Validate input data
- [Utility Procedures](./RMPObject/Call#utility-procedures) — Helper functions

## Quick Example

### Tabs {.tabset}

#### SQL Server

```sql
-- Create a building in a parcel
DECLARE @twBuildingIx BIGINT

EXEC dbo.set_RMTObject_RMPObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMTObjectIx = 100,      -- Parent parcel
    @Name_wsRMPObjectId = 'Office Building',
    @Type_bType = 0,           -- Building
    @Type_bSubtype = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'office_modern',
    @Resource_sReference = 'models/buildings/office_modern.glb',
    @Transform_Position_dX = 50,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 30,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 40,
    @Bound_dY = 100,
    @Bound_dZ = 30,
    @twRMPObjectIx = @twBuildingIx OUTPUT

-- Add furniture inside the building
DECLARE @twDeskIx BIGINT

EXEC dbo.set_RMPObject_RMPObject_Open
    @sIPAddress = '127.0.0.1',
    @twRPersonaIx = 1,
    @twRMPObjectIx = @twBuildingIx,
    @Name_wsRMPObjectId = 'Reception Desk',
    @Type_bType = 1,           -- Furniture
    @Type_bSubtype = 0,
    @Owner_twRPersonaIx = 1,
    @Resource_qwResource = 0,
    @Resource_sName = 'desk_reception',
    @Resource_sReference = 'models/furniture/desk_reception.glb',
    @Transform_Position_dX = 5,
    @Transform_Position_dY = 0,
    @Transform_Position_dZ = 3,
    @Transform_Rotation_dX = 0,
    @Transform_Rotation_dY = 0,
    @Transform_Rotation_dZ = 0,
    @Transform_Rotation_dW = 1,
    @Transform_Scale_dX = 1,
    @Transform_Scale_dY = 1,
    @Transform_Scale_dZ = 1,
    @Bound_dX = 2,
    @Bound_dY = 1,
    @Bound_dZ = 1,
    @twRMPObjectIx = @twDeskIx OUTPUT
```

#### MySQL

```sql
SET @twBuildingIx = 0;

CALL set_RMTObject_RMPObject_Open(
    '127.0.0.1', 1, 100,
    'Office Building', 0, 0, 1,
    0, 'office_modern', 'models/buildings/office_modern.glb',
    50, 0, 30,
    0, 0, 0, 1,
    1, 1, 1,
    40, 100, 30,
    @twBuildingIx
);

SET @twDeskIx = 0;

CALL set_RMPObject_RMPObject_Open(
    '127.0.0.1', 1, @twBuildingIx,
    'Reception Desk', 1, 0, 1,
    0, 'desk_reception', 'models/furniture/desk_reception.glb',
    5, 0, 3,
    0, 0, 0, 1,
    1, 1, 1,
    2, 1, 1,
    @twDeskIx
);
```

###

---

**Previous:** [RMTObject](./RMTObject)

**See also:** [RMPObject Get Procedures](./RMPObject/Get) | [RMPObject Set Procedures](./RMPObject/Set) | [RMPObject Call Procedures](./RMPObject/Call)
