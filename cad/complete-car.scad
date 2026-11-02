// ============================================================================
// cute-esp32-lego-car / cad / complete-car.scad
// 可爱乐高积木风格 ESP32 四轮智能小车 — 完整总装与爆炸分解参数化主模型
// ============================================================================

include <parameters.scad>
use <components.scad>
use <battery-holder.scad>
use <chassis.scad>
use <electronic-layout.scad>
use <lego-body.scad>

// 视图模式控制参数:
// explode_factor = 0.0 -> 1:1 真实紧凑总装视图
// explode_factor = 1.0 -> 分层爆炸拆解视图 (展示底盘/电池仓/电子层/乐高壳/快拆车顶)
explode_factor = 0.0; // 可在 OpenSCAD Customizer 中调节 [0.0 : 0.1 : 1.5]
show_lego_shell = true;
show_roof_cap   = true;

module complete_esp32_lego_car(explode = 0.0) {
    // 1. 下层主动力亚克力底盘 + 四台 1812-N20 蜗轮电机 + 四只 34mm 车轮
    translate([0, 0, -25.0 * explode]) {
        lower_acrylic_deck();
        drivetrain_assembly();
    }

    // 2. 下层中心 2S 18650 电池仓 + BMS + 前后 HC-SR04 超声波模块
    translate([0, 0, 0.0 * explode]) {
        translate([0, 0, lower_deck_top_z])
            battery_compartment_assembly();
        translate([76.0, 0, lower_deck_top_z + 14.0])
            hcsr04_model(facing_front = true);
        translate([-76.0, 0, lower_deck_top_z + 14.0])
            hcsr04_model(facing_front = false);
        m3_standoffs();
    }

    // 3. 上层电子仓亚克力安装板 + ESP32扩展板 + 2x L298N + LM2596S + SU-03T
    translate([0, 0, 35.0 * explode]) {
        upper_acrylic_deck();
        translate([34.5, 0, upper_deck_top_z])
            esp32_with_expansion_model();
        translate([-33.5, 24.5, upper_deck_top_z])
            l298n_driver_model();
        translate([-33.5, -24.5, upper_deck_top_z])
            l298n_driver_model();
        translate([-1.0, 0, upper_deck_top_z])
        rotate([0, 0, 90])
            lm2596s_model();
        translate([52.0, 36.0, upper_deck_top_z])
            su03t_and_speaker_model();
    }

    // 4. 马卡龙配色乐高积木主车壳 + OLED 眼睛 + 双颊麦克风 (INMP441 & SU-03T 咪头)
    if (show_lego_shell) {
        translate([0, 0, 75.0 * explode]) {
            lego_main_body_shell();
            translate([71.0, 0, 76.0])
                oled_096_model();
            translate([74.0, 28.0, 54.0])
                inmp441_mic_model();
        }
    }

    // 5. 4 凸粒快拆式薄荷绿+奶油黄圆润车顶盖 (含 L298N 散热百叶窗)
    if (show_roof_cap) {
        translate([0, 0, 120.0 * explode]) {
            lego_removable_roof_cap();
        }
    }
}

complete_esp32_lego_car(explode = explode_factor);
