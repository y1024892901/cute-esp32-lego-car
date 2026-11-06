import math
import struct

class ModelBuilder:
    def __init__(self):
        self.vertices = []
        self.faces = [] # (v1, v2, v3, material_name)
        self.materials = {}
        self.current_material = "default"

    def add_material(self, name, r, g, b):
        self.materials[name] = (r, g, b)

    def set_material(self, name):
        self.current_material = name

    def add_v(self, x, y, z):
        self.vertices.append((float(x), float(y), float(z)))
        return len(self.vertices)

    def add_box(self, x0, y0, z0, dx, dy, dz):
        v = [
            self.add_v(x0, y0, z0),
            self.add_v(x0+dx, y0, z0),
            self.add_v(x0+dx, y0+dy, z0),
            self.add_v(x0, y0+dy, z0),
            self.add_v(x0, y0, z0+dz),
            self.add_v(x0+dx, y0, z0+dz),
            self.add_v(x0+dx, y0+dy, z0+dz),
            self.add_v(x0, y0+dy, z0+dz),
        ]
        # 12 triangles
        tris = [
            (v[0], v[2], v[1]), (v[0], v[3], v[2]), # bottom
            (v[4], v[5], v[6]), (v[4], v[6], v[7]), # top
            (v[0], v[1], v[5]), (v[0], v[5], v[4]), # -Y
            (v[2], v[3], v[7]), (v[2], v[7], v[6]), # +Y
            (v[3], v[0], v[4]), (v[3], v[4], v[7]), # -X
            (v[1], v[2], v[6]), (v[1], v[6], v[5]), # +X
        ]
        for tri in tris:
            self.faces.append((tri[0], tri[1], tri[2], self.current_material))

    def add_cylinder_z(self, cx, cy, z0, radius, height, segments=16):
        bot = []
        top = []
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
            self.faces.append((c_bot, bot[ni], bot[i], self.current_material))
            self.faces.append((c_top, top[i], top[ni], self.current_material))
            self.faces.append((bot[i], top[ni], top[i], self.current_material))
            self.faces.append((bot[i], bot[ni], top[ni], self.current_material))

    def add_cylinder_y(self, cx, y0, cz, radius, height, segments=16):
        start = []
        end = []
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
            self.faces.append((c_start, start[i], start[ni], self.current_material))
            self.faces.append((c_end, end[ni], end[i], self.current_material))
            self.faces.append((start[i], end[i], end[ni], self.current_material))
            self.faces.append((start[i], end[ni], start[ni], self.current_material))

    def add_cylinder_x(self, x0, cy, cz, radius, length, segments=16):
        start = []
        end = []
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
            self.faces.append((c_start, start[ni], start[i], self.current_material))
            self.faces.append((c_end, end[i], end[ni], self.current_material))
            self.faces.append((start[i], end[ni], end[i], self.current_material))
            self.faces.append((start[i], start[ni], end[ni], self.current_material))

    def add_lego_brick(self, cx, cy, cz, studs_x, studs_y, plates_z=3, with_studs=True):
        dx = studs_x * 8.0 - 0.2
        dy = studs_y * 8.0 - 0.2
        dz = plates_z * 3.2
        self.add_box(cx - dx/2, cy - dy/2, cz, dx, dy, dz)
        if with_studs:
            for ix in range(studs_x):
                for iy in range(studs_y):
                    sx = cx + (-studs_x/2.0 + 0.5 + ix) * 8.0
                    sy = cy + (-studs_y/2.0 + 0.5 + iy) * 8.0
                    self.add_cylinder_z(sx, sy, cz + dz, 2.4, 1.8, segments=12)

    def write_obj(self, filename, mtl_filename="cute-car-model.mtl"):
        with open(filename, 'w') as f:
            f.write(f"mtllib {mtl_filename}\n")
            f.write(f"# Cute Pastel ESP32 Lego Car 3D Model\n")
            for v in self.vertices:
                f.write(f"v {v[0]:.3f} {v[1]:.3f} {v[2]:.3f}\n")
            
            cur_mat = None
            for v1, v2, v3, mat in self.faces:
                if mat != cur_mat:
                    cur_mat = mat
                    f.write(f"usemtl {cur_mat}\n")
                f.write(f"f {v1} {v2} {v3}\n")

    def write_mtl(self, filename):
        with open(filename, 'w') as f:
            for name, (r, g, b) in self.materials.items():
                f.write(f"newmtl {name}\n")
                f.write(f"Kd {r:.3f} {g:.3f} {b:.3f}\n")
                f.write(f"Ka 0.2 0.2 0.2\n")
                f.write(f"Ks 0.1 0.1 0.1\n")
                f.write(f"Ns 10\n\n")

    def write_stl(self, filename):
        with open(filename, 'wb') as f:
            # 80 bytes header
            header = b"Cute ESP32 Lego Car Binary STL 3D Model Export" + b"\0" * 33
            f.write(header[:80])
            f.write(struct.pack('<I', len(self.faces)))
            for v1, v2, v3, _ in self.faces:
                p1 = self.vertices[v1-1]
                p2 = self.vertices[v2-1]
                p3 = self.vertices[v3-1]
                # calculate normal
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

def build_car():
    m = ModelBuilder()
    
    # 1. Colors & Materials (Macaron Theme)
    m.add_material("cream_yellow", 0.99, 0.91, 0.60) # Main Body
    m.add_material("mint_green",   0.64, 0.89, 0.78) # Accent Belt & Louvers
    m.add_material("milk_white",   0.97, 0.97, 0.95) # Bumpers
    m.add_material("blush_pink",   0.96, 0.64, 0.76) # Cheek Mic Ports
    m.add_material("window_dark",  0.20, 0.22, 0.26) # OLED Frame & Windshield
    m.add_material("oled_screen",  0.10, 0.45, 0.95) # OLED Blue Glowing Face
    m.add_material("acrylic_deck", 0.85, 0.92, 0.98) # Transparent Acrylic Chassis
    m.add_material("motor_gold",   0.78, 0.72, 0.35) # 1812 Brass Gearbox
    m.add_material("motor_silver", 0.75, 0.77, 0.80) # Motor body
    m.add_material("tire_rubber",  0.18, 0.18, 0.20) # 34mm Rubber Wheels
    m.add_material("wheel_hub",    0.85, 0.85, 0.88) # Hub & Encoder disc
    m.add_material("pcb_green",    0.15, 0.55, 0.25) # PCB boards
    m.add_material("battery_blue", 0.25, 0.45, 0.85) # 18650 Battery cells
    m.add_material("heatsink_blk", 0.15, 0.15, 0.16) # L298N Heat Sinks
    m.add_material("sensor_silver",0.85, 0.88, 0.90) # Ultrasonic Canisters

    # --- 2. Lower Acrylic Chassis (160 x 128 x 3 mm) ---
    m.set_material("acrylic_deck")
    # Central spine
    m.add_box(-80, -46, 9.0, 160, 92, 3.0)
    # Front & Rear full-width wings
    m.add_box(68, -64, 9.0, 12, 128, 3.0)
    m.add_box(-80, -64, 9.0, 12, 128, 3.0)
    # Middle side wings (between wheels)
    m.add_box(-22, -64, 9.0, 44, 128, 3.0)

    # --- 3. 4x Wheels (ZJ327 34mm Rubber Wheels) ---
    for (wx, wy) in [(45, 53.75), (45, -53.75), (-45, 53.75), (-45, -53.75)]:
        y_sign = 1 if wy > 0 else -1
        hub_y0 = wy - y_sign * 4.75
        tire_y0 = wy - y_sign * 3.5
        # Rubber tire
        m.set_material("tire_rubber")
        m.add_cylinder_y(wx, min(tire_y0, tire_y0 + y_sign * 7.0), 17.0, 17.0, 7.0, segments=24)
        # Hub & code wheel
        m.set_material("wheel_hub")
        m.add_cylinder_y(wx, min(hub_y0, hub_y0 + y_sign * 9.5), 17.0, 12.0, 9.5, segments=16)

    # --- 4. 4x 1812-N20 Motors ---
    for (mx, my, dir_x) in [(45, 36, -1), (45, -36, -1), (-45, 36, 1), (-45, -36, 1)]:
        # Brass worm gearbox (18 x 12 x 10 mm)
        m.set_material("motor_gold")
        gb_x = mx - 6 if dir_x > 0 else mx - 12
        m.add_box(gb_x, my - 6, 12.0, 18, 12, 10)
        # Silver motor body (15 x 12 x 10 mm)
        m.set_material("motor_silver")
        mb_x = gb_x + 18 if dir_x > 0 else gb_x - 15
        m.add_box(mb_x, my - 6, 12.0, 15, 12, 10)

    # --- 5. Central 2S 18650 Battery Compartment ---
    m.set_material("battery_blue")
    m.add_box(-38, -20.5, 12.0, 76, 41, 21.0)
    m.set_material("heatsink_blk")
    # Battery case frame rim
    m.add_box(-39, -21.5, 12.0, 78, 2, 22.0)
    m.add_box(-39, 19.5, 12.0, 78, 2, 22.0)

    # --- 6. Upper Electronics Deck (136 x 96 x 3 mm at Z=47~50mm) ---
    m.set_material("acrylic_deck")
    m.add_box(-68, -48, 47.0, 136, 96, 3.0)

    # M3 Hex Standoffs (6 pillars)
    m.set_material("wheel_hub")
    for px, py in [(60, 42), (60, -42), (-60, 42), (-60, -42), (0, 42), (0, -42)]:
        m.add_cylinder_z(px, py, 12.0, 2.5, 35.0, segments=8)

    # --- 7. Upper Electronics: Dual L298N, ESP32, LM2596S ---
    # ESP32 Shield (front upper)
    m.set_material("pcb_green")
    m.add_box(2, -26.5, 50.0, 64, 53, 6.0)
    m.set_material("wheel_hub") # ESP32 Metal RF shield
    m.add_box(20, -14, 56.0, 28, 28, 4.0)

    # Dual L298N Drivers (rear upper)
    for ly in [24.5, -24.5]:
        m.set_material("pcb_green")
        m.add_box(-55, ly - 21.5, 50.0, 43, 43, 3.0)
        # Black Fin Heatsink
        m.set_material("heatsink_blk")
        m.add_box(-45, ly - 12, 53.0, 23, 24, 23.0)

    # LM2596S Converter
    m.set_material("pcb_green")
    m.add_box(-11, -21, 50.0, 22, 42, 3.0)

    # --- 8. Ultrasonic Sensors (HC-SR04) ---
    # Front Headlights
    m.set_material("pcb_green")
    m.add_box(74, -22.5, 23.0, 2.0, 45, 20)
    m.set_material("sensor_silver")
    m.add_cylinder_x(76, -13, 33.0, 8.0, 12.0, segments=20)
    m.add_cylinder_x(76, 13, 33.0, 8.0, 12.0, segments=20)

    # Rear Bumper Radar
    m.set_material("pcb_green")
    m.add_box(-76, -22.5, 23.0, 2.0, 45, 20)
    m.set_material("sensor_silver")
    m.add_cylinder_x(-88, -13, 33.0, 8.0, 12.0, segments=20)
    m.add_cylinder_x(-88, 13, 33.0, 8.0, 12.0, segments=20)

    # --- 9. Lego Macaron Van Body Shell ---
    # Base height = 12.0mm
    # Milk-white Curved Bumpers (Front & Rear)
    m.set_material("milk_white")
    m.add_lego_brick(84, 0, 12.0, 1, 16, plates_z=3, with_studs=False)
    m.add_lego_brick(80, 44, 21.6, 2, 5, plates_z=6, with_studs=True)
    m.add_lego_brick(80, -44, 21.6, 2, 5, plates_z=6, with_studs=True)
    m.add_lego_brick(-84, 0, 12.0, 1, 16, plates_z=3, with_studs=False)
    m.add_lego_brick(-80, 44, 21.6, 2, 5, plates_z=6, with_studs=True)
    m.add_lego_brick(-80, -44, 21.6, 2, 5, plates_z=6, with_studs=True)

    # Cream Yellow Base Side Skirts (Technic interface)
    m.set_material("cream_yellow")
    m.add_lego_brick(0, 56, 12.0, 6, 2, plates_z=6, with_studs=True)
    m.add_lego_brick(0, -56, 12.0, 6, 2, plates_z=6, with_studs=True)

    # Mint Green Mid-body Waist Accent Belt (Layer 4)
    m.set_material("mint_green")
    m.add_lego_brick(0, 56, 40.8, 20, 2, plates_z=3, with_studs=True)
    m.add_lego_brick(0, -56, 40.8, 20, 2, plates_z=3, with_studs=True)
    m.add_lego_brick(72, 0, 40.8, 2, 12, plates_z=3, with_studs=True)
    m.add_lego_brick(-72, 0, 40.8, 2, 12, plates_z=3, with_studs=True)

    # Cream Yellow Upper Walls (Layers 5~7)
    m.set_material("cream_yellow")
    m.add_lego_brick(0, 56, 50.4, 20, 2, plates_z=9, with_studs=True)
    m.add_lego_brick(0, -56, 50.4, 20, 2, plates_z=9, with_studs=True)
    m.add_lego_brick(-72, 0, 50.4, 2, 12, plates_z=9, with_studs=True)

    # Pink Cheek Blush Microphone Ports (Front Left & Right)
    m.set_material("blush_pink")
    m.add_lego_brick(79, 28, 50.4, 1, 2, plates_z=3, with_studs=False)
    m.add_lego_brick(79, -28, 50.4, 1, 2, plates_z=3, with_studs=False)

    # Dark Gray Windshield & Blue OLED Expression Screen (Front)
    m.set_material("window_dark")
    m.add_lego_brick(72, 0, 60.0, 2, 12, plates_z=9, with_studs=True)
    m.set_material("oled_screen")
    # Glowing OLED Screen inside windshield frame
    m.add_box(79, -16, 64.0, 2.0, 32, 19.2)

    # --- 10. Removable Roof Cap (4-stud Quick Release) ---
    m.set_material("cream_yellow")
    # Roof Main Plate (18 x 14 Studs frame at Z=88.8mm)
    m.add_box(-68, -52, 88.8, 136, 104, 3.2)
    # Curved roof perimeter slopes
    m.add_box(-72, -56, 92.0, 144, 112, 6.4)

    # Mint Green Roof Ventilation Louvers (above L298N heat sinks)
    m.set_material("mint_green")
    for lx in range(-5, 3):
        m.add_box(lx * 10 - 5, -24, 98.4, 6, 48, 2.0)
    # Cute little roof ear handles
    m.add_lego_brick(0, 20, 98.4, 2, 1, plates_z=2, with_studs=False)
    m.add_lego_brick(0, -20, 98.4, 2, 1, plates_z=2, with_studs=False)

    return m

if __name__ == "__main__":
    print("Building Cute ESP32 Lego Car 3D geometry...")
    car = build_car()
    print(f"Total vertices: {len(car.vertices)}, total triangles: {len(car.faces)}")

    obj_path = "/home/antigravity/y1024892901/cute-esp32-lego-car/cute-car-model.obj"
    mtl_path = "/home/antigravity/y1024892901/cute-esp32-lego-car/cute-car-model.mtl"
    stl_path = "/home/antigravity/y1024892901/cute-esp32-lego-car/cute-car-model.stl"

    car.write_mtl(mtl_path)
    car.write_obj(obj_path, mtl_filename="cute-car-model.mtl")
    car.write_stl(stl_path)
    print(f"Successfully exported OBJ: {obj_path}")
    print(f"Successfully exported MTL: {mtl_path}")
    print(f"Successfully exported STL: {stl_path}")
