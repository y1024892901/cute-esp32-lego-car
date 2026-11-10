// ============================================================================
// Part 3: 赛博机能黑透主车壳 (Cyber Armor Body Shell)
// ============================================================================
include <cyber_parameters.scad>

module cyber_armor_shell() {
    difference() {
        union() {
            // 主车体下裙 (148 x 116 x 36 mm, Z=40.0~76.0)
            translate([-74, -58, 40.0])
                cube([148, 116, 36.0]);
            // 前倾战术 Visor (OLED 表情屏视窗框架)
            translate([48, -50, 60.0])
                cube([26, 100, 26.0]);
            // 前超声波加农炮筒护圈
            for (py = [-13.0, 13.0]) {
                translate([84.0, py, 53.0])
                rotate([0, 90, 0])
                    cylinder(d = 21.0, h = 6.0);
            }
        }

        // 掏空内腔 (内部空腔包容电子托盘与模块)
        translate([-71.5, -55.5, 38.0])
            cube([143, 111, 40.0]);

        // 前脸双超声波探头开孔 (Ø16.2mm)
        for (py = [-13.0, 13.0]) {
            translate([80.0, py, 53.0])
            rotate([0, 90, 0])
                cylinder(d = 16.2, h = 15.0);
        }

        // 前 OLED HUD 视窗开孔 (32 x 18 mm)
        translate([66.0, -16.0, 64.0])
            cube([15.0, 32.0, 18.0]);

        // 右侧 Type-C 检修接口开孔
        translate([22.0, -60.0, 48.0])
            cube([24.0, 10.0, 12.0]);

        // 车尾 KCD11 开关与充电口开孔
        translate([-78.0, 28.0, 48.0])
            cube([10.0, 18.0, 14.0]);

        // 车顶 4 角磁铁嵌入槽 (Ø4.2 x 2.2mm)
        for (rx = [42, -64], ry = [38, -38]) {
            translate([rx, ry, 74.0])
                cylinder(d = magnet_dia, h = magnet_depth + 1);
        }
    }
}

cyber_armor_shell();
