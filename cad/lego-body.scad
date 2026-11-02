// ============================================================================
// cute-esp32-lego-car / cad / lego-body.scad
// Q版马卡龙配色真乐高积木拼装外壳与 4 凸粒快拆车顶参数化模型
// 配色: 奶油黄车身 + 薄荷绿腰线/车顶装饰 + 奶白色保险杠 + 粉色腮红 + 深灰前窗
// ============================================================================

include <parameters.scad>

// 马卡龙配色定义 (RGB)
c_cream_yellow = [0.99, 0.91, 0.60]; // 奶油黄 (LEGO Bright Light Yellow)
c_mint_green   = [0.64, 0.89, 0.78]; // 薄荷绿 (LEGO Medium Green / Aqua)
c_milk_white   = [0.97, 0.97, 0.95]; // 奶白色 (LEGO White)
c_blush_pink   = [0.96, 0.64, 0.76]; // 腮红粉 (LEGO Bright Pink)
c_window_gray  = [0.24, 0.26, 0.30]; // 深灰/黑车窗 (LEGO Dark Bluish Gray)

// 通用带凸粒标准乐高砖模块 (studs_x * studs_y * plates_z)
module lego_brick_unit(studs_x, studs_y, plates_z = 3, with_studs = true, col = c_cream_yellow) {
    bx = studs_x * lego_stud_pitch - lego_tolerance;
    by = studs_y * lego_stud_pitch - lego_tolerance;
    bz = plates_z * lego_plate_height;
    color(col) {
        translate([-bx/2, -by/2, 0])
            cube([bx, by, bz]);
        if (with_studs) {
            for (ix = [0 : studs_x - 1], iy = [0 : studs_y - 1]) {
                sx = (-studs_x/2 + 0.5 + ix) * lego_stud_pitch;
                sy = (-studs_y/2 + 0.5 + iy) * lego_stud_pitch;
                translate([sx, sy, bz])
                    cylinder(d = lego_stud_dia, h = lego_stud_height);
            }
        }
    }
}

// 1. 乐高积木主车体外壳 (Layers 1~8, Z = 12.0 ~ 88.8 mm)
module lego_main_body_shell() {
    base_z = lower_deck_top_z; // 12.0mm

    // (a) 底层四周 Technic 科技孔砖锁紧基座圈 (Layer 1~2)
    // 中段左右侧裙 (避开前后 34mm 车轮拱门)
    for (sy = [-1, 1]) {
        translate([0, sy * 56.0, base_z])
            lego_brick_unit(6, 2, 6, true, c_cream_yellow);
    }

    // (b) 车头与车尾奶白色圆润保险杠 (X = ±84mm, 预留中间 6 Studs = 48mm 超声波开口)
    for (sx = [-1, 1]) {
        // 保险杠下唇 (全宽 16 Studs = 128mm)
        translate([sx * 84.0, 0, base_z])
            lego_brick_unit(1, 16, 3, false, c_milk_white);
        // 保险杠左右护角 (留出中央 Y ∈ [-24, +24]mm 给 HC-SR04 探头)
        for (sy = [-1, 1]) {
            translate([sx * 80.0, sy * 44.0, base_z + lego_brick_height])
                lego_brick_unit(2, 5, 6, true, c_milk_white);
        }
    }

    // (c) 第 3~6 层: 奶油黄车身四壁 + 跨越 34mm 车轮的轮眉拱砖 + 薄荷绿马卡龙腰线
    // 左右侧墙 (全长 20 Studs = 160mm, 在 Z = 40.8mm 处跨越前后车轮顶)
    for (sy = [-1, 1]) {
        // 第 4~5 层薄荷绿装饰腰线与侧面散热格栅
        translate([0, sy * 56.0, base_z + 3 * lego_brick_height])
            lego_brick_unit(20, 2, 3, true, c_mint_green);
        // 第 5~8 层奶油黄侧壁上段 (右侧预留 ESP32 Type-C 检修口)
        translate([0, sy * 56.0, base_z + 4 * lego_brick_height])
            difference() {
                lego_brick_unit(20, 2, 9, true, c_cream_yellow);
                if (sy < 0) {
                    // 右侧 ESP32 USB-C 免拆壳插线窗口
                    translate([25.0, -10.0, 4.0])
                        cube([22.0, 20.0, 16.0]);
                }
            }
    }

    // (d) 车头前脸 (X = +72mm): 粉色腮红双拾音孔 + 深灰色 OLED 表情挡风窗
    // 前脸中段奶油黄基底
    translate([72.0, 0, base_z + 3 * lego_brick_height])
        lego_brick_unit(2, 12, 6, true, c_cream_yellow);

    // 左右马卡龙粉色腮红装饰砖 (带 Ø4mm 麦克风拾音孔: 左 INMP441, 右 SU-03T 咪头)
    for (sy = [-1, 1]) {
        translate([79.0, sy * 28.0, base_z + 4 * lego_brick_height])
        difference() {
            lego_brick_unit(1, 2, 3, false, c_blush_pink);
            translate([0, 0, 4.8])
            rotate([0, 90, 0])
                cylinder(d = 4.2, h = 12.0, center = true);
        }
    }

    // 车头上部深灰色 Q 版挡风玻璃窗框 (内嵌 0.96寸 OLED 表情屏窗口 32 x 19.2 mm)
    translate([72.0, 0, base_z + 5 * lego_brick_height])
    difference() {
        lego_brick_unit(2, 12, 9, true, c_window_gray);
        // 4 Studs (32mm) 宽 x 2 Bricks (19.2mm) 高 OLED 视窗开孔
        translate([-10.0, -16.0, 4.8])
            cube([20.0, 32.0, 19.2]);
    }

    // (e) 车尾后墙 (X = -72mm): 奶油黄后壁 + 薄荷绿尾翼条 + 右下角开关/Type-C充电窗口
    translate([-72.0, 0, base_z + 3 * lego_brick_height])
    difference() {
        lego_brick_unit(2, 12, 15, true, c_cream_yellow);
        // 车尾下层充电 Type-C 与 KCD11 主电源开关操作窗口
        translate([-10.0, -34.0, -18.0])
            cube([20.0, 68.0, 22.0]);
    }

    // (f) 第 8 层车壳上沿光滑砖封边 (Tile Layer, 仅四角保留 4 颗凸粒实现快拆车顶)
    for (sy = [-1, 1]) {
        translate([0, sy * 56.0, base_z + 8 * lego_brick_height])
            lego_brick_unit(18, 2, 1, false, c_mint_green);
    }
}

// 2. 可快速拆卸的圆润车顶盖总成 (Quick-Release Roof Cap, Z = 92.0 ~ 111.2 mm)
module lego_removable_roof_cap() {
    roof_z = lower_deck_top_z + 8 * lego_brick_height + lego_plate_height; // 92.0mm

    translate([0, 0, roof_z]) {
        // 车顶奶油黄主承载板 (18 x 14 Studs = 144 x 112 mm)
        difference() {
            lego_brick_unit(18, 14, 3, true, c_cream_yellow);
            // 后部正对两块 L298N 散热片的双通风百叶窗开槽
            for (sy = [-24.5, 24.5])
                translate([-50.0, sy - 12.0, -1.0])
                    cube([32.0, 24.0, 14.0]);
            // 前部正对 SU-03T 腔体喇叭的出声孔阵列
            translate([38.0, 20.0, -1.0])
                cube([24.0, 24.0, 14.0]);
        }

        // 车顶中央薄荷绿圆润装饰盖与百叶窗通风砖 (1x2 Grille Tiles 2412b)
        translate([-34.0, 24.5, lego_brick_height])
            lego_brick_unit(4, 3, 1, false, c_mint_green);
        translate([-34.0, -24.5, lego_brick_height])
            lego_brick_unit(4, 3, 1, false, c_mint_green);
        translate([12.0, 0, lego_brick_height])
            lego_brick_unit(8, 10, 2, true, c_mint_green);
    }
}

// 单独预览乐高车壳与快拆顶盖
lego_main_body_shell();
lego_removable_roof_cap();
