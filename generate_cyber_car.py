import math
import struct
import os

class Mesh3D:
    def __init__(self):
        self.vertices = []
        self.faces = [] # (v0, v1, v2, mat_name)
        self.materials = {}
        self.cur_mat = "default"

    def add_mat(self, name, r, g, b, alpha=1.0):
        self.materials[name] = (r, g, b, alpha)

    def set_mat(self, name):
        self.cur_mat = name

    def add_v(self, x, y, z):
        self.vertices.append((float(x), float(y), float(z)))
        return len(self.vertices)

    def add_tri(self, v0, v1, v2):
        self.faces.append((v0, v1, v2, self.cur_mat))

    def add_quad(self, v0, v1, v2, v3):
        self.add_tri(v0, v1, v2)
        self.add_tri(v0, v2, v3)

    def add_box(self, x0, y0, z0, dx, dy, dz):
        v = [
            self.add_v(x0, y0, z0),          # 0: ---
            self.add_v(x0+dx, y0, z0),       # 1: +--
            self.add_v(x0+dx, y0+dy, z0),    # 2: ++-
            self.add_v(x0, y0+dy, z0),       # 3: -+-
            self.add_v(x0, y0, z0+dz),       # 4: --+
            self.add_v(x0+dx, y0, z0+dz),    # 5: +-+
            self.add_v(x0+dx, y0+dy, z0+dz), # 6: +++
            self.add_v(x0, y0+dy, z0+dz),    # 7: -++
        ]
        # Bottom (-Z)
        self.add_tri(v[0], v[2], v[1])
        self.add_tri(v[0], v[3], v[2])
        # Top (+Z)
        self.add_tri(v[4], v[5], v[6])
        self.add_tri(v[4], v[6], v[7])
        # Front (-Y)
        self.add_tri(v[0], v[1], v[5])
        self.add_tri(v[0], v[5], v[4])
        # Back (+Y)
        self.add_tri(v[2], v[3], v[7])
        self.add_tri(v[2], v[7], v[6])
        # Left (-X)
        self.add_tri(v[3], v[0], v[4])
        self.add_tri(v[3], v[4], v[7])
        # Right (+X)
        self.add_tri(v[1], v[2], v[6])
        self.add_tri(v[1], v[6], v[5])

    def add_cylinder_z(self, cx, cy, z0, radius, height, segments=16):
        bot, top = [], []
        for i in range(segments):
            angle = 2 * math.pi * i / segments
            x = cx + radius * math.cos(angle)
            y = cy + radius * math.sin(angle)
            bot.append(self.add_v(x, y, z0))
            top.append(self.add_v(x, y, z0 + height))
        c_bot = self.add_v(cx, cy, z0)
        c_top = self.add_v(cx, cy, z0 + height)
        for i in range(segments):
            ni = (i + 1) % segments
            self.add_tri(c_bot, bot[ni], bot[i])
            self.add_tri(c_top, top[i], top[ni])
            self.add_tri(bot[i], top[ni], top[i])
            self.add_tri(bot[i], bot[ni], top[ni])

    def add_cylinder_y(self, cx, y0, cz, radius, height, segments=16):
        start, end = [], []
        for i in range(segments):
            angle = 2 * math.pi * i / segments
            x = cx + radius * math.cos(angle)
            z = cz + radius * math.sin(angle)
            start.append(self.add_v(x, y0, z))
            end.append(self.add_v(x, y0 + height, z))
        c_start = self.add_v(cx, y0, cz)
        c_end = self.add_v(cx, y0 + height, cz)
        for i in range(segments):
            ni = (i + 1) % segments
            self.add_tri(c_start, start[i], start[ni])
            self.add_tri(c_end, end[ni], end[i])
            self.add_tri(start[i], end[i], end[ni])
            self.add_tri(start[i], end[ni], start[ni])

    def add_cylinder_x(self, x0, cy, cz, radius, length, segments=16):
        start, end = [], []
        for i in range(segments):
            angle = 2 * math.pi * i / segments
            y = cy + radius * math.cos(angle)
            z = cz + radius * math.sin(angle)
            start.append(self.add_v(x0, y, z))
            end.append(self.add_v(x0 + length, y, z))
        c_start = self.add_v(x0, cy, cz)
        c_end = self.add_v(x0 + length, cy, cz)
        for i in range(segments):
            ni = (i + 1) % segments
            self.add_tri(c_start, start[ni], start[i])
            self.add_tri(c_end, end[i], end[ni])
            self.add_tri(start[i], end[ni], end[i])
            self.add_tri(start[i], start[ni], end[ni])

    def add_wedge_x(self, x0, y0, z0, dx, dy, dz, slope_dir="up_forward"):
        # Sloped wedge for aerodynamic cyberpunk ramps
        # slope_dir: 'up_forward' means slope rises from front(-x) to back(+x)
        if slope_dir == "up_forward":
            v = [
                self.add_v(x0, y0, z0),          # 0: bot front left
                self.add_v(x0+dx, y0, z0),       # 1: bot back left
                self.add_v(x0+dx, y0+dy, z0),    # 2: bot back right
                self.add_v(x0, y0+dy, z0),       # 3: bot front right
                self.add_v(x0+dx, y0, z0+dz),    # 4: top back left
                self.add_v(x0+dx, y0+dy, z0+dz), # 5: top back right
            ]
            self.add_tri(v[0], v[2], v[1])
            self.add_tri(v[0], v[3], v[2]) # bottom
            self.add_tri(v[0], v[1], v[4]) # left tri
            self.add_tri(v[3], v[5], v[2]) # right tri
            self.add_tri(v[1], v[2], v[5])
            self.add_tri(v[1], v[5], v[4]) # back
            self.add_tri(v[0], v[4], v[5])
            self.add_tri(v[0], v[5], v[3]) # sloped face
        elif slope_dir == "up_backward":
            v = [
                self.add_v(x0, y0, z0),          # 0: bot front left
                self.add_v(x0+dx, y0, z0),       # 1: bot back left
                self.add_v(x0+dx, y0+dy, z0),    # 2: bot back right
                self.add_v(x0, y0+dy, z0),       # 3: bot front right
                self.add_v(x0, y0, z0+dz),       # 4: top front left
                self.add_v(x0, y0+dy, z0+dz),    # 5: top front right
            ]
            self.add_tri(v[0], v[2], v[1])
            self.add_tri(v[0], v[3], v[2]) # bottom
            self.add_tri(v[0], v[1], v[4]) # left tri
            self.add_tri(v[3], v[5], v[2]) # right tri
            self.add_tri(v[0], v[4], v[5])
            self.add_tri(v[0], v[5], v[3]) # front
            self.add_tri(v[1], v[5], v[4])
            self.add_tri(v[1], v[2], v[5]) # sloped face

    def write_stl(self, filepath):
        os.makedirs(os.path.dirname(os.path.abspath(filepath)), exist_ok=True)
        with open(filepath, 'wb') as f:
            header = b"Cyberpunk ESP32 4WD Rover Binary STL Model" + b"\0" * 38
            f.write(header[:80])
            f.write(struct.pack('<I', len(self.faces)))
            for v0, v1, v2, _ in self.faces:
                p1 = self.vertices[v0-1]
                p2 = self.vertices[v1-1]
                p3 = self.vertices[v2-1]
                ux, uy, uz = p2[0]-p1[0], p2[1]-p1[1], p2[2]-p1[2]
                vx, vy, vz = p3[0]-p1[0], p3[1]-p1[1], p3[2]-p1[2]
                nx = uy*vz - uz*vy
                ny = uz*vx - ux*vz
                nz = ux*vy - uy*vx
                length = math.sqrt(nx*nx + ny*ny + nz*nz)
                if length > 1e-8:
                    nx, ny, nz = nx/length, ny/length, nz/length
                else:
                    nx, ny, nz = 0.0, 0.0, 1.0
                f.write(struct.pack('<3f3f3f3fH', nx, ny, nz, p1[0], p1[1], p1[2], p2[0], p2[1], p2[2], p3[0], p3[1], p3[2], 0))

    def write_obj(self, filepath, mtl_name="materials.mtl"):
        os.makedirs(os.path.dirname(os.path.abspath(filepath)), exist_ok=True)
        with open(filepath, 'w') as f:
            f.write(f"mtllib {mtl_name}\n")
            f.write("# Cyberpunk ESP32 4WD Robot Rover (Bambu A1 Black Transparent Edition)\n")
            for v in self.vertices:
                f.write(f"v {v[0]:.3f} {v[1]:.3f} {v[2]:.3f}\n")
            cur = None
            for v0, v1, v2, mat in self.faces:
                if mat != cur:
                    cur = mat
                    f.write(f"usemtl {cur}\n")
                f.write(f"f {v0} {v1} {v2}\n")

    def write_mtl(self, filepath):
        os.makedirs(os.path.dirname(os.path.abspath(filepath)), exist_ok=True)
        with open(filepath, 'w') as f:
            for name, (r, g, b, a) in self.materials.items():
                f.write(f"newmtl {name}\n")
                f.write(f"Kd {r:.3f} {g:.3f} {b:.3f}\n")
                f.write(f"Ka 0.15 0.15 0.15\n")
                f.write(f"Ks 0.4 0.4 0.4\n")
                f.write(f"d {a:.2f}\n")
                f.write(f"Ns 60\n\n")

def setup_cyber_materials(m):
    # Black Transparent / Cyberpunk Palette
    m.add_mat("smoke_black_trans", 0.12, 0.12, 0.14, alpha=0.72) # Black Transparent Shell
    m.add_mat("cyber_armor_matte", 0.16, 0.16, 0.18, alpha=1.0)  # Solid Cyber Dark Gray Armor
    m.add_mat("cyber_accent_blue", 0.05, 0.70, 0.95, alpha=1.0)  # Neon Cyan Highlights
    m.add_mat("chassis_carbon",    0.10, 0.10, 0.11, alpha=1.0)  # Carbon/Matte Black Chassis
    m.add_mat("motor_brass",       0.82, 0.72, 0.35, alpha=1.0)  # 1812 Brass Gearbox
    m.add_mat("motor_silver",      0.75, 0.78, 0.82, alpha=1.0)  # Motor Body
    m.add_mat("tire_rubber",       0.08, 0.08, 0.09, alpha=1.0)  # 34mm Rubber Wheels
    m.add_mat("wheel_cyan_rim",    0.05, 0.65, 0.90, alpha=1.0)  # Neon Cyan Wheel Hub
    m.add_mat("battery_blue",      0.15, 0.35, 0.85, alpha=1.0)  # 18650 Battery Cells
    m.add_mat("pcb_black_gold",    0.12, 0.14, 0.13, alpha=1.0)  # Black/Green PCB
    m.add_mat("heatsink_fin",      0.15, 0.15, 0.16, alpha=1.0)  # L298N Heat Sinks
    m.add_mat("oled_hud",          0.00, 0.85, 1.00, alpha=1.0)  # Glowing Cyber OLED Visor
    m.add_mat("ultrasonic_silver", 0.85, 0.88, 0.92, alpha=1.0)  # HC-SR04 Transducers

# -------------------------------------------------------------------------
# Part 1: 一体化动力底盘 (Lower Power & Drive Chassis)
# -------------------------------------------------------------------------
def build_part1_chassis():
    m = Mesh3D()
    setup_cyber_materials(m)
    m.set_mat("chassis_carbon")

    # Main Base Plate (160 x 124 mm, thickness 3.5mm at Z=9.0~12.5mm)
    # Central corridor (length 160mm, width 88mm from Y=-44 to +44)
    m.add_box(-80, -44, 9.0, 160, 88, 3.5)
    # Front & Rear wings
    m.add_box(68, -62, 9.0, 12, 124, 3.5)
    m.add_box(-80, -62, 9.0, 12, 124, 3.5)
    # Middle wings between wheels (X: -22 to +22)
    m.add_box(-22, -62, 9.0, 44, 124, 3.5)

    # Front/Rear 45° skid ramps (Cyberpunk bumper armor)
    m.add_wedge_x(80, -44, 9.0, 8, 88, 5.0, slope_dir="up_backward")
    m.add_wedge_x(-88, -44, 9.0, 8, 88, 5.0, slope_dir="up_forward")

    # 4x Integrated 1812-N20 Motor Cradles & Clamping Blocks
    # Motors located at X=±45, Y=±36
    for (mx, my, dir_x) in [(45, 36, -1), (45, -36, -1), (-45, 36, 1), (-45, -36, 1)]:
        y_side = 1 if my > 0 else -1
        gb_x = mx - 6 if dir_x > 0 else mx - 12
        # Cradle Base Bed (raised 3mm with hollowed nest)
        m.add_box(gb_x - 2, my - 7, 12.5, 37, 14, 2.5)
        # Outer Shaft Bearing Boss (Z=12.5 to 22.0)
        m.add_box(mx - 4, my + y_side * 5.0, 12.5, 8, 3.0, 9.5)
        # Inner Clamping Rib
        m.add_box(mx - 4, my - y_side * 6.5, 12.5, 8, 2.0, 8.0)
        # Screw Bosses for motor hold-down bridge
        m.add_cylinder_z(mx - 7, my + y_side * 7.5, 12.5, 3.0, 9.0, segments=12)
        m.add_cylinder_z(mx + 7, my + y_side * 7.5, 12.5, 3.0, 9.0, segments=12)

    # Central 2S 18650 Battery Bay (Inside: 76 x 41 x 18 mm)
    # Retaining side walls with 2mm thickness
    m.add_box(-39, -22.5, 12.5, 78, 2.0, 16.0) # left wall
    m.add_box(-39, 20.5, 12.5, 78, 2.0, 16.0)  # right wall
    m.add_box(-39, -22.5, 12.5, 2.0, 45.0, 16.0) # rear wall
    m.add_box(37, -22.5, 12.5, 2.0, 45.0, 16.0)  # front wall
    # Anti-slip battery retention ribs
    for rx in [-20, 0, 20]:
        m.add_box(rx - 1, -21.5, 12.5, 2.0, 43.0, 1.5)

    # 6x M3 Standoff Columns for Mid Electronics Deck (Z=12.5 to 47.0mm, height 34.5mm)
    for px, py in [(60, 40), (60, -40), (-60, 40), (-60, -40), (0, 40), (0, -40)]:
        m.add_cylinder_z(px, py, 12.5, 3.5, 34.5, segments=12)
        # M3 pilot hole locator on top
        m.add_cylinder_z(px, py, 47.0, 1.8, 1.5, segments=8)

    # Wire Routing Troughs (Cable management rails)
    m.add_box(-60, -32, 12.5, 120, 2.0, 3.0)
    m.add_box(-60, 30, 12.5, 120, 2.0, 3.0)

    return m

# -------------------------------------------------------------------------
# Part 2: 中层模块化电子托盘 (Electronics Mid Deck)
# -------------------------------------------------------------------------
def build_part2_mid_deck():
    m = Mesh3D()
    setup_cyber_materials(m)
    m.set_mat("chassis_carbon")

    # Main Plate (136 x 94 x 2.8 mm, at Z=47.0 ~ 49.8mm)
    m.add_box(-68, -47, 47.0, 136, 94, 2.8)

    # Perimeter Reinforcement Rim
    m.add_box(-68, -47, 49.8, 136, 2.5, 2.0)
    m.add_box(-68, 44.5, 49.8, 136, 2.5, 2.0)
    m.add_box(-68, -47, 49.8, 2.5, 94, 2.0)
    m.add_box(65.5, -47, 49.8, 2.5, 94, 2.0)

    # 4x ESP32 38Pin Expansion Board Standoffs (60 x 47 mm pattern at X: +3 to +63)
    esp_center_x, esp_center_y = 33.0, 0.0
    for sx, sy in [(-30, -23.5), (-30, 23.5), (30, -23.5), (30, 23.5)]:
        m.add_cylinder_z(esp_center_x + sx, esp_center_y + sy, 49.8, 3.0, 4.0, segments=12)

    # 2x L298N Standoffs (37 x 37 mm pattern each at rear)
    for ly in [23.5, -23.5]:
        lx_center = -35.0
        for px, py in [(-18.5, -18.5), (-18.5, 18.5), (18.5, -18.5), (18.5, 18.5)]:
            m.add_cylinder_z(lx_center + px, ly + py, 49.8, 3.0, 4.0, segments=12)

    # LM2596S Standoffs (at X=-2.0, Y=0)
    for px, py in [(-15.0, -8.0), (15.0, 8.0)]:
        m.add_cylinder_z(-2.0 + px, py, 49.8, 2.5, 3.5, segments=10)

    # SU-03T Voice Module & Speaker Mounting Bracket (at X=+50, Y=+32)
    m.add_cylinder_z(50.0, 32.0, 49.8, 14.5, 2.0, segments=24) # 28mm speaker cradle rim
    # Acoustic mesh holes
    for r in [4.0, 8.0, 11.0]:
        for i in range(8):
            ang = 2 * math.pi * i / 8
            m.add_cylinder_z(50.0 + r*math.cos(ang), 32.0 + r*math.sin(ang), 49.8, 1.2, 2.5, segments=8)

    # 4x Chassis Mounting Holes / Recesses matching Lower Deck
    for px, py in [(60, 40), (60, -40), (-60, 40), (-60, -40)]:
        m.add_cylinder_z(px, py, 47.0, 3.5, 3.0, segments=12)

    return m

# -------------------------------------------------------------------------
# Part 3: 赛博机能黑透主车壳 (Cyber Armor Body Shell)
# -------------------------------------------------------------------------
def build_part3_cyber_shell():
    m = Mesh3D()
    setup_cyber_materials(m)
    m.set_mat("smoke_black_trans")

    # Dimensions: 168 x 126 x 56 mm (Z=40.0 to 92.0mm)
    # 1. Lower Armor Skirt & Wheel Arch Flares
    # Left & Right Armored Flanks
    for sy in [-1, 1]:
        # Main flank wall (Z=40 to 76mm)
        m.add_box(-74, sy * 58.0 - (2.5 if sy > 0 else 0), 40.0, 148, 2.5, 36.0)
        # Front wheel flare wedge (X: +20 to +70)
        m.add_wedge_x(20, sy * 60.5 - (3.5 if sy > 0 else 0), 40.0, 24, 3.5, 16.0, slope_dir="up_forward")
        m.add_wedge_x(44, sy * 60.5 - (3.5 if sy > 0 else 0), 40.0, 24, 3.5, 16.0, slope_dir="up_backward")
        # Rear wheel flare wedge (X: -70 to -20)
        m.add_wedge_x(-68, sy * 60.5 - (3.5 if sy > 0 else 0), 40.0, 24, 3.5, 16.0, slope_dir="up_forward")
        m.add_wedge_x(-44, sy * 60.5 - (3.5 if sy > 0 else 0), 40.0, 24, 3.5, 16.0, slope_dir="up_backward")

        # Side Air Intake Gills / Louvers (revealing glowing electronics)
        m.set_mat("cyber_accent_blue")
        for gx in [-12, -2, 8]:
            m.add_box(gx, sy * 58.0 - (3.0 if sy > 0 else -0.5), 54.0, 6.0, 3.0, 14.0)
        m.set_mat("smoke_black_trans")

    # 2. Front Cyber Nose & Headlight Cannon Pods (HC-SR04 Mount)
    # Nose lower sloped armor
    m.add_wedge_x(74, -58.0, 38.0, 14, 116.0, 22.0, slope_dir="up_backward")
    # Front Twin Cannon Pods (Beveled rings for Ø16.2mm ultrasonic probes)
    m.set_mat("cyber_armor_matte")
    m.add_box(84, -26.0, 44.0, 4.0, 52.0, 18.0)
    for py in [-13.0, 13.0]:
        m.add_cylinder_x(84.0, py, 53.0, 10.5, 5.0, segments=24) # Outer armor ring
        m.set_mat("cyber_accent_blue")
        m.add_cylinder_x(87.0, py, 53.0, 9.0, 2.5, segments=20)  # Neon accent bezel
        m.set_mat("cyber_armor_matte")

    # 3. Raked Cockpit Visor & 0.96" OLED HUD Frame (Front Visor)
    # Visor slopes at 60° from X=+68, Z=60 to X=+48, Z=86
    m.set_mat("smoke_black_trans")
    m.add_wedge_x(48, -50.0, 60.0, 26, 100.0, 26.0, slope_dir="up_backward")
    # OLED HUD Screen Recessed Display Plate
    m.set_mat("oled_hud")
    m.add_box(68.0, -16.0, 64.0, 2.0, 32.0, 18.0) # Glowing blue OLED cyber eye
    m.set_mat("smoke_black_trans")

    # 4. Upper Cabin Armor & Sloped Roof Perimeter
    m.add_box(-74, -48.0, 76.0, 122, 96.0, 12.0)
    # Rear armor panel & rear ultrasonic radar housing
    m.add_wedge_x(-86, -56.0, 38.0, 12, 112.0, 38.0, slope_dir="up_forward")
    m.set_mat("cyber_armor_matte")
    m.add_box(-86, -26.0, 48.0, 3.0, 52.0, 16.0) # Rear sensor boss

    # 5. Cutouts for Connectivity & Switches
    # Right Flank ESP32 Type-C Port Cutout Frame
    m.set_mat("cyber_accent_blue")
    m.add_box(22.0, -59.5, 48.0, 24.0, 3.0, 12.0)
    # Rear KCD11 Switch Bezel
    m.add_box(-76.0, 30.0, 48.0, 3.0, 18.0, 14.0)

    # 4x Top Magnet / Snap Pockets for Quick-Release Roof
    m.set_mat("cyber_armor_matte")
    for rx, ry in [(42, 38), (42, -38), (-64, 38), (-64, -38)]:
        m.add_cylinder_z(rx, ry, 84.0, 4.0, 4.0, segments=12)

    return m

# -------------------------------------------------------------------------
# Part 4: 极客百叶风道快拆顶盖 (Quick-Release Roof Canopy)
# -------------------------------------------------------------------------
def build_part4_roof_canopy():
    m = Mesh3D()
    setup_cyber_materials(m)
    m.set_mat("smoke_black_trans")

    # Main Canopy Plate (136 x 92 x 3.0 mm at Z=88.0~91.0mm)
    m.add_box(-68, -46, 88.0, 136, 92, 3.0)

    # Stealth Faceted Chamfer Borders
    m.add_wedge_x(64, -46, 88.0, 8, 92, 3.0, slope_dir="up_backward")
    m.add_wedge_x(-72, -46, 88.0, 8, 92, 3.0, slope_dir="up_forward")

    # Dual Cyber Spoiler Fins on Trailing Edge
    m.set_mat("cyber_accent_blue")
    for fy in [36.0, -36.0]:
        m.add_wedge_x(-68, fy - 2.5, 91.0, 32, 5.0, 12.0, slope_dir="up_forward")
        m.add_box(-68, fy - 2.5, 103.0, 16, 5.0, 2.0) # Winglet tip

    # High-Flow Heat Exhaust Louvers (directly over dual L298N heat sinks)
    m.set_mat("cyber_armor_matte")
    for lx in range(-6, 2):
        bx = lx * 10 - 2
        m.add_box(bx, -28, 91.0, 5.5, 56.0, 2.5)

    # Central Neon Accent Strip
    m.set_mat("cyber_accent_blue")
    m.add_box(-60, -2.0, 91.0, 120, 4.0, 1.5)

    # 4x Neodymium Magnet Mount Bosses (matching Part 3)
    m.set_mat("cyber_armor_matte")
    for rx, ry in [(42, 38), (42, -38), (-64, 38), (-64, -38)]:
        m.add_cylinder_z(rx, ry, 84.0, 3.8, 4.0, segments=12)

    return m

# -------------------------------------------------------------------------
# Full Assembly (整车总装模型)
# -------------------------------------------------------------------------
def build_assembled_cyber_car():
    m = Mesh3D()
    setup_cyber_materials(m)

    # 1. Add Part 1 Chassis
    chassis = build_part1_chassis()
    for v in chassis.vertices: m.add_v(v[0], v[1], v[2])
    for v0, v1, v2, mat in chassis.faces: m.faces.append((v0, v1, v2, mat))

    # 2. Add Part 2 Mid Deck
    mid_deck = build_part2_mid_deck()
    v_offset = len(m.vertices)
    for v in mid_deck.vertices: m.add_v(v[0], v[1], v[2])
    for v0, v1, v2, mat in mid_deck.faces: m.faces.append((v0 + v_offset, v1 + v_offset, v2 + v_offset, mat))

    # 3. Add Part 3 Cyber Shell
    shell = build_part3_cyber_shell()
    v_offset = len(m.vertices)
    for v in shell.vertices: m.add_v(v[0], v[1], v[2])
    for v0, v1, v2, mat in shell.faces: m.faces.append((v0 + v_offset, v1 + v_offset, v2 + v_offset, mat))

    # 4. Add Part 4 Roof Canopy
    roof = build_part4_roof_canopy()
    v_offset = len(m.vertices)
    for v in roof.vertices: m.add_v(v[0], v[1], v[2])
    for v0, v1, v2, mat in roof.faces: m.faces.append((v0 + v_offset, v1 + v_offset, v2 + v_offset, mat))

    # 5. Add Visible Core Hardware (Wheels, Motors, Sensors, Battery)
    # 4x Wheels
    for (wx, wy) in [(45, 53.75), (45, -53.75), (-45, 53.75), (-45, -53.75)]:
        y_sign = 1 if wy > 0 else -1
        # Rubber tire
        m.set_mat("tire_rubber")
        m.add_cylinder_y(wx, min(wy - y_sign * 3.5, wy + y_sign * 3.5), 17.0, 17.0, 7.0, segments=24)
        # Neon cyan rim
        m.set_mat("wheel_cyan_rim")
        m.add_cylinder_y(wx, min(wy - y_sign * 4.75, wy + y_sign * 4.75), 17.0, 11.5, 9.5, segments=16)

    # 4x 1812-N20 Motors (visible through bottom & side louvers)
    for (mx, my, dir_x) in [(45, 36, -1), (45, -36, -1), (-45, 36, 1), (-45, -36, 1)]:
        gb_x = mx - 6 if dir_x > 0 else mx - 12
        m.set_mat("motor_brass")
        m.add_box(gb_x, my - 6, 13.0, 18, 12, 10)
        m.set_mat("motor_silver")
        mb_x = gb_x + 18 if dir_x > 0 else gb_x - 15
        m.add_box(mb_x, my - 6, 13.0, 15, 12, 10)

    # Battery
    m.set_mat("battery_blue")
    m.add_box(-36, -18.0, 13.5, 72, 36.0, 18.0)

    # Dual L298N Heat Sinks (visible under roof louvers)
    m.set_mat("heatsink_fin")
    m.add_box(-45, 12.0, 54.0, 23.0, 24.0, 23.0)
    m.add_box(-45, -36.0, 54.0, 23.0, 24.0, 23.0)

    # Front Ultrasonic Transducers (silver cylinders)
    m.set_mat("ultrasonic_silver")
    m.add_cylinder_x(88.0, -13.0, 53.0, 8.0, 11.0, segments=20)
    m.add_cylinder_x(88.0, 13.0, 53.0, 8.0, 11.0, segments=20)

    # Rear Ultrasonic Transducers
    m.add_cylinder_x(-96.0, -13.0, 56.0, 8.0, 10.0, segments=20)
    m.add_cylinder_x(-96.0, 13.0, 56.0, 8.0, 10.0, segments=20)

    return m

if __name__ == "__main__":
    out_dir = "/home/antigravity/y1024892901/cute-esp32-lego-car/models-3d"
    os.makedirs(out_dir, exist_ok=True)
    print("Generating Cyberpunk 3D Printable Models for Bambu Lab A1...")

    # 1. Part 1: Lower Chassis
    p1 = build_part1_chassis()
    p1.write_stl(os.path.join(out_dir, "part1_lower_power_chassis.stl"))
    print(f"-> Part 1 Lower Chassis STL generated ({len(p1.faces)} faces)")

    # 2. Part 2: Electronics Mid Deck
    p2 = build_part2_mid_deck()
    p2.write_stl(os.path.join(out_dir, "part2_electronics_mid_deck.stl"))
    print(f"-> Part 2 Mid Deck STL generated ({len(p2.faces)} faces)")

    # 3. Part 3: Cyber Armor Shell
    p3 = build_part3_cyber_shell()
    p3.write_stl(os.path.join(out_dir, "part3_cyber_armor_shell.stl"))
    print(f"-> Part 3 Cyber Shell STL generated ({len(p3.faces)} faces)")

    # 4. Part 4: Quick Release Roof Canopy
    p4 = build_part4_roof_canopy()
    p4.write_stl(os.path.join(out_dir, "part4_quick_release_roof_canopy.stl"))
    print(f"-> Part 4 Roof Canopy STL generated ({len(p4.faces)} faces)")

    # 5. Full Assembled Vehicle (STL + OBJ/MTL for 3D visualizers)
    assembled = build_assembled_cyber_car()
    assembled.write_stl(os.path.join(out_dir, "assembled_cyber_car.stl"))
    assembled.write_obj(os.path.join(out_dir, "assembled_cyber_car.obj"), mtl_name="assembled_cyber_car.mtl")
    assembled.write_mtl(os.path.join(out_dir, "assembled_cyber_car.mtl"))
    print(f"-> Full Assembled Cyber Car generated ({len(assembled.faces)} faces)")

    print("ALL 3D PRINTING MODELS GENERATED SUCCESSFULLY!")
