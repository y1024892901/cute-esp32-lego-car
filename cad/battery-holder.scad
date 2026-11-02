// ============================================================================
// cute-esp32-lego-car / cad / battery-holder.scad
// 中置底层 2S 18650 核心电池仓、平头电芯防振限位框、2S BMS 与安全总开关组件
// ============================================================================

include <parameters.scad>

module battery_compartment_assembly() {
    // 1. 18650 双节串联黑色电池盒本体 (76 x 41 x 21 mm, 居中位于 Z=12.0mm)
    color([0.16, 0.16, 0.18])
    translate([-battery_holder_length/2, -battery_holder_width/2, 0])
    difference() {
        cube([battery_holder_length, battery_holder_width, battery_holder_height]);
        // 内部两槽挖空
        translate([2.5, 2.0, 2.5])
            cube([battery_holder_length - 5.0, (battery_holder_width - 5.0)/2, battery_holder_height]);
        translate([2.5, battery_holder_width/2 + 0.5, 2.5])
            cube([battery_holder_length - 5.0, (battery_holder_width - 5.0)/2, battery_holder_height]);
        // 底部 M3 沉头安装孔
        for (hx = [-battery_box_hole_dist/2, battery_box_hole_dist/2])
            translate([battery_holder_length/2 + hx, battery_holder_width/2, -0.5])
                cylinder(d = 3.2, h = 4.0);
    }

    // 2. 两节 18650 平头锂离子电芯 (Ø18.4 x 65.2 mm) + 正极强磁吸接触垫片
    for (cy = [-10.0, 10.0]) {
        color([0.18, 0.45, 0.82])
        translate([-32.6, cy, 11.5])
        rotate([0, 90, 0])
            cylinder(d = 18.4, h = 65.2);
        // 平头正极导电增强磁吸帽 (Ø6 x 1.5 mm)
        color([0.85, 0.85, 0.88])
        translate([32.6, cy, 11.5])
        rotate([0, 90, 0])
            cylinder(d = 6.0, h = 1.5);
    }

    // 3. 两侧 3mm 亚克力防滑限位护条 (兼作 1812-N20 内伸轴物理防撞隔离墙)
    color([0.85, 0.92, 0.98, 0.65])
    for (sy = [-1, 1]) {
        translate([-battery_holder_length/2,
                   sy * (battery_holder_width/2 + 0.5) - (sy < 0 ? 3.0 : 0),
                   0])
            cube([battery_holder_length, 3.0, 8.0]);
    }

    // 4. 20mm 宽防振魔术贴环抱绑带
    color([0.22, 0.22, 0.25, 0.85])
    translate([-10.0, -battery_holder_width/2 - 1.0, battery_holder_height - 1.5])
        cube([20.0, battery_holder_width + 2.0, 2.0]);

    // 5. 后置 2S 8A BMS 锂电均衡保护板 (位于电池盒后方 X = -48mm)
    color([0.10, 0.52, 0.25])
    translate([-battery_holder_length/2 - 14.0, -bms_2s_length/2, 0])
        cube([bms_2s_width, bms_2s_length, bms_2s_height]);

    // 6. 2串升压快充模块_紫板 (Row 11, Type-C 朝向车尾充电窗)
    color([0.48, 0.18, 0.62])
    translate([-chassis_length/2 + 8.0, 8.0, 0])
        cube([charger_2s_length, charger_2s_width, charger_2s_height]);

    // 7. XT60PB-F/M 电源总断开插头 (Row 28/29) + KCD11 船型总开关 + 5A 保险丝座
    color([0.95, 0.72, 0.08])
    translate([-battery_holder_length/2 - 16.0, -28.0, 0])
        cube([16.0, 16.0, 8.5]);
    // KCD11 船型总开关 (车尾右侧)
    color([0.85, 0.15, 0.15])
    translate([-chassis_length/2 + 6.0, -28.0, 4.0])
        cube([15.0, 10.5, 13.5]);
}

// 单独预览时显示电池仓总成
translate([0, 0, lower_deck_top_z])
    battery_compartment_assembly();
