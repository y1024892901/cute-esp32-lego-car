// ============================================================================
// Part 1: 一体化动力底盘 (Lower Power & Drive Chassis)
// ============================================================================
include <cyber_parameters.scad>

module lower_power_chassis() {
    difference() {
        union() {
            // 主底盘大底 (160 x 124 x 3.5 mm)
            translate([-80, -44, ground_clearance])
                cube([160, 88, 3.5]);
            // 前后翼子板与保险杠斜坡
            translate([68, -62, ground_clearance]) cube([12, 124, 3.5]);
            translate([-80, -62, ground_clearance]) cube([12, 124, 3.5]);
            translate([-22, -62, ground_clearance]) cube([44, 124, 3.5]);

            // 4x 1812-N20 电机一体化沉托与固定座
            for (mx = [45, -45], my = [36, -36]) {
                translate([mx - 15, my - 7, ground_clearance + 3.5])
                    cube([30, 14, 3.0]);
            }

            // 中置 2S 18650 电池内嵌仓外壁
            translate([-bat_bay_l/2 - 2, -bat_bay_w/2 - 2, ground_clearance + 3.5])
                cube([bat_bay_l + 4, bat_bay_w + 4, bat_bay_h]);

            // 6 根 M3 中层托盘承重立柱 (高 34.5mm)
            for (px = [60, -60, 0], py = [40, -40]) {
                translate([px, py, ground_clearance + 3.5])
                    cylinder(d = 7.0, h = 34.5);
            }
        }

        // 减去: 电池内腔
        translate([-bat_bay_l/2, -bat_bay_w/2, ground_clearance + 3.5])
            cube([bat_bay_l, bat_bay_w, bat_bay_h + 1]);

        // 减去: 6 根立柱顶端 M3 热熔铜螺母沉孔
        for (px = [60, -60, 0], py = [40, -40]) {
            translate([px, py, ground_clearance + 38.0 - 5.0])
                cylinder(d = m3_heatset_hole_dia, h = 6.0);
        }
    }
}

lower_power_chassis();
