// ============================================================================
// 整车总装预览主控文件 (Complete Cyber Rover Assembly)
// ============================================================================
include <cyber_parameters.scad>
use <part1_chassis.scad>
use <part2_mid_deck.scad>
use <part3_cyber_shell.scad>
use <part4_roof_canopy.scad>

module complete_cyber_rover(explode = 0.0) {
    // Part 1 底盘
    translate([0, 0, -20.0 * explode])
        lower_power_chassis();

    // Part 2 中层托盘
    translate([0, 0, 10.0 * explode])
        electronics_mid_deck();

    // Part 3 主车壳
    translate([0, 0, 45.0 * explode])
        cyber_armor_shell();

    // Part 4 快拆顶盖
    translate([0, 0, 85.0 * explode])
        quick_release_roof_canopy();
}

complete_cyber_rover(explode = 0.0);
