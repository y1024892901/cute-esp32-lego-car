// ============================================================================
// cute-esp32-lego-car / cad / chassis.scad
// 双层 3mm 亚克力 + 乐高科技砖混合底盘参数化模型
// 兼容已购 200x300x3mm 亚克力板直线勾刀裁切或激光切割
// ============================================================================

include <parameters.scad>
use <components.scad>

// 1. 下层主动力亚克力板 (160 x 128 x 3 mm, Z = 9.0 ~ 12.0 mm)
module lower_acrylic_deck() {
    color([0.82, 0.92, 0.98, 0.55])
    translate([0, 0, lower_deck_bottom_z])
    difference() {
        // 主矩形板 (160 x 128 mm = 20 x 16 Studs)
        translate([-chassis_length/2, -chassis_width/2, 0])
            cube([chassis_length, chassis_width, acrylic_thickness]);

        // (a) 四角直线直角车轮避让切口 (46.0 x 18.0 mm)
        for (sx = [-1, 1], sy = [-1, 1]) {
            cut_x = (sx > 0) ? (front_axle_x - wheel_cutout_len/2) : (rear_axle_x - wheel_cutout_len/2);
            cut_y = (sy > 0) ? wheel_well_inner_y : (-chassis_width/2 - 0.1);
            translate([cut_x, cut_y, -0.5])
                cube([wheel_cutout_len, wheel_cutout_depth + 0.1, acrylic_thickness + 1.0]);
        }

        // (b) 中心 18650 电池盒底部 M3 固定孔 + 两条 20mm 魔术贴穿带槽
        for (hx = [-battery_box_hole_dist/2, battery_box_hole_dist/2])
            translate([hx, 0, -0.5])
                cylinder(d = 3.2, h = acrylic_thickness + 1.0);
        for (sy = [-1, 1])
            translate([-11.0, sy * (battery_holder_width/2 + 2.5) - 1.75, -0.5])
                cube([22.0, 3.5, acrylic_thickness + 1.0]);

        // (c) 4 台 1812-N20 蜗轮电机支架安装孔
        for (sx = [-1, 1], sy = [-1, 1]) {
            ax_x = sx * (wheelbase / 2.0);
            mot_y = sy * (motor_inner_y + n20_motor_width/2);
            for (hy = [-n20_bracket_hole_dist/2, n20_bracket_hole_dist/2])
                translate([ax_x, mot_y + hy, -0.5])
                    cylinder(d = n20_bracket_hole_dia, h = acrylic_thickness + 1.0);
        }

        // (d) 6 根 M3x35mm 上下层支撑铜柱安装孔
        for (px = [-60.0, 0.0, 60.0], py = [-42.0, 42.0])
            translate([px, py, -0.5])
                cylinder(d = 3.2, h = acrylic_thickness + 1.0);

        // (e) 外边缘乐高科技砖转接孔 (严格对齐 8.0mm Stud 模数网格)
        for (ix = [-8, -4, 4, 8])
            for (sy = [-1, 1])
                translate([ix * lego_stud_pitch, sy * 42.0, -0.5])
                    cylinder(d = 3.2, h = acrylic_thickness + 1.0);
        for (iy = [-6, -2, 2, 6])
            for (sx = [-1, 1])
                translate([sx * 76.0, iy * lego_stud_pitch, -0.5])
                    cylinder(d = 3.2, h = acrylic_thickness + 1.0);
    }
}

// 2. 上层电子仓亚克力安装板 (136 x 96 x 3 mm, Z = 47.0 ~ 50.0 mm)
module upper_acrylic_deck() {
    color([0.82, 0.92, 0.98, 0.55])
    translate([0, 0, upper_deck_bottom_z])
    difference() {
        translate([-upper_deck_length/2, -upper_deck_width/2, 0])
            cube([upper_deck_length, upper_deck_width, acrylic_thickness]);

        // (a) 6 个 M3 铜柱锁紧孔
        for (px = [-60.0, 0.0, 60.0], py = [-42.0, 42.0])
            translate([px, py, -0.5])
                cylinder(d = 3.2, h = acrylic_thickness + 1.0);

        // (b) 两侧中部过线长腰槽 (28 x 10 mm, 供电机线/电池线/超声波排线穿过)
        for (sy = [-1, 1])
            translate([-14.0, sy * 32.0 - 5.0, -0.5])
                cube([28.0, 10.0, acrylic_thickness + 1.0]);

        // (c) 左/右两块 L298N 驱动板 M3 安装孔 (37x37mm 孔距)
        for (sy = [-1, 1]) {
            cx = -33.5;
            cy = sy * 24.5;
            for (dx = [-l298n_hole_pitch/2, l298n_hole_pitch/2])
                for (dy = [-l298n_hole_pitch/2, l298n_hole_pitch/2])
                    translate([cx + dx, cy + dy, -0.5])
                        cylinder(d = 3.2, h = acrylic_thickness + 1.0);
        }

        // (d) 前部 ESP32 螺丝端子扩展底板 M3 安装孔
        for (dx = [-esp32_exp_hole_y/2, esp32_exp_hole_y/2])
            for (dy = [-esp32_exp_hole_x/2, esp32_exp_hole_x/2])
                translate([34.5 + dx, dy, -0.5])
                    cylinder(d = 3.2, h = acrylic_thickness + 1.0);
    }
}

// 3. 6 根 M3x35mm 六角黄铜隔离柱
module m3_standoffs() {
    color([0.85, 0.68, 0.22])
    for (px = [-60.0, 0.0, 60.0], py = [-42.0, 42.0])
        translate([px, py, lower_deck_top_z])
            cylinder(d = 5.5, h = standoff_height, $fn = 6);
}

// 4. 四轮与四台 1812-N20 电机动力总成安装
module drivetrain_assembly() {
    for (sx = [-1, 1], sy = [-1, 1]) {
        ax_x  = sx * (wheelbase / 2.0);
        mot_y = sy * (motor_inner_y + n20_motor_width/2);
        whl_y = sy * wheel_inner_y;

        // 1812-N20 电机 (底面位于 Z = 12.0mm)
        translate([ax_x, mot_y, lower_deck_top_z])
            n20_worm_motor_assembly(is_left = (sy > 0), is_front = (sx > 0));

        // ZJ327 34mm 车轮 (轴心位于 Z = 17.0mm)
        translate([ax_x, whl_y, axle_z])
            wheel_34mm_model(is_left = (sy > 0));
    }
}

// 完整双层底盘与动力总成
module complete_chassis_assembly() {
    lower_acrylic_deck();
    upper_acrylic_deck();
    m3_standoffs();
    drivetrain_assembly();
}

complete_chassis_assembly();
