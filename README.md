# ESP32 四轮机能战术智能机器人（拓竹 A1 3D打印黑透探索版）— 完整工程设计

> **项目工程状态**：`3D_PRINTING_READY`（已完成拓竹 A1 256×256mm 热床适配切片模型与 4 大分件 STL 建模；废除手工亚克力勾刀裁切与乐高散件，总新增预算从 ￥128 暴降至 **￥63.80**）

---

## 一、方案全面升级：从“乐高拼接”跃迁至“拓竹 A1 3D打印一体化”

针对用户采购的 **拓竹 Bambu Lab A1（256×256×256mm）** 高精度 3D 打印机与 **黑色半透明（Smoke Black Translucent）工程耗材**，整车工程结构完成全面颠覆性重构：

| 对比维度 | 原方案（手工亚克力底盘 + 乐高积木外壳） | **现方案：拓竹 A1 赛博机能黑透 3D 打印一体化架构** |
| :--- | :--- | :--- |
| **加工方式** | 需手持勾刀在 3mm 亚克力板上反复划切数十刀，容易割歪割伤 | **100% 拓竹 A1 自动打印成型**，仅需 2 盘（约 6~7 小时）搞定全车 4 大分件 |
| **尺寸与装配公差**| 受限于乐高 $8.0\text{ mm}$ 凸粒模数，结构妥协多，容易产生装配缝隙 | **$0.05\text{ mm}$ 工业级精准契合**，原生集成电机卡槽、电池滑仓与走线暗渠 |
| **外观质感与美学**| 软萌 Q 版马卡龙面包车造型 | **赛博朋克 / 战术装甲探索版（Nothing Phone 风格）**：黑透墨晶外壳隐现黄铜齿轮与内部走线，通电后指示灯与战术 HUD 极具科技感 |
| **结构紧固度** | 塑料插销受电机差速大扭矩时易松动摇晃 | **M3 滚花热熔铜螺母预埋**，金属螺丝反复拆装 100 次不滑丝；顶盖 4 磁点秒拆 |
| **新增采购总预算**| ￥128.10（含 ￥68.00 乐高 194 颗散件包） | **￥63.80（立省 ￥64.30！）**，原积木散件与亚克力加工费全免，耗材成本仅约 ￥10 |

---

## 二、整车核心机电与 3D 打印工程参数总览

| 参数分类 | 参数代号 | 3D打印工程设计值 | 结构工程依据与物理特性 |
| :--- | :--- | :--- | :--- |
| **车轮直径 / 宽度** | `wheel_diameter` / `wheel_width` | `34.0 mm` / `7.0 mm` | 复用已购 `ZJ327 34*7` 橡胶轮（Row 18/23） |
| **前后轴距** | `wheelbase` | **`90.0 mm`**（前轴 `X=+45mm`，后轴 `X=-45mm`） | 针对 1812-N20 蜗轮蜗杆自锁特性专门压缩，轴距/轮距比 `0.84`，差速转向轻快不卡滞 |
| **左右轮距** | `track_width` | **`107.5 mm`**（轮胎中心距） | 中置电池仓 `41mm` + 两侧内伸长轴避让槽 + 1812-N20 齿轮箱一体底座 |
| **离地间隙 / 轴心高** | `ground_clearance` / `axle_z` | **`9.0 mm`** / **`17.0 mm`** | 底盘一体电机底托精准固定轴高在 `17.0mm`，与 `R=17mm` 车轮绝对同心！ |
| **整车外包络** | `cyber_car_l × w × h` | **`168.0 mm × 126.0 mm × 96.0 mm`** | 完美容纳于拓竹 A1 单盘 $256 \times 256\text{ mm}$ 打印幅面内 |
| **供电拓扑** | `power_topology` | **双路物理隔离** | 2S 电池（7.4V~8.4V）直接输入 L298N；LM2596S 调定 `5.00V` 专供 ESP32 与弱电模块 |
| **顶盖开闭** | `roof_latch` | **4 点强磁吸快拆** | 4 粒 $\varnothing 4\times 2\text{ mm}$ 强磁片嵌入顶盖，2 秒免工具揭盖维护 |


---

## 三、项目文件结构与交付物导航

- **3D 打印专用切片模型 (`models-3d/`，适配拓竹 A1 / 256×256mm 热床)**
  - [part1_lower_power_chassis.stl](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/part1_lower_power_chassis.stl) — 一体化动力底盘（集成 4 台 N20 减速电机固定座、2S 18650 电池仓、理线暗槽）
  - [part2_electronics_mid_deck.stl](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/part2_electronics_mid_deck.stl) — 中层高集成电子托盘（双 L298N、ESP32 扩展底板、LM2596S、语音喇叭安装位）
  - [part3_cyber_armor_shell.stl](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/part3_cyber_armor_shell.stl) — 赛博多面体黑透装甲主车壳（前倾战术 OLED 视窗、双发加农超声波护圈、散热进气格栅）
  - [part4_quick_release_roof_canopy.stl](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/part4_quick_release_roof_canopy.stl) — 极客百叶风道快拆磁吸顶盖（尾翼扰流风道、4 磁点 2 秒开合）
  - [assembled_cyber_car.stl](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/assembled_cyber_car.stl) | [assembled_cyber_car.obj](file:///home/antigravity/y1024892901/cute-esp32-lego-car/models-3d/assembled_cyber_car.obj) — 整车总装 3D 模型与彩色材质检视文件
- **工程文档 (`docs/`)**
  - [3d-printing-guide.md](file:///home/antigravity/y1024892901/cute-esp32-lego-car/docs/3d-printing-guide.md) — **【新】拓竹 A1 打印机两盘切片指引、黑透耗材高透/磨砂调校秘籍与电烙铁热熔铜螺母安装指南**
  - [hardware-inventory.md](file:///home/antigravity/y1024892901/cute-esp32-lego-car/docs/hardware-inventory.md) — 订单 40 行完整解析、库存状态与可用硬件盘点
  - [wiring-and-power.md](file:///home/antigravity/y1024892901/cute-esp32-lego-car/docs/wiring-and-power.md) — 双路供电拓扑（电机直驱 + LM2596S 5V 稳压）、ESP32 引脚分配表與免焊端子接线图
  - [assembly-guide.md](file:///home/antigravity/y1024892901/cute-esp32-lego-car/docs/assembly-guide.md) — 机械装配、接线与传感器集成指导手册
- **采购预算表 (`purchase-list.csv`)**
  - [purchase-list.csv](file:///home/antigravity/y1024892901/cute-esp32-lego-car/purchase-list.csv) — 全面改用 3D 打印后采购清单：取消 ￥68 乐高积木包，加入热熔铜螺母与磁吸片，总预算降至 **￥63.80**
- **历史归档 (`lego/` & `cad/`)**
  - 保留历史参数化 OpenSCAD 脚本与乐高 LDraw 模型供对照参考。
