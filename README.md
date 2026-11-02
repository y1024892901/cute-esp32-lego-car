# 可爱乐高积木风格 ESP32 四轮智能机器人（Q版马卡龙小面包车）— 完整工程设计

> **项目工程状态**：`PARAMETRIC_DRAFT_PENDING_MEASUREMENT`（参数化工程设计完成，包含 9 项 `MEASURE_REQUIRED` 待实测关键尺寸，**严禁在未完成实物卡尺复核前直接作为不可调死尺寸投产**）

---

## 一、`订单数据.xlsx` 深度审查结论与发现的 7 大核心工程问题

通过对工作区中 `订单数据.xlsx`（共 40 行交易记录）的逐行核查，发现以下直接决定机械结构、电气安全与装配可行性的关键问题：

| 序号 | 订单行号 | 涉及硬件 / 订单信息 | 核心问题诊断 | 工程解决方案（已纳入本设计） |
| :--- | :--- | :--- | :--- | :--- |
| **1** | Row 38 | `1812-N20微型直流减速电机蜗轮蜗杆自锁双轴加长轴`（`6V-190转：速比42;长轴;带支架` ×4） | **并非普通同轴直出 N20**！1812-N20 为 **T型/L型 90°垂直输出轴蜗轮蜗杆电机**，且具有**断电自锁**特性与**加长/双出轴**。若按普通 N20 横向对顶设计，电机根本无法安装；且若轴距过大，蜗轮自锁会导致差速转向卡死。 | 改用**电机机身纵向布置、输出轴横向伸出**结构；将前后轴距压缩至 `90mm`（轮距 `107.5mm`，轴距/轮距比 `0.84`），并在电池仓两侧预留 `9.5mm` 内侧出轴安全间隙。 |
| **2** | Row 14 / 11 / 36 / 37 | `TP4056 单节充电板` ×2、`2串升压充电紫板` ×1、`18650平头电池` ×2、`0.53元2节串联电池盒` ×1 | **严重电气安全隐患**：① `TP4056` 是单节 4.2V 充电器，**严禁用于 2S（8.4V）串联锂电充电**（共地即短路起火）；② **18650 平头裸电芯无保护板**，装入廉价弹片盒极易正极接触不良且无过放/短路保护。 | ① 禁用 TP4056；② 推荐将廉价电池盒升级为**带铜柱触点/强力弹簧的 2S 18650 电池盒 + 2S 8A BMS 锂电保护板 + 自恢复保险丝**，或使用平头转尖头强磁吸片，支持“盒充（2S 紫板 Type-C）”与“拆电芯座充（订单赠品）”双模式。 |
| **3** | Row 10 / 20 | `LM2596S 降压模块` ×1 + `L298N 电机驱动` ×2 | **压降失配陷阱**：2S 电池电压为 `6.0V~8.4V`。LM2596S 压差需 `>1.5V`，无法在全放电周期稳定输出 6V；且 L298N 内部达林顿管压降高达 `1.8V~2.5V`，若输入 6V 则电机仅得 `3.8V`。 | **修正供电拓扑**：2S 电池（`7.4V~8.4V`）经保险丝与总开关后**直接供给 L298N 的 `12V/VMS` 端**（扣除 L298N 压降后电机实得 `5.4V~6.4V`）；**LM2596S 调定为 `5.0V` 稳压输出**，专供 ESP32、SU-03T 语音模块与超声波传感器。 |
| **4** | Row 12 / 13 / 24 | `ESP32-WROOM-32E (已焊排针)`（损坏待重购）、Row 13 `ESP-32S`（交易关闭）、`ESP32-C3`（损坏） | 原主控板损坏需重购；且现有订单仅买了 `10cm 杜邦线`（Row 25），**长度过短且未购买螺丝端子扩展板**，直接插排针极易在震动中脱落。 | 重购 `ESP32-WROOM-32E (38Pin Type-C 已焊排针)` 时**配套采购 38Pin 螺丝端子扩展底板**（自带 4 个 M3 安装孔与电源端子），实现全车核心信号免焊锁紧。 |
| **5** | Row 39 | `SS12D00G2 卧式两档拨动开关（柄高2mm）` | 该微型 PCB 拨动开关额定电流仅 `0.3A~0.5A`，且柄高仅 `2mm`，**绝对不能承受 4 台 N20 电机峰值 `3A~4A` 总电流**，也无法穿透车壳操作。 | 主电源回路改用 **KCD11 船型开关（6A/250V）** 配合已购的 `XT60PB` 插头（Row 28/29）及 `20AWG 硅胶线`（Row 34/35）。 |
| **6** | Row 01 / 30 | `INMP441 I2S数字麦克风` ×1 + `SU-03T 离线语音模块（含喇叭+咪头）` ×1 | 存在**两套独立拾音器件**：SU-03T 自带驻极体模拟咪头与 8Ω 腔体喇叭；INMP441 为供 ESP32 采集的 I2S 数字麦克风（底部进音孔）。 | 车头左腮红装饰砖设 **INMP441 拾音孔**，右腮红装饰砖设 **SU-03T 驻极体咪头拾音孔**，车顶及侧面格栅砖设 **SU-03T 喇叭出音孔**。 |
| **7** | Row 02 / 32 / 33 | 仅购 `20×30cm 3mm 亚克力板` 1 块、`勾刀`、`亚克力胶水`、`热熔胶枪` | **订单中未购买任何 M2/M2.5/M3 螺丝、螺母与六角铜柱**！若用胶水粘死电路板，将彻底丧失可维护性。 | 双层底盘尺寸设计为**下层 `160×128mm` + 上层 `136×96mm`**，可从现有的 **1 张 `200×300mm` 亚克力板中全部直线裁切获得**（兼容手用勾刀直线裁切或激光切割），并在采购清单中补齐 M3/M2.5 铜柱紧固件包。 |

---

## 二、整车核心工程参数总览（自下而上由内部硬件推导）

| 参数分类 | 参数代号 | 工程设计值 | 推导依据与物理约束 |
| :--- | :--- | :--- | :--- |
| **车轮直径 / 宽度** | `wheel_diameter` / `wheel_width` | `34.0 mm` / `7.0 mm`（轮毂含码盘厚 `9.5 mm`） | 订单 Row 18/23 确认 `ZJ327 34*7` 橡胶轮 |
| **前后轴距** | `wheelbase` | **`90.0 mm`**（前轴 `X=+45mm`，后轴 `X=-45mm`） | 匹配 1812-N20 蜗轮自锁特性，轴距/轮距比 `0.84`，保证差速滑移转向顺畅且前后电机尾端留有 `26mm` 间距 |
| **左右轮距** | `track_width` | **`107.5 mm`**（轮胎中心距） | 中置 18650 电池盒宽 `41mm` + 两侧内轴间隙 `2×9.5mm` + 两侧 1812-N20 齿轮箱 `2×12mm` + 轮毂间隙 |
| **离地间隙 / 轴心高** | `ground_clearance` / `axle_z` | **`9.0 mm`** / **`17.0 mm`** | 下层 3mm 亚克力板位于 `Z=9~12mm`；1812-N20 电机直接平装于板面（轴高 `5mm`），`12+5=17mm` 恰好等于 `34mm` 车轮半径 |
| **下层主底盘尺寸** | `chassis_length × width` | **`160.0 mm × 128.0 mm × 3.0 mm`** | 精确对应乐高 **20 Studs × 16 Studs** 模数（`20×8=160mm`, `16×8=128mm`），四角留直线轮槽 `46×18mm` |
| **上层电子安装板** | `upper_deck_l × w` | **`136.0 mm × 96.0 mm × 3.0 mm`** | 通过 6 根 `M3×35mm` 铜柱架设于 `Z=47~50mm`，与下层板共用同一张 `200×300mm` 已购亚克力板裁切 |
| **乐高车壳外包络** | `lego_body_l × w × h` | **`176.0 mm × 128.0 mm × 111.2 mm`** | 主车体 `20×16 Studs`，含前后奶白色保险杠共 `22 Studs (176mm)`，车顶快拆盖仅靠 4 个定位凸粒固定 |

---

## 三、项目文件结构与交付物导航

- **工程文档 (`docs/`)**
  - [hardware-inventory.md](file:///d:/car/cute-esp32-lego-car/docs/hardware-inventory.md) — 订单 40 行完整解析、库存状态与可用硬件盘点
  - [measured-dimensions.md](file:///d:/car/cute-esp32-lego-car/docs/measured-dimensions.md) — 全硬件三维包络尺寸数据库与来源分级（`VERIFIED_DATASHEET` / `SELLER_SPEC` / `MEASURE_REQUIRED`）
  - [measurement-checklist.md](file:///d:/car/cute-esp32-lego-car/docs/measurement-checklist.md) — 9 项必测关键尺寸卡尺实测指南与参数回填方法
  - [chassis-design.md](file:///d:/car/cute-esp32-lego-car/docs/chassis-design.md) — 三种底盘架构方案量化对比、1812-N20 电机布局与直线勾刀/激光加工图纸说明
  - [battery-compartment.md](file:///d:/car/cute-esp32-lego-car/docs/battery-compartment.md) — 中置底层 2S 18650 电池仓结构设计、平头电芯防松措施与充放电保护规范
  - [collision-check.md](file:///d:/car/cute-esp32-lego-car/docs/collision-check.md) — 全车三维坐标包络表与 12 项机械干涉/拔插空间校验矩阵
  - [wiring-and-power.md](file:///d:/car/cute-esp32-lego-car/docs/wiring-and-power.md) — 双路供电拓扑（电机直驱 + LM2596S 5V 稳压）、ESP32 引脚分配表與免焊端子接线图
  - [assembly-guide.md](file:///d:/car/cute-esp32-lego-car/docs/assembly-guide.md) — 从底盘裁切、电机调向、电子层装调到乐高外壳拼装与快拆车顶的 8 步装配手册
  - [validation-report.md](file:///d:/car/cute-esp32-lego-car/docs/validation-report.md) — 11 项工程验收检查表与当前设计状态声明
- **参数化 CAD 模型 (`cad/`)**
  - [parameters.scad](file:///d:/car/cute-esp32-lego-car/cad/parameters.scad) — 统一参数化尺寸库与自动干涉断言（`assert` 冲突报警）
  - [components.scad](file:///d:/car/cute-esp32-lego-car/cad/components.scad) — 1812-N20 电机、34mm 车轮、L298N、ESP32 扩展板、HC-SR04、OLED、SU-03T、INMP441 真实包络模型
  - [battery-holder.scad](file:///d:/car/cute-esp32-lego-car/cad/battery-holder.scad) — 2S 18650 电池仓、防滑限位框、BMS 与主开关组件
  - [chassis.scad](file:///d:/car/cute-esp32-lego-car/cad/chassis.scad) — 上下双层亚克力底盘 + 乐高科技梁混合转接骨架模型
  - [electronic-layout.scad](file:///d:/car/cute-esp32-lego-car/cad/electronic-layout.scad) — 上下层全电子模块与走线通道三维排布
  - [lego-body.scad](file:///d:/car/cute-esp32-lego-car/cad/lego-body.scad) — 奶油黄+薄荷绿+奶白保险杠+粉色腮红 Q 版乐高外壳与快拆车顶
  - [complete-car.scad](file:///d:/car/cute-esp32-lego-car/cad/complete-car.scad) — 整车总装与爆炸视图主控文件
- **乐高模型与采购清单 (`lego/` & 根目录)**
  - [parts-bom.csv](file:///d:/car/cute-esp32-lego-car/lego/parts-bom.csv) — 标准乐高/高砖（Gobricks）兼容零件 BOM 清单
  - [car-model.ldr](file:///d:/car/cute-esp32-lego-car/lego/car-model.ldr) — 标准 LDraw 积木模型文件（可直接用 BrickLink Studio / LDView 打开）
  - [purchase-list.csv](file:///d:/car/cute-esp32-lego-car/purchase-list.csv) — 损坏件重购、紧固件补齐、电池安全升级与积木汇总采购表
- **工程可视化视图 (`renders/`)**
  - [front.png](file:///d:/car/cute-esp32-lego-car/renders/front.png) | [side.png](file:///d:/car/cute-esp32-lego-car/renders/side.png) | [top.png](file:///d:/car/cute-esp32-lego-car/renders/top.png) | [chassis.png](file:///d:/car/cute-esp32-lego-car/renders/chassis.png) | [internal.png](file:///d:/car/cute-esp32-lego-car/renders/internal.png) | [exploded.png](file:///d:/car/cute-esp32-lego-car/renders/exploded.png)
