import subprocess
import json

try:
    result = subprocess.run(['hyprctl', 'activewindow', '-j'], capture_output=True, text=True)
    output_json = json.loads(result.stdout)
    if output_json['fullscreen']:
        print("🔲")
    else:
        print("🪟")
except Exception as e:
    print(f"⁉️")
