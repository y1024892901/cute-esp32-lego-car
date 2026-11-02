# 待实测关键尺寸清单（Measurement Checklist）

> **重要工程声明**：
> 虽然我们已根据商品型号提取了 `SELLER_SPEC` 与工业标准图纸数据，但淘宝散件（尤其是 **1812-N20 蜗轮蜗杆电机的双出加长轴与配套支架**、**0.53元 18650 电池盒底孔**、**SU-03T 附赠喇叭**）在不同批次间存在 `1~4mm` 的公差。
> 请在正式打孔/切割底盘前，使用 **游标卡尺（或钢直尺）** 完成以下 **9 项关键尺寸实测**，并将实测数值填入 [`cad/parameters.scad`](file:///d:/car/cute-esp32-lego-car/cad/parameters.scad) 对应变量中。

---

## 一、9 项必测关键尺寸核对表

| 编号 | 测量对象（对应订单行） | 具体测量位置说明（游标卡尺量法） | 当前占位参数值 | 对应 `parameters.scad` 变量名 | 若实测值偏离的影响与自动调整机制 |
| :---: | :--- | :--- | :---: | :--- | :--- |
| **CHK-01** | **1812-N20 电机输出轴外侧与内侧伸出长度**（Row 38） | 测量从 `1812` 齿轮箱侧面（`18×10mm` 面）到 D 型轴末端的垂直伸出长度：<br>① 装车轮一侧外伸长度 $L_{\text{out}}$；<br>② 若为双出轴，测量朝向车内侧伸出长度 $L_{\text{in}}$。 | 外伸 `10.0 mm`<br>内伸 `8.0 mm` | `n20_shaft_out_len`<br>`n20_shaft_in_len` | 若内伸轴 $>9.5\text{ mm}$，`parameters.scad` 中的 `assert` 会自动报警，提示将电池盒微调抬高或加垫片，防止内侧转轴刮擦电池盒外壁。 |
| **CHK-02** | **1812-N20 配套安装支架孔距与孔径**（Row 38） | 测量随电机附带的金属/塑料支架：<br>① 底座安装孔的中心距 $P_{\text{bracket}}$；<br>② 安装孔直径 $D_{\text{hole}}$；<br>③ 装上支架后电机轴心距底板表面的高度 $H_{\text{axle}}$。 | 孔距 `18.0 mm`<br>孔径 `2.6 mm`<br>轴高 `5.5 mm` | `n20_bracket_hole_dist`<br>`n20_bracket_hole_dia`<br>`n20_axle_height_from_base` | 直接决定下层亚克力底盘上 4 组电机安装孔的打孔坐标，防止打孔后支架装不上。 |
| **CHK-03** | **ZJ327 34mm 橡胶轮轮毂总厚度与 D 孔深度**（Row 18/23） | ① 卡尺夹住车轮外侧面与内侧码盘凸台端面，测总厚 $W_{\text{hub}}$；<br>② 用卡尺深度杆测量中心 3mm D 型孔的有效插入深度 $D_{\text{bore}}$。 | 轮毂厚 `9.5 mm`<br>孔深 `8.5 mm` | `wheel_hub_width`<br>`wheel_bore_depth` | 决定车轮内侧面与亚克力底盘侧边的防擦间隙（要求 $\ge 2.5\text{ mm}$）以及是否需要在轴根部加装 M3 尼龙限位垫圈。 |
| **CHK-04** | **18650 双节串联电池盒外部长宽高及底孔间距**（Row 36） | ① 装入 2 节 18650 平头电池后，测量电池盒最大外长 $L_{\text{bat}}$、外宽 $W_{\text{bat}}$、外高 $H_{\text{bat}}$；<br>② 测量盒底两个固定通孔的中心距。 | `76.0 × 41.0 × 21.0 mm`<br>底孔距 `35.0 mm` | `battery_box_length`<br>`battery_box_width`<br>`battery_box_height`<br>`battery_box_hole_dist` | 决定下层底盘中心电池仓限位框尺寸与 M3 沉头螺丝孔位；同时请手摇测试平头电池在盒内是否松动断电。 |
| **CHK-05** | **新购 ESP32-WROOM-32E 及螺丝端子扩展板尺寸**（Row 12 重购件） | 收到重购的 ESP32 及配套扩展底板后：<br>① 测量扩展底板长×宽；<br>② 测量四角固定孔中心距（长向×宽向）；<br>③ 测量核心板插上扩展板后的总高度。 | 板尺寸 `66.0 × 53.0 mm`<br>孔距 `60.0 × 47.0 mm`<br>叠高 `25.0 mm` | `esp32_exp_length`<br>`esp32_exp_width`<br>`esp32_exp_hole_x`<br>`esp32_exp_hole_y`<br>`esp32_total_height` | 决定上层电子安装板前部 4 个 M3 铜柱孔位及车顶盖内部净空余量。 |
| **CHK-06** | **SU-03T 附赠腔体小喇叭与驻极体咪头外形**（Row 30） | ① 测量黑色小喇叭的长×宽×厚（或直径×厚）；<br>② 测量驻极体咪头圆柱直径与高度。 | 喇叭 `30.0 × 20.0 × 6.5 mm`<br>咪头 `Ø9.7 × 6.7 mm` | `speaker_length`<br>`speaker_width`<br>`speaker_height`<br>`su03t_mic_dia` | 决定上层板后部喇叭卡位尺寸，以及车头右侧粉色腮红积木内壁咪头固定座孔径。 |
| **CHK-07** | **0.96 寸 OLED 模块 PCB 尺寸、孔距与排针焊接朝向**（Row 19） | ① 测量蓝色 OLED 模块 PCB 宽×高及四角小孔中心距；<br>② 确认已焊好的 4Pin 排针是**向屏幕背面伸出**还是**向屏幕正面伸出**。 | PCB `27.3 × 27.8 mm`<br>孔距 `23.0 × 23.5 mm`<br>排针向后 | `oled_width`<br>`oled_height`<br>`oled_hole_x`<br>`oled_hole_y` | 若排针焊在正面，需在车头挡风窗内侧增加 `6mm` 退让垫柱，否则排针会顶住乐高透明窗片。 |
| **CHK-08** | **INMP441 麦克风模块外径与已焊排针方向**（Row 01） | 观察 Row 01 已焊好排针的 INMP441：确认排针是焊在**带金属屏蔽壳一面**（正确，方便平底进音孔贴车壳），还是焊在**带小圆孔的平底面**。 | 外径 `14.0 mm`<br>排针在金属壳侧 | `inmp441_dia`<br>`inmp441_height` | 若卖家将排针焊在了平底进音孔一侧，需使用侧装卡槽或重新调整排针方向，确保进音小孔无遮挡对准车头左腮红孔。 |
| **CHK-09** | **L298N 散热片顶部高度与电容最高点**（Row 20） | 测量从 L298N PCB 底面（含焊点尖端）到黑色散热片或电解电容顶部的最大高度。 | `27.0 mm` | `l298n_total_height` | 验证上层电子板（`Z=50mm`）到乐高车顶横梁下缘（`Z=88.8mm`）之间的 `38.8mm` 净空是否留有 `>10mm` 散热与接线安全余量。 |

---

## 二、实测后如何一键更新全套 CAD 模型？

1. 打开 [`cad/parameters.scad`](file:///d:/car/cute-esp32-lego-car/cad/parameters.scad)。
2. 在文件顶部的 `/* [1. 实测硬件参数区 (MEASURED HARDWARE OVERRIDES)] */` 中修改上述 9 个变量。
3. 将状态标志 `DIMENSIONS_VERIFIED_BY_CALIPER = false;` 改为 `true;`。
4. 使用 OpenSCAD 打开 [`cad/complete-car.scad`](file:///d:/car/cute-esp32-lego-car/cad/complete-car.scad) 按 `F5`/`F6` 预览：
   - 若修改后的尺寸导致任何两个部件间距小于安全阈值（`< 1.5 mm`），OpenSCAD 控制台将立即输出红色 `ERROR: Assertion failed` 并指出具体冲突部位；
   - 若全部断言通过，底盘孔位与支架将自动跟随新参数重算生成。
