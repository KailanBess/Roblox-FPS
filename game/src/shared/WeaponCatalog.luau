-- Named roster and prices from the uploaded documents.
-- Three small rate adjustments are recorded in docs/WEAPON_BALANCE.md.
local Catalog = {}
Catalog.Order = {}
Catalog.ById = {}
do
    local weapon = table.freeze({id = "M4A1", class = "Assault Rifle", damage = 34.0, rpm = 600.0, magazine = 30, range = 42.0, accuracy = 82.0, reloadRating = 45.0, move = 215.0, penetration = 65.0, zoom = 1.0, price = 5000, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "AK-103", class = "Assault Rifle", damage = 38.0, rpm = 540.0, magazine = 30, range = 44.0, accuracy = 76.0, reloadRating = 42.0, move = 210.0, penetration = 72.0, zoom = 1.0, price = 6000, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "HK416", class = "Assault Rifle", damage = 33.0, rpm = 650.0, magazine = 30, range = 41.0, accuracy = 85.0, reloadRating = 48.0, move = 218.0, penetration = 62.0, zoom = 1.0, price = 5250, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "SCAR-L", class = "Assault Rifle", damage = 36.0, rpm = 570.0, magazine = 30, range = 48.0, accuracy = 80.0, reloadRating = 43.0, move = 212.0, penetration = 70.0, zoom = 1.0, price = 5750, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "FAMAS", class = "Assault Rifle", damage = 31.0, rpm = 720.0, magazine = 25, range = 39.0, accuracy = 78.0, reloadRating = 46.0, move = 220.0, penetration = 58.0, zoom = 1.0, price = 5500, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "MP5", class = "SMG", damage = 25.0, rpm = 750.0, magazine = 30, range = 28.0, accuracy = 75.0, reloadRating = 45.0, move = 225.0, penetration = 45.0, zoom = 1.0, price = 5000, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "MP7", class = "SMG", damage = 23.0, rpm = 820.0, magazine = 35, range = 27.0, accuracy = 78.0, reloadRating = 47.0, move = 230.0, penetration = 42.0, zoom = 1.0, price = 5500, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "UMP45", class = "SMG", damage = 28.0, rpm = 650.0, magazine = 25, range = 31.0, accuracy = 80.0, reloadRating = 44.0, move = 220.0, penetration = 50.0, zoom = 1.0, price = 5250, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Vector", class = "SMG", damage = 21.0, rpm = 950.0, magazine = 30, range = 24.0, accuracy = 70.0, reloadRating = 48.0, move = 235.0, penetration = 40.0, zoom = 1.0, price = 6000, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "P90", class = "SMG", damage = 22.0, rpm = 850.0, magazine = 50, range = 26.0, accuracy = 74.0, reloadRating = 42.0, move = 228.0, penetration = 43.0, zoom = 1.0, price = 5750, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M870", class = "Shotgun", damage = 140.0, rpm = 70.0, magazine = 7, range = 14.0, accuracy = 45.0, reloadRating = 32.0, move = 220.0, penetration = 70.0, zoom = 1.0, price = 5250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M1014", class = "Shotgun", damage = 125.0, rpm = 90.0, magazine = 8, range = 13.0, accuracy = 42.0, reloadRating = 30.0, move = 222.0, penetration = 65.0, zoom = 1.0, price = 5750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "SPAS-12", class = "Shotgun", damage = 135.0, rpm = 80.0, magazine = 8, range = 15.0, accuracy = 48.0, reloadRating = 31.0, move = 218.0, penetration = 68.0, zoom = 1.0, price = 6000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "KSG", class = "Shotgun", damage = 145.0, rpm = 65.0, magazine = 10, range = 16.0, accuracy = 52.0, reloadRating = 28.0, move = 215.0, penetration = 72.0, zoom = 1.0, price = 6250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Super 90", class = "Shotgun", damage = 120.0, rpm = 100.0, magazine = 6, range = 12.0, accuracy = 40.0, reloadRating = 35.0, move = 225.0, penetration = 60.0, zoom = 1.0, price = 5500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M24", class = "Sniper", damage = 150.0, rpm = 45.0, magazine = 5, range = 65.0, accuracy = 15.0, reloadRating = 35.0, move = 205.0, penetration = 100.0, zoom = 3.0, price = 6250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "AWM", class = "Sniper", damage = 170.0, rpm = 35.0, magazine = 5, range = 70.0, accuracy = 12.0, reloadRating = 32.0, move = 195.0, penetration = 100.0, zoom = 4.0, price = 7500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "R700", class = "Sniper", damage = 145.0, rpm = 50.0, magazine = 5, range = 63.0, accuracy = 16.0, reloadRating = 36.0, move = 208.0, penetration = 95.0, zoom = 3.0, price = 6000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "L96", class = "Sniper", damage = 155.0, rpm = 42.0, magazine = 5, range = 67.0, accuracy = 14.0, reloadRating = 34.0, move = 202.0, penetration = 100.0, zoom = 4.0, price = 6750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Scout", class = "Sniper", damage = 130.0, rpm = 60.0, magazine = 10, range = 58.0, accuracy = 18.0, reloadRating = 40.0, move = 220.0, penetration = 85.0, zoom = 2.0, price = 5500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M9", class = "Pistol", damage = 43.0, rpm = 300.0, magazine = 15, range = 30.0, accuracy = 88.0, reloadRating = 50.0, move = 230.0, penetration = 55.0, zoom = 1.0, price = 5000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Glock 17", class = "Pistol", damage = 40.0, rpm = 340.0, magazine = 17, range = 28.0, accuracy = 85.0, reloadRating = 52.0, move = 232.0, penetration = 52.0, zoom = 1.0, price = 5250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "USP45", class = "Pistol", damage = 48.0, rpm = 260.0, magazine = 12, range = 32.0, accuracy = 90.0, reloadRating = 48.0, move = 228.0, penetration = 58.0, zoom = 1.0, price = 5750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "P226", class = "Pistol", damage = 44.0, rpm = 290.0, magazine = 15, range = 31.0, accuracy = 89.0, reloadRating = 50.0, move = 230.0, penetration = 56.0, zoom = 1.0, price = 5500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Five-Seven", class = "Pistol", damage = 38.0, rpm = 360.0, magazine = 20, range = 27.0, accuracy = 84.0, reloadRating = 53.0, move = 235.0, penetration = 50.0, zoom = 1.0, price = 6000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M249", class = "LMG", damage = 28.0, rpm = 550.0, magazine = 60, range = 45.0, accuracy = 70.0, reloadRating = 36.0, move = 195.0, penetration = 70.0, zoom = 1.0, price = 5750, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "PKM", class = "LMG", damage = 32.0, rpm = 500.0, magazine = 75, range = 50.0, accuracy = 68.0, reloadRating = 32.0, move = 190.0, penetration = 78.0, zoom = 1.0, price = 6500, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "RPK", class = "LMG", damage = 30.0, rpm = 540.0, magazine = 60, range = 47.0, accuracy = 72.0, reloadRating = 38.0, move = 198.0, penetration = 72.0, zoom = 1.0, price = 6000, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "MG36", class = "LMG", damage = 27.0, rpm = 620.0, magazine = 50, range = 42.0, accuracy = 75.0, reloadRating = 40.0, move = 200.0, penetration = 65.0, zoom = 1.0, price = 5500, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Stoner 63", class = "LMG", damage = 29.0, rpm = 570.0, magazine = 65, range = 46.0, accuracy = 71.0, reloadRating = 35.0, move = 193.0, penetration = 73.0, zoom = 1.0, price = 6250, automatic = true})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "MK14 EBR", class = "Marksman", damage = 55.0, rpm = 250.0, magazine = 12, range = 53.0, accuracy = 85.0, reloadRating = 38.0, move = 215.0, penetration = 75.0, zoom = 2.0, price = 5750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "SR-25", class = "Marksman", damage = 58.0, rpm = 230.0, magazine = 10, range = 56.0, accuracy = 88.0, reloadRating = 36.0, move = 212.0, penetration = 78.0, zoom = 3.0, price = 6250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "G28", class = "Marksman", damage = 54.0, rpm = 260.0, magazine = 15, range = 52.0, accuracy = 84.0, reloadRating = 40.0, move = 218.0, penetration = 72.0, zoom = 2.0, price = 5500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "M110", class = "Marksman", damage = 60.0, rpm = 220.0, magazine = 10, range = 58.0, accuracy = 90.0, reloadRating = 35.0, move = 208.0, penetration = 80.0, zoom = 3.0, price = 6750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "SVD", class = "Marksman", damage = 62.0, rpm = 210.0, magazine = 10, range = 60.0, accuracy = 82.0, reloadRating = 34.0, move = 205.0, penetration = 82.0, zoom = 3.0, price = 7000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Combat Knife", class = "Knife", damage = 110.0, rpm = 40.0, magazine = 1, range = 3.5, accuracy = 100.0, reloadRating = 50.0, move = 250.0, penetration = 100.0, zoom = 1.0, price = 5000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Tanto", class = "Knife", damage = 100.0, rpm = 48.0, magazine = 1, range = 3.2, accuracy = 100.0, reloadRating = 50.0, move = 250.0, penetration = 100.0, zoom = 1.0, price = 5250, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Kukri", class = "Knife", damage = 125.0, rpm = 34.0, magazine = 1, range = 3.8, accuracy = 100.0, reloadRating = 50.0, move = 245.0, penetration = 100.0, zoom = 1.0, price = 6000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Karambit", class = "Knife", damage = 95.0, rpm = 52.0, magazine = 1, range = 3.0, accuracy = 100.0, reloadRating = 50.0, move = 250.0, penetration = 100.0, zoom = 1.0, price = 5750, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Bowie Knife", class = "Knife", damage = 130.0, rpm = 30.0, magazine = 1, range = 4.0, accuracy = 100.0, reloadRating = 50.0, move = 240.0, penetration = 100.0, zoom = 1.0, price = 6500, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
do
    local weapon = table.freeze({id = "Tactical Axe", class = "Knife", damage = 145.0, rpm = 26.0, magazine = 1, range = 4.2, accuracy = 100.0, reloadRating = 50.0, move = 235.0, penetration = 100.0, zoom = 1.0, price = 7000, automatic = false})
    table.insert(Catalog.Order, weapon.id)
    Catalog.ById[weapon.id] = weapon
end
table.freeze(Catalog.Order)
table.freeze(Catalog.ById)
return table.freeze(Catalog)
