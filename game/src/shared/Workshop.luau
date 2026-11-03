-- Serialized cells only: no client-created instances, assets, or executable content.
local Workshop = {}
Workshop.Width = 32
Workshop.Height = 16
Workshop.MaxCells = 384
Workshop.Palette = {
    {25, 28, 37}, {65, 72, 84}, {185, 194, 207}, {239, 240, 223},
    {245, 192, 49}, {230, 104, 38}, {199, 47, 65}, {112, 48, 177},
    {35, 199, 205}, {38, 104, 211}, {60, 157, 81}, {146, 95, 53},
}
function Workshop.validate(cells)
    if type(cells) ~= "table" then return nil, "Invalid design" end
    local clean, occupied = {}, {}
    local count = 0
    for key, cell in pairs(cells) do
        count += 1
        if count > Workshop.MaxCells then return nil, "Maximum 384 voxels" end
        if type(key) ~= "number" or key % 1 ~= 0 or key < 1 or key > Workshop.MaxCells then
            return nil, "Invalid cell list"
        end
        if type(cell) ~= "table" then return nil, "Invalid cell" end
        local x, y, color = cell.x, cell.y, cell.color
        local function integer(value)
            return type(value) == "number" and value == value and value % 1 == 0
        end
        if not integer(x) or not integer(y) or not integer(color) then return nil, "Invalid coordinate" end
        if x < 1 or x > Workshop.Width or y < 1 or y > Workshop.Height
            or color < 1 or color > #Workshop.Palette then return nil, "Outside grid or palette" end
        local id = x .. ":" .. y
        if occupied[id] then return nil, "Duplicate voxel" end
        occupied[id] = true
        table.insert(clean, {x = x, y = y, color = color})
    end
    if #clean < 8 then return nil, "Place at least 8 voxels" end
    return clean, nil
end
return Workshop
