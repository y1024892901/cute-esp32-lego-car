// ============================================================================
// cute-esp32-lego-car / cad / parameters.scad
// 统一参数化工程尺寸数据库与自动空间干涉断言 (单位: mm)
// 状态: PARAMETRIC_DRAFT_PENDING_MEASUREMENT
// ============================================================================

$fn = 36;

// ----------------------------------------------------------------------------
// 0. 实测验证状态开关
// ----------------------------------------------------------------------------
DIMENSIONS_VERIFIED_BY_CALIPER = false; // 完成 CHK-01~09 实测后改为 true

// ----------------------------------------------------------------------------
// 1. 乐高积木标准几何常数 (VERIFIED_DATASHEET)
// ----------------------------------------------------------------------------
lego_stud_pitch       = 8.0;    // 1 Stud (1L) 水平中心距 = 8.00mm
lego_plate_height     = 3.2;    // 1 Plate 板高 = 3.20mm
lego_brick_height     = 9.6;    // 1 Brick 标准砖高 = 9.60mm (= 3 Plates)
lego_stud_dia         = 4.8;    // 凸粒直径 = 4.80mm
lego_stud_height      = 1.8;    // 凸粒高度 = 1.80mm
lego_pinhole_dia      = 4.85;   // Technic 销孔直径 = 4.85mm
lego_technic_axis_z   = 5.8;    // Technic 孔中心距砖底高度 = 5.80mm
lego_tolerance        = 0.2;    // 标准砖外廓负公差

// ----------------------------------------------------------------------------
// 2. 车轮与 1812-N20 蜗轮蜗杆减速电机参数 (SELLER_SPEC & MEASURE_REQUIRED)
// ----------------------------------------------------------------------------
wheel_diameter        = 34.0;   // [VERIFIED] ZJ327 橡胶轮外径 34mm (Row 18/23)
wheel_tire_width      = 7.0;    // [SELLER_SPEC] 胎面宽 7mm (34*7)
wheel_hub_width       = 9.5;    // [MEASURE_REQUIRED: CHK-03] 含内侧码盘凸台轮毂总宽
wheel_bore_dia        = 3.0;    // [VERIFIED] 3mm D型孔
wheel_bore_depth      = 8.5;    // [MEASURE_REQUIRED: CHK-03] D孔有效深度

// 1812-N20 蜗轮蜗杆电机 (6V 190RPM 速比42 长轴 带支架, Row 38)
n20_gearbox_length    = 18.0;   // [SELLER_SPEC] 1812蜗轮箱长 18mm
n20_motor_body_length = 15.0;   // [VERIFIED_DATASHEET] N20电机筒长 15mm
n20_motor_length      = n20_gearbox_length + n20_motor_body_length; // 33.0mm
n20_wire_bend_margin  = 5.0;    // [ESTIMATED] 尾部焊片与硅胶线弯折包络 +5mm
n20_motor_width       = 12.0;   // [VERIFIED_DATASHEET] 机身宽 12mm
n20_motor_height      = 10.0;   // [VERIFIED_DATASHEET] 机身厚 10mm
n20_shaft_offset_x    = 6.0;    // [SELLER_SPEC] 输出轴距齿轮箱前端 6mm
n20_axle_height_from_base = 5.0;// [MEASURE_REQUIRED: CHK-02] 输出轴中心距底板面高度
n20_shaft_out_len     = 10.0;   // [MEASURE_REQUIRED: CHK-01] 外侧(车轮侧)出轴长度
n20_shaft_in_len      = 8.0;    // [MEASURE_REQUIRED: CHK-01] 内侧(双出轴向电池侧)伸出长度
n20_bracket_width     = 24.0;   // [MEASURE_REQUIRED: CHK-02] 电机安装支架底座总宽
n20_bracket_hole_dist = 18.0;   // [MEASURE_REQUIRED: CHK-02] 支架安装孔中心距
n20_bracket_hole_dia  = 2.6;    // [MEASURE_REQUIRED: CHK-02] 支架安装孔径

// ----------------------------------------------------------------------------
// 3. 18650 双节串联电池仓与安全保护组件参数 (MEASURE_REQUIRED)
// ----------------------------------------------------------------------------
battery_holder_length = 76.0;   // [MEASURE_REQUIRED: CHK-04] 18650 2节串联盒长
battery_holder_width  = 41.0;   // [MEASURE_REQUIRED: CHK-04] 18650 2节串联盒宽
battery_holder_height = 21.0;   // [MEASURE_REQUIRED: CHK-04] 18650 2节串联盒高
battery_wire_margin   = 6.0;    // [ESTIMATED] 后端引线弯折裕量
battery_box_hole_dist = 35.0;   // [MEASURE_REQUIRED: CHK-04] 盒底沉头固定孔间距

bms_2s_length         = 36.0;   // [SELLER_SPEC] 2S 8A BMS 保护板长
bms_2s_width          = 16.0;   // [SELLER_SPEC] 2S 8A BMS 保护板宽
bms_2s_height         = 3.5;    // [SELLER_SPEC] 2S 8A BMS 保护板厚

charger_2s_length     = 39.0;   // [SELLER_SPEC] 2串锂电升压快充紫板长 (Row 11)
charger_2s_width      = 18.0;   // [SELLER_SPEC] 2串锂电升压快充紫板宽
charger_2s_height     = 6.5;    // [SELLER_SPEC] 2串锂电升压快充紫板高

// ----------------------------------------------------------------------------
// 4. 电子模块真实三维包络参数 (VERIFIED_DATASHEET & MEASURE_REQUIRED)
// ----------------------------------------------------------------------------
// L298N 电机驱动板 ×2 (Row 20)
l298n_length          = 43.0;   // [VERIFIED_DATASHEET] PCB长 43mm
l298n_width           = 43.0;   // [VERIFIED_DATASHEET] PCB宽 43mm
l298n_total_height    = 27.0;   // [MEASURE_REQUIRED: CHK-09] 含散热片与电容总高
l298n_hole_pitch      = 37.0;   // [VERIFIED_DATASHEET] 四角M3孔距 37x37mm

// ESP32-WROOM-32E + 38Pin 螺丝端子扩展底板 (Row 12 重购件)
esp32_core_length     = 54.5;   // [VERIFIED_DATASHEET] ESP32核心板长
esp32_core_width      = 28.0;   // [VERIFIED_DATASHEET] ESP32核心板宽
esp32_exp_length      = 66.0;   // [MEASURE_REQUIRED: CHK-05] 螺丝端子扩展板长(沿Y向横向布置)
esp32_exp_width       = 53.0;   // [MEASURE_REQUIRED: CHK-05] 螺丝端子扩展板宽(沿X向纵向布置)
esp32_exp_hole_x      = 60.0;   // [MEASURE_REQUIRED: CHK-05] 扩展板长向孔距
esp32_exp_hole_y      = 47.0;   // [MEASURE_REQUIRED: CHK-05] 扩展板宽向孔距
esp32_total_height    = 25.0;   // [MEASURE_REQUIRED: CHK-05] 核心板+扩展板叠插总高
esp32_usb_clearance   = 19.0;   // [ESTIMATED] Type-C插头插拔与线弯净空

// LM2596S DC-DC 降压稳压模块 (Row 10)
lm2596_length         = 43.0;   // [VERIFIED_DATASHEET]
lm2596_width          = 21.0;   // [VERIFIED_DATASHEET]
lm2596_height         = 14.0;   // [VERIFIED_DATASHEET]

// HC-SR04 超声波测距模块 ×2 (Row 16)
hcsr04_width          = 45.0;   // [VERIFIED_DATASHEET] PCB宽
hcsr04_height         = 20.0;   // [VERIFIED_DATASHEET] PCB高
hcsr04_pcb_thick      = 1.6;
hcsr04_can_dia        = 16.0;   // [VERIFIED_DATASHEET] 探头直径 16mm
hcsr04_can_depth      = 12.0;   // [VERIFIED_DATASHEET] 探头突出高度 12mm
hcsr04_can_pitch      = 26.0;   // [VERIFIED_DATASHEET] 双探头中心距 26mm

// 0.96寸 OLED 显示屏模块 (Row 19)
oled_width            = 27.3;   // [MEASURE_REQUIRED: CHK-07]
oled_height           = 27.8;   // [MEASURE_REQUIRED: CHK-07]
oled_total_depth      = 11.5;   // [MEASURE_REQUIRED: CHK-07] 含焊好排针总厚
oled_hole_x           = 23.0;
oled_hole_y           = 23.5;

// SU-03T 离线语音模块 + 腔体喇叭 + 驻极体咪头 (Row 30)
su03t_length          = 26.0;   // [SELLER_SPEC]
su03t_width           = 21.0;   // [SELLER_SPEC]
su03t_height          = 12.0;
speaker_length        = 30.0;   // [MEASURE_REQUIRED: CHK-06]
speaker_width         = 20.0;   // [MEASURE_REQUIRED: CHK-06]
speaker_height        = 6.5;    // [MEASURE_REQUIRED: CHK-06]
su03t_mic_dia         = 9.7;    // [MEASURE_REQUIRED: CHK-06]

// INMP441 I2S 数字麦克风模块 (Row 01)
inmp441_dia           = 14.0;   // [MEASURE_REQUIRED: CHK-08]
inmp441_height        = 11.5;   // [MEASURE_REQUIRED: CHK-08]

// ----------------------------------------------------------------------------
// 5. 由内部硬件包络自下而上推导的底盘与整车参数 (DERIVED PARAMETERS)
// ----------------------------------------------------------------------------
acrylic_thickness     = 3.0;    // [VERIFIED] 已购 3mm 20x30cm 亚克力板 (Row 32)

// 高度基准推导: 车轮半径 R = 17.0mm, 电机轴心距底板表面 5.0mm -> 下层底板顶面 Z = 12.0mm
axle_z                = wheel_diameter / 2.0;                  // 17.0mm
lower_deck_top_z      = axle_z - n20_axle_height_from_base;    // 12.0mm
lower_deck_bottom_z   = lower_deck_top_z - acrylic_thickness;  // 9.0mm (离地间隙)
standoff_height       = 35.0;                                  // M3x35mm 六角铜柱
upper_deck_bottom_z   = lower_deck_top_z + standoff_height;    // 47.0mm
upper_deck_top_z      = upper_deck_bottom_z + acrylic_thickness;// 50.0mm

// 轮距与电机横向位置推导:
// 中心电池盒半宽 + 内伸轴安全间隙(9.5mm) + 1812-N20电机宽(12mm)
motor_inner_y         = (battery_holder_width / 2.0) + 9.5;    // 20.5 + 9.5 = 30.0mm
motor_outer_y         = motor_inner_y + n20_motor_width;       // 30.0 + 12.0 = 42.0mm
wheel_well_inner_y    = 46.0;                                  // 下层底盘轮槽内壁 Y = ±46.0mm
wheel_inner_y         = 49.0;                                  // 车轮内侧面 Y = ±49.0mm (留3mm间隙)
track_width           = 2.0 * (wheel_inner_y + wheel_hub_width / 2.0); // 107.5mm

// 轴距推导 (匹配 1812-N20 蜗轮自锁滑移转向最佳比例 ~0.84 * track_width):
wheelbase             = 90.0;                                  // 前后轴距 90.0mm
front_axle_x          = wheelbase / 2.0;                       // +45.0mm
rear_axle_x           = -wheelbase / 2.0;                      // -45.0mm

// 下层底盘与乐高外壳模数对齐推导 (向上取整至 8.0mm Stud 偶数倍):
chassis_studs_l       = 20;                                    // 20 Studs = 160.0mm
chassis_studs_w       = 16;                                    // 16 Studs = 128.0mm
chassis_length        = chassis_studs_l * lego_stud_pitch;     // 160.0mm
chassis_width         = chassis_studs_w * lego_stud_pitch;     // 128.0mm

// 上层电子安装板尺寸 (留出四周乐高墙体厚度 2 Studs = 16mm):
upper_deck_length     = 136.0;                                 // 17 Studs = 136.0mm
upper_deck_width      = 96.0;                                  // 12 Studs = 96.0mm

// 乐高车体高度推导 (保证完全包覆上层 L298N Z_top=77mm 与 OLED Z_top=90mm):
lego_wall_bricks_h    = 9;                                     // 9层标准砖高 = 86.4mm
lego_roof_top_z       = lower_deck_top_z + lego_wall_bricks_h * lego_brick_height + 4 * lego_plate_height; // 111.2mm
chassis_height        = lego_roof_top_z;                       // 整车总高 111.2mm

// 车轮避让切口尺寸
wheel_cutout_len      = 46.0;                                  // X方向 [22.0, 68.0]mm
wheel_cutout_depth    = (chassis_width / 2.0) - wheel_well_inner_y; // 64 - 46 = 18.0mm

// ----------------------------------------------------------------------------
// 6. 自动空间冲突断言检查 (AUTOMATIC COLLISION ASSERTIONS)
// ----------------------------------------------------------------------------
// (1) 检查同侧前后两台 1812-N20 电机尾端是否纵向碰撞
motor_tail_gap_x = wheelbase - 2 * (n20_motor_length - n20_shaft_offset_x + n20_wire_bend_margin);
assert(motor_tail_gap_x >= 10.0,
    str("COLLISION ERROR: 前后 1812-N20 电机尾端纵向间距不足! 当前间距=", motor_tail_gap_x, "mm"));

// (2) 检查 1812-N20 内侧双出长轴是否顶撞中心 18650 电池盒
shaft_to_battery_gap_y = (motor_inner_y - n20_shaft_in_len) - (battery_holder_width / 2.0);
assert(shaft_to_battery_gap_y >= 1.0,
    str("COLLISION ERROR: 1812-N20 内伸轴与 18650 电池盒发生干涉! 净距=", shaft_to_battery_gap_y, "mm"));

// (3) 检查 18650 电池盒顶部与上层亚克力电子板底面净空
battery_top_clearance_z = upper_deck_bottom_z - (lower_deck_top_z + battery_holder_height);
assert(battery_top_clearance_z >= 8.0,
    str("COLLISION ERROR: 电池盒顶面与上层电子板净空不足! 净距=", battery_top_clearance_z, "mm"));

// (4) 检查上层两块 L298N 横向并排是否超出上层板宽度
l298n_pair_width = 2 * l298n_width + 6.0;
assert(l298n_pair_width <= upper_deck_width,
    str("COLLISION ERROR: 两块 L298N 并排总宽超出上层电子板宽度!"));

// (5) 检查上下两层亚克力板是否能从已购的 1 张 200x300mm 亚克力板中裁出
assert((chassis_length + upper_deck_length + 4.0 <= 300.0) && (chassis_width <= 200.0),
    "NESTING ERROR: 上下层底盘超出已购 200x300mm 亚克力板尺寸范围!");
