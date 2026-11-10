// ============================================================================
// Part 2: 中层高集成电子托盘 (Electronics Mid Deck)
// ============================================================================
include <cyber_parameters.scad>

module electronics_mid_deck() {
    difference() {
        union() {
            // 托盘基底板 (136 x 94 x 2.8 mm, Z=47.0)
            translate([-68, -47, 47.0])
                cube([136, 94, 2.8]);

            // ESP32 38Pin 扩展底板安装支柱 (60 x 47 mm)
            for (sx = [-30, 30], sy = [-23.5, 23.5]) {
                translate([33.0 + sx, sy, 49.8])
                    cylinder(d = 6.0, h = 4.0);
            }

            // 双 L298N 驱动板安装支柱 (37 x 37 mm)
            for (ly = [23.5, -23.5]) {
                for (px = [-18.5, 18.5], py = [-18.5, 18.5]) {
                    translate([-35.0 + px, ly + py, 49.8])
                        cylinder(d = 6.0, h = 4.0);
                }
            }

            // SU-03T 语音喇叭音孔支架
            translate([50.0, 32.0, 49.8])
                difference() {
                    cylinder(d = 29.0, h = 3.0);
                    cylinder(d = 26.0, h = 4.0);
                }
        }

        // 穿线槽 (左侧与右侧 oblong pass-through slots)
        for (sy = [-32, 32]) {
            translate([-10, sy - 4, 46.0])
                cube([20, 8, 5.0]);
        }

        // 4 个固定螺丝通孔 (与下层立柱对齐)
        for (px = [60, -60], py = [40, -40]) {
            translate([px, py, 46.0])
                cylinder(d = m3_pass_hole_dia, h = 6.0);
        }
    }
}

electronics_mid_deck();
