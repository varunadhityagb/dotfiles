#!/usr/bin/python3

#!/usr/bin/env python3

import json
import os
import sys

def generate_clipse_theme(pywal_colors_path, output_path=None):
    """
    Generate a Clipse custom_theme.json based on pywal16 colors.json

    Maps specific pywal color indices to Clipse theme elements
    """
    try:
        # Read pywal colors.json file
        with open(pywal_colors_path, 'r') as f:
            pywal_data = json.load(f)

        # Create mapping from pywal colors to Clipse theme elements
        mapping = {
            "TitleFore": pywal_data["special"]["foreground"],
            "TitleBack": pywal_data["colors"]["color1"],
            "TitleInfo": pywal_data["colors"]["color4"],
            "NormalTitle": pywal_data["special"]["foreground"],
            "DimmedTitle": pywal_data["colors"]["color8"],
            "SelectedTitle": pywal_data["colors"]["color5"],
            "NormalDesc": pywal_data["colors"]["color8"],
            "DimmedDesc": pywal_data["colors"]["color2"],
            "SelectedDesc": pywal_data["colors"]["color6"],
            "StatusMsg": pywal_data["colors"]["color3"],
            "PinIndicatorColor": pywal_data["colors"]["color6"],
            "SelectedBorder": pywal_data["colors"]["color4"],
            "SelectedDescBorder": pywal_data["colors"]["color4"],
            "FilteredMatch": pywal_data["special"]["foreground"],
            "FilterPrompt": pywal_data["colors"]["color3"],
            "FilterInfo": pywal_data["colors"]["color4"],
            "FilterText": pywal_data["special"]["foreground"],
            "FilterCursor": pywal_data["colors"]["color6"],
            "HelpKey": pywal_data["colors"]["color8"],
            "HelpDesc": pywal_data["colors"]["color2"],
            "PageActiveDot": pywal_data["colors"]["color5"],
            "PageInactiveDot": pywal_data["colors"]["color2"],
            "DividerDot": pywal_data["colors"]["color4"],
            "PreviewedText": pywal_data["special"]["foreground"],
            "PreviewBorder": pywal_data["colors"]["color1"]
        }

        # Create the Clipse theme
        clipse_theme = {"useCustomTheme": True}
        clipse_theme.update(mapping)

        # Output the theme
        if output_path:
            with open(output_path, 'w') as f:
                json.dump(clipse_theme, f, indent=4)
            print(f"Theme saved to {output_path}")
        else:
            print(json.dumps(clipse_theme, indent=4))

        return True

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_clipse_theme.py /path/to/colors.json [/path/to/output/custom_theme.json]")
        sys.exit(1)

    pywal_colors_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else None

    success = generate_clipse_theme(pywal_colors_path, output_path)
    sys.exit(0 if success else 1)
