import re
from pathlib import Path

# Input: Matugen color file
input_path = Path("/home/varunadhityagb/dotfiles/.config/waybar/colors.css")

# Output: CSS variables for Stylus
output_path = Path("/home/varunadhityagb/.cache/matugen-vars.css")

# Read and convert
css_vars = []
with input_path.open("r") as f:
    for line in f:
        match = re.match(r'\s*@define-color\s+([\w-]+)\s+(#[0-9a-fA-F]{6});', line)
        if match:
            name, color = match.groups()
            css_vars.append(f"  --{name}: {color};")

# Write :root block
root_block = ":root {\n" + "\n".join(css_vars) + "\n}"

with output_path.open("w") as f:
    f.write(root_block)

print(f"✅ Generated: {output_path}")
