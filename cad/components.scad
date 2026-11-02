// ============================================================================
// cute-esp32-lego-car / cad / components.scad
// 核心机电与电子模块三维几何包络组件库 (1:1 毫米尺寸)
// ============================================================================

include <parameters.scad>

// 1. 1812-N20 蜗轮蜗杆减速电机 (6V 190RPM 速比42 长轴 带支架, Row 38)
// 原点: 输出轴中心投影在电机底面的位置 (X=0 为轮轴线, Y=0 为电机中心面, Z=0 为电机底面)
module n20_worm_motor_assembly(is_left = true, is_front = true) {
    dir_x = is_front ? -1 : 1; // 前电机机身向后(-X)延伸, 后电机机身向前(+X)延伸
    dir_y = is_left  ?  1 : -1;

    // (a) 1812 蜗轮齿轮箱 (18 x 12 x 10 mm)
    color([0.78, 0.72, 0.35])
    translate([dir_x > 0 ? -n20_shaft_offset_x : -(n20_gearbox_length - n20_shaft_offset_x),
               -n20_motor_width/2, 0])
        cube([n20_gearbox_length, n20_motor_width, n20_motor_height]);

    // (b) N20 直流电机本体 (15 x 12 x 10 mm)
    color([0.75, 0.77, 0.80])
    translate([dir_x > 0 ? (n20_gearbox_length - n20_shaft_offset_x) : -(n20_motor_length - n20_shaft_offset_x),
               -n20_motor_width/2, 0])
        cube([n20_motor_body_length, n20_motor_width, n20_motor_height]);

    // (c) 尾部电源焊片与线弯包络提示区 (半透明红)
    color([0.9, 0.2, 0.2, 0.45])
    translate([dir_x > 0 ? (n20_motor_length - n20_shaft_offset_x) : -(n20_motor_length - n20_shaft_offset_x + n20_wire_bend_margin),
               -n20_motor_width/2, 1])
        cube([n20_wire_bend_margin, n20_motor_width, n20_motor_height - 2]);

    // (d) 横向正交 D 型输出轴 (外伸装车轮 + 内伸双出长轴)
    color([0.85, 0.85, 0.88])
    translate([0, 0, n20_axle_height_from_base])
    rotate([-90 * dir_y, 0, 0]) {
        // 外侧出轴 (穿过轮槽接 34mm 车轮)
        cylinder(d = wheel_bore_dia, h = n20_motor_width/2 + n20_shaft_out_len);
        // 内侧双出轴 (朝向电池仓方向)
        translate([0, 0, -(n20_motor_width/2 + n20_shaft_in_len)])
            cylinder(d = wheel_bore_dia, h = n20_motor_width/2 + n20_shaft_in_len);
    }

    // (e) 专用安装支架
    color([0.25, 0.25, 0.28])
    translate([-6, -n20_bracket_width/2, 0])
        difference() {
            cube([12, n20_bracket_width, 2.0]);
            translate([6, n20_bracket_width/2 - n20_bracket_hole_dist/2, -0.5])
                cylinder(d = n20_bracket_hole_dia, h = 4);
            translate([6, n20_bracket_width/2 + n20_bracket_hole_dist/2, -0.5])
                cylinder(d = n20_bracket_hole_dia, h = 4);
        }
}

// 2. ZJ327 34mm N20 橡胶车轮 (Row 18 & Row 23)
// 原点: 车轮内侧轮毂端面中心
module wheel_34mm_model(is_left = true) {
    dir_y = is_left ? 1 : -1;
    rotate([-90 * dir_y, 0, 0]) {
        // 黑色橡胶轮胎外圈 (Ø34 x 7mm)
        color([0.15, 0.15, 0.17])
        translate([0, 0, wheel_hub_width - wheel_tire_width])
        difference() {
            cylinder(d = wheel_diameter, h = wheel_tire_width);
            translate([0, 0, -0.5])
                cylinder(d = 24.0, h = wheel_tire_width + 1.0);
        }
        // 白色/黑色轮毂与内侧码盘凸台 (总厚 9.5mm)
        color([0.92, 0.92, 0.90])
        difference() {
            union() {
                cylinder(d = 24.2, h = wheel_hub_width);
                cylinder(d = 12.0, h = wheel_hub_width + 0.5);
            }
            translate([0, 0, -0.5])
                cylinder(d = wheel_bore_dia, h = wheel_hub_width + 2.0);
        }
    }
}

// 3. L298N 电机驱动模块 (43 x 43 x 27 mm, Row 20)
module l298n_driver_model() {
    translate([-l298n_length/2, -l298n_width/2, 0]) {
        // 红色 PCB
        color([0.80, 0.12, 0.12])
        difference() {
            cube([l298n_length, l298n_width, 1.6]);
            for (dx = [3.0, l298n_length - 3.0], dy = [3.0, l298n_width - 3.0])
                translate([dx, dy, -0.5]) cylinder(d = 3.2, h = 3.0);
        }
        // 黑色阳极氧化铝散热片 (居中偏后, 高 25.4mm)
        color([0.18, 0.18, 0.20])
        translate([11.5, 14.0, 1.6])
            cube([20.0, 15.0, l298n_total_height - 1.6]);
        // 蓝色螺丝接线端子 (左右电机端 + 前部电源端)
        color([0.10, 0.35, 0.80]) {
            translate([1.0, 14.0, 1.6])  cube([7.5, 10.0, 10.5]);
            translate([34.5, 14.0, 1.6]) cube([7.5, 10.0, 10.5]);
            translate([14.0, 1.0, 1.6])  cube([15.0, 7.5, 10.5]);
        }
        // 2个滤波电解电容
        color([0.2, 0.2, 0.2]) {
            translate([10.0, 34.0, 1.6]) cylinder(d = 8.0, h = 13.0);
            translate([33.0, 34.0, 1.6]) cylinder(d = 8.0, h = 13.0);
        }
    }
}

// 4. ESP32-WROOM-32E + 38Pin 螺丝端子扩展底板 (Row 12 重购件)
module esp32_with_expansion_model() {
    // 扩展底板 (X向宽 53mm, Y向长 66mm)
    color([0.12, 0.45, 0.22])
    translate([-esp32_exp_width/2, -esp32_exp_length/2, 0])
    difference() {
        cube([esp32_exp_width, esp32_exp_length, 1.6]);
        for (dx = [(esp32_exp_width - esp32_exp_hole_y)/2, (esp32_exp_width + esp32_exp_hole_y)/2])
            for (dy = [(esp32_exp_length - esp32_exp_hole_x)/2, (esp32_exp_length + esp32_exp_hole_x)/2])
                translate([dx, dy, -0.5]) cylinder(d = 3.2, h = 3.0);
    }
    // 两侧绿色螺丝端子排
    color([0.15, 0.68, 0.30]) {
        translate([-esp32_exp_width/2 + 2.0, -esp32_exp_length/2 + 5.0, 1.6])
            cube([7.5, esp32_exp_length - 10.0, 10.0]);
        translate([esp32_exp_width/2 - 9.5, -esp32_exp_length/2 + 5.0, 1.6])
            cube([7.5, esp32_exp_length - 10.0, 10.0]);
    }
    // 顶部叠插的 ESP32-WROOM-32E 核心板
    color([0.15, 0.15, 0.18])
    translate([-esp32_core_width/2, -esp32_core_length/2, 11.0])
        cube([esp32_core_width, esp32_core_length, 1.6]);
    // WROOM-32E 金属屏蔽罩
    color([0.82, 0.84, 0.86])
    translate([-9.0, 4.0, 12.6])
        cube([18.0, 19.0, 3.2]);
    // Type-C 接口 (朝向 -Y 右侧检修口)
    color([0.75, 0.75, 0.78])
    translate([-4.5, -esp32_core_length/2 - 1.5, 12.6])
        cube([9.0, 7.5, 3.2]);
}

// 5. LM2596S DC-DC 降压稳压模块 (Row 10)
module lm2596s_model() {
    translate([-lm2596_width/2, -lm2596_length/2, 0]) {
        color([0.10, 0.28, 0.65])
            cube([lm2596_width, lm2596_length, 1.6]);
        // 环形电感与电位器
        color([0.25, 0.25, 0.25])
            translate([10.5, 21.5, 1.6]) cylinder(d = 12.0, h = 10.0);
        color([0.15, 0.45, 0.85])
            translate([3.0, 16.0, 1.6]) cube([4.5, 9.5, 10.0]);
    }
}

// 6. HC-SR04 超声波测距模块 (Row 16)
module hcsr04_model(facing_front = true) {
    rot_z = facing_front ? 0 : 180;
    rotate([0, 0, rot_z]) {
        // 蓝色竖置 PCB (45mm 宽 x 20mm 高)
        color([0.10, 0.38, 0.78])
        translate([-hcsr04_pcb_thick, -hcsr04_width/2, -hcsr04_height/2])
            cube([hcsr04_pcb_thick, hcsr04_width, hcsr04_height]);
        // 两个 Ø16mm 超声波铝合金探头 (中心距 26mm)
        color([0.82, 0.84, 0.88])
        for (sy = [-hcsr04_can_pitch/2, hcsr04_can_pitch/2])
            translate([0, sy, 0])
            rotate([0, 90, 0])
                cylinder(d = hcsr04_can_dia, h = hcsr04_can_depth);
    }
}

// 7. 0.96寸 OLED 显示屏模块 (Row 19)
module oled_096_model() {
    color([0.08, 0.22, 0.55])
    translate([0, -oled_width/2, -oled_height/2])
        cube([1.6, oled_width, oled_height]);
    // 黑色玻璃显示区 (26 x 14 mm)
    color([0.05, 0.08, 0.12])
    translate([1.6, -13.0, -7.0])
        cube([1.5, 26.0, 14.0]);
}

// 8. SU-03T 离线语音模块 + 腔体喇叭 + INMP441 麦克风 (Row 01 & Row 30)
module su03t_and_speaker_model() {
    // SU-03T 绿板 (26 x 21 mm)
    color([0.15, 0.62, 0.28])
    translate([-su03t_width/2, -su03t_length/2, 0])
        cube([su03t_width, su03t_length, 8.0]);
    // 8Ω 腔体小喇叭 (30 x 20 x 6.5 mm)
    color([0.18, 0.18, 0.20])
    translate([18.0, -speaker_length/2, 0])
        cube([speaker_width, speaker_length, speaker_height]);
}

module inmp441_mic_model() {
    color([0.12, 0.12, 0.15])
    rotate([0, 90, 0])
        cylinder(d = inmp441_dia, h = 2.0);
}
