-- Regenerate from game/: luau tests/balance-report.luau > docs/BALANCE_AUDIT.md
local Catalog=require("../src/shared/WeaponCatalog")
local Combat=require("../src/shared/CombatMath")
local Traits=require("../src/shared/WeaponTraits")
local sums,counts={},{}
for _,id in Catalog.Order do
    local w=Catalog.ById[id]
    sums[w.class]=(sums[w.class] or 0)+w.damage*w.rpm/60
    counts[w.class]=(counts[w.class] or 0)+1
end
print("# Weapon baseline audit\n")
print("Generated from the current catalog and combat formulas. Handling traits add no damage or RPM.")
print("TTK is theoretical against 200 HP / 150 armor at zero falloff, excluding misses, spread, reloads, reaction and equip time.")
print("Shotgun figures assume every pellet hits; 0.000 head TTK means one successful headshot. This is not a ranked balance certification.\n")
print("| Class | Trait | Effect |\n| --- | --- | --- |")
local visited={}
for _,id in Catalog.Order do
    local w=Catalog.ById[id]
    if not visited[w.class] then
        visited[w.class]=true
        local trait=Traits.forWeapon(w)
        print(string.format("| %s | %s | %s |",w.class,trait.title,trait.description))
    end
end
print("\n| Weapon | Class | Raw DPS | vs class mean | Body TTK (s) | Head TTK (s) | Reload (s) | DPS review |")
print("| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |")
for _,id in Catalog.Order do
    local w=Catalog.ById[id]
    local dps=w.damage*w.rpm/60
    local delta=dps/(sums[w.class]/counts[w.class])-1
    print(string.format("| %s | %s | %.1f | %+.1f%% | %.3f | %.3f | %s | %s |",id,w.class,dps,delta*100,
        Combat.ttk(Combat.damage(w,150,false,0),w.rpm),Combat.ttk(Combat.damage(w,150,true,0),w.rpm),
        if w.class=="Knife" then "N/A" else string.format("%.2f",Combat.reloadSeconds(w)),
        if math.abs(delta)>.15 then "Review >15%" else "Within 15%"))
end
print("\n## Interpretation\n")
print("Use range, accuracy, magazine capacity and actual hit rates alongside these numbers. A low-rate precision weapon cannot be balanced by raw DPS alone.")
print("Three inherited rate outliers were adjusted slightly: Scout 65 -> 60 RPM, Karambit 55 -> 52 swings/min, Tactical Axe 25 -> 26 swings/min. Test miss punishment, reach, headshot thresholds and effective TTK before ranked play.")
print("Damage, armor penetration and range are unchanged. The three rate changes are explicit in WEAPON_BALANCE.md. Broad all-class TTK parity has not been established.")
