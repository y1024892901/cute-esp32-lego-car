// ============================================================================
// cute-esp32-lego-car / cad / cyber-print / cyber_parameters.scad
// 拓竹 A1 3D打印机赛博黑透战术探索版参数化核心尺寸库 (单位: mm)
// ============================================================================

$fn = 36;

// 1. 机电驱动与车轮参数 (基于订单 Row 18/23/38 实物核算)
wheel_diameter       = 34.0;  // ZJ327 橡胶轮外径 34.0mm
wheel_tire_width     = 7.0;   // 胎面宽 7.0mm
wheel_hub_width      = 9.5;   // 轮毂总厚 9.5mm (含内侧码盘凸台)
wheel_axle_dia       = 3.0;   // 3mm D型轴
wheel_axle_z         = 17.0;  // 轮轴中心距地高 17.0mm (= 34/2 完美同心)
ground_clearance     = 9.0;   // 底盘最低离地间隙 9.0mm

// 1812-N20 蜗轮蜗杆减速电机 (6V 190RPM 速比42 纵向安装)
n20_gearbox_l        = 18.0;  // 1812 蜗轮箱长
n20_motor_l          = 15.0;  // 电机筒长
n20_total_l          = 33.0;  // 电机总长
n20_width            = 12.0;  // 机身宽
n20_height           = 10.0;  // 机身高
n20_shaft_offset_x   = 6.0;   // 轴距齿轮箱前缘距离

// 2. 关键几何布局 (针对蜗轮自锁差速转向优化)
wheelbase            = 90.0;  // 前后轴距 90.0mm (前轴 +45mm, 后轴 -45mm)
track_width          = 107.5; // 左右轮胎中心距 107.5mm
ratio_wb_tw          = wheelbase / track_width; // 0.837 差速转向黄金比

// 3. 2S 18650 电池仓与电子托盘
bat_bay_l            = 76.0;  // 电池仓净内长
bat_bay_w            = 41.0;  // 电池仓净内宽
bat_bay_h            = 16.0;  // 电池仓槽深

// 4. 电子板安装孔距
esp32_hole_x         = 60.0;  // 38Pin 扩展板长向孔距
esp32_hole_y         = 47.0;  // 38Pin 扩展板宽向孔距
l298n_hole_pitch     = 37.0;  // L298N 驱动板 37x37mm 标准孔距
lm2596_hole_dist     = 31.0;  // LM2596S 对角孔距

// 5. 3D 打印配合与公差设计 (拓竹 A1 级精度)
m3_heatset_hole_dia  = 4.0;   // M3 热熔铜螺母预留底孔 Ø4.0mm
m3_pass_hole_dia     = 3.4;   // M3 穿钉过孔 Ø3.4mm
magnet_dia           = 4.2;   // Ø4x2mm 磁铁嵌入槽孔径
magnet_depth         = 2.2;   // 磁铁沉槽深度
min_wall_thickness   = 2.0;   // 结构外壁最小厚度
chamfer_angle        = 45.0;  // 45° 无支撑自支撑斜角
