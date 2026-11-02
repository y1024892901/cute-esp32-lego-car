// ============================================================================
// cute-esp32-lego-car / cad / electronic-layout.scad
// 上下双层全部电子硬件、传感器、语音与电池仓三维空间排布模型
// ============================================================================

include <parameters.scad>
use <components.scad>
use <battery-holder.scad>

module complete_electronic_layout() {
    // ------------------------------------------------------------------------
    // A. 下层中心与首尾部件 (Z = 12.0 ~ 36.0 mm)
    // ------------------------------------------------------------------------
    // A1. 18650 双节串联核心电池仓 + 2S BMS + 充电紫板 + 主开关 (几何正中)
    translate([0, 0, lower_deck_top_z])
        battery_compartment_assembly();

    // A2. 前置 HC-SR04 超声波模块 (位于车头下层 X = +76mm, 探头伸至 +88mm)
    translate([76.0, 0, lower_deck_top_z + 14.0])
        hcsr04_model(facing_front = true);

    // A3. 后置 HC-SR04 超声波模块 (位于车尾下层 X = -76mm, 探头伸至 -88mm)
    translate([-76.0, 0, lower_deck_top_z + 14.0])
        hcsr04_model(facing_front = false);

    // ------------------------------------------------------------------------
    // B. 上层电子安装板核心模块 (Z = 50.0 ~ 77.0 mm)
    // ------------------------------------------------------------------------
    // B1. ESP32-WROOM-32E + 38Pin 螺丝端子扩展底板 (前中部 X = +34.5mm)
    translate([34.5, 0, upper_deck_top_z])
        esp32_with_expansion_model();

    // B2. 左路 L298N 驱动模块 #1 (后左区 X = -33.5mm, Y = +24.5mm)
    translate([-33.5, 24.5, upper_deck_top_z])
        l298n_driver_model();

    // B3. 右路 L298N 驱动模块 #2 (后右区 X = -33.5mm, Y = -24.5mm)
    translate([-33.5, -24.5, upper_deck_top_z])
        l298n_driver_model();

    // B4. LM2596S 5.00V 降压稳压模块 (中段通道 X = -1.0mm, Y = 0.0mm)
    translate([-1.0, 0, upper_deck_top_z])
    rotate([0, 0, 90])
        lm2596s_model();

    // B5. SU-03T 离线语音识别绿板 + 8Ω 腔体小喇叭 (前侧翼区)
    translate([52.0, 36.0, upper_deck_top_z])
        su03t_and_speaker_model();

    // ------------------------------------------------------------------------
    // C. 车头人机交互面部器件 (OLED 眼睛 + 左右腮红双麦克风)
    // ------------------------------------------------------------------------
    // C1. 0.96寸 OLED 表情显示屏 (车头挡风窗内侧 X = +71.0mm, Z = 76.0mm)
    translate([71.0, 0, 76.0])
        oled_096_model();

    // C2. 左侧腮红内壁: INMP441 I2S 全向数字麦克风 (X = +74.0mm, Y = +28.0mm, Z = 54.0mm)
    translate([74.0, 28.0, 54.0])
        inmp441_mic_model();

    // C3. 右侧腮红内壁: SU-03T 驻极体模拟咪头 (X = +74.0mm, Y = -28.0mm, Z = 54.0mm)
    color([0.75, 0.78, 0.80])
    translate([74.0, -28.0, 54.0])
    rotate([0, 90, 0])
        cylinder(d = su03t_mic_dia, h = 6.7);
}

complete_electronic_layout();
