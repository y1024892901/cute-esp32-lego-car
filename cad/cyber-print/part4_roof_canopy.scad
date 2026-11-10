// ============================================================================
// Part 4: 极客百叶风道快拆顶盖 (Quick-Release Roof Canopy)
// ============================================================================
include <cyber_parameters.scad>

module quick_release_roof_canopy() {
    difference() {
        union() {
            // 顶盖基板 (136 x 92 x 3.0 mm)
            translate([-68, -46, 88.0])
                cube([136, 92, 3.0]);

            // 尾部双扰流小尾翼
            for (fy = [36.0, -36.0]) {
                translate([-68, fy - 2.5, 91.0])
                    cube([32, 5.0, 12.0]);
            }
        }

        // L298N 散热片直通排热百叶缝 (8 道斜风口)
        for (lx = [-5 : 2]) {
            translate([lx * 10 - 2, -28, 87.0])
                cube([5.5, 56.0, 5.0]);
        }

        // 4 角磁铁沉槽 (与车壳对吸)
        for (rx = [42, -64], ry = [38, -38]) {
            translate([rx, ry, 88.0])
                cylinder(d = magnet_dia, h = magnet_depth);
        }
    }
}

quick_release_roof_canopy();
