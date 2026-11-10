import math
import struct
import os
import zipfile
from generate_cyber_car import (
    Mesh3D, setup_cyber_materials,
    build_part1_chassis, build_part2_mid_deck,
    build_part3_cyber_shell, build_part4_roof_canopy,
    build_assembled_cyber_car
)

def export_3mf(mesh, filepath, title="Model"):
    os.makedirs(os.path.dirname(os.path.abspath(filepath)), exist_ok=True)
    model_xml = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">',
        f'  <metadata name="Title">{title}</metadata>',
        '  <resources>',
        '    <object id="1" type="model">',
        '      <mesh>',
        '        <vertices>'
    ]
    for x, y, z in mesh.vertices:
        model_xml.append(f'          <vertex x="{x:.3f}" y="{y:.3f}" z="{z:.3f}" />')
    model_xml.append('        </vertices>')
    model_xml.append('        <triangles>')
    for v0, v1, v2, _ in mesh.faces:
        model_xml.append(f'          <triangle v1="{v0-1}" v2="{v1-1}" v3="{v2-1}" />')
    model_xml.append('        </triangles>')
    model_xml.append('      </mesh>')
    model_xml.append('    </object>')
    model_xml.append('  </resources>')
    model_xml.append('  <build>')
    model_xml.append('    <item objectid="1" />')
    model_xml.append('  </build>')
    model_xml.append('</model>')
    xml_str = '\n'.join(model_xml)

    content_types = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
        '  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />\n'
        '  <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml" />\n'
        '</Types>'
    )
    rels = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        '  <Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel" />\n'
        '</Relationships>'
    )

    with zipfile.ZipFile(filepath, 'w', compression=zipfile.ZIP_DEFLATED) as z:
        z.writestr('[Content_Types].xml', content_types)
        z.writestr('_rels/.rels', rels)
        z.writestr('3D/3dmodel.model', xml_str)

def combine_meshes(mesh_list, title="Combined"):
    combined = Mesh3D()
    setup_cyber_materials(combined)
    for m in mesh_list:
        v_offset = len(combined.vertices)
        for v in m.vertices:
            combined.add_v(v[0], v[1], v[2])
        for v0, v1, v2, mat in m.faces:
            combined.faces.append((v0 + v_offset, v1 + v_offset, v2 + v_offset, mat))
    return combined

out_dir = "/home/antigravity/y1024892901/cute-esp32-lego-car/models-3d"
print("Generating all 3D files (STL + 3MF + OBJ)...")

p1 = build_part1_chassis()
p2 = build_part2_mid_deck()
p3 = build_part3_cyber_shell()
p4 = build_part4_roof_canopy()
assembled = build_assembled_cyber_car()

# Export STLs
p1.write_stl(os.path.join(out_dir, "part1_lower_power_chassis.stl"))
p2.write_stl(os.path.join(out_dir, "part2_electronics_mid_deck.stl"))
p3.write_stl(os.path.join(out_dir, "part3_cyber_armor_shell.stl"))
p4.write_stl(os.path.join(out_dir, "part4_quick_release_roof_canopy.stl"))
assembled.write_stl(os.path.join(out_dir, "assembled_cyber_car.stl"))

# Export 3MFs
export_3mf(p1, os.path.join(out_dir, "part1_lower_power_chassis.3mf"), "Part 1 - Lower Power Chassis")
export_3mf(p2, os.path.join(out_dir, "part2_electronics_mid_deck.3mf"), "Part 2 - Electronics Mid Deck")
export_3mf(p3, os.path.join(out_dir, "part3_cyber_armor_shell.3mf"), "Part 3 - Cyber Armor Shell")
export_3mf(p4, os.path.join(out_dir, "part4_quick_release_roof_canopy.3mf"), "Part 4 - Quick Release Roof Canopy")
export_3mf(assembled, os.path.join(out_dir, "assembled_cyber_car.3mf"), "Full Assembled Cyber Car")

# Plate 1: Chassis + Mid Deck (offset by Y=110mm)
plate1_p2 = Mesh3D()
setup_cyber_materials(plate1_p2)
for v in p2.vertices: plate1_p2.add_v(v[0], v[1] + 110.0, v[2] - 47.0 + 9.0) # shift flat
for v0, v1, v2, mat in p2.faces: plate1_p2.faces.append((v0, v1, v2, mat))
plate1 = combine_meshes([p1, plate1_p2])
export_3mf(plate1, os.path.join(out_dir, "bambu_plate1_chassis_and_deck.3mf"), "Plate 1 - Chassis and Electronics Deck")

# Plate 2: Shell + Roof Canopy (offset by Y=110mm)
plate2_p4 = Mesh3D()
setup_cyber_materials(plate2_p4)
for v in p4.vertices: plate2_p4.add_v(v[0], v[1] + 110.0, v[2] - 88.0 + 40.0)
for v0, v1, v2, mat in p4.faces: plate2_p4.faces.append((v0, v1, v2, mat))
plate2 = combine_meshes([p3, plate2_p4])
export_3mf(plate2, os.path.join(out_dir, "bambu_plate2_shell_and_roof.3mf"), "Plate 2 - Shell and Roof Canopy")

print("All STLs and 3MFs generated successfully!")
