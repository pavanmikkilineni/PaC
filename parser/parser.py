import hcl2
import json
import sys

def hcl2_to_json(filepath):
    """Parses an HCL file and converts it to JSON."""
    try:
        with open(filepath, 'r') as file:
            hcl_data = hcl2.load(file)
        # Convert the HCL data (Python dict) to JSON
        json_data = json.dumps(hcl_data, indent=4)
        return json_data
    except Exception as e:
        print(f"Error parsing {filepath}: {e}")
        return None

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python hcl2_to_json.py <file_path>")
    else:
        filepath = sys.argv[1]
        json_output = hcl2_to_json(filepath)
        if json_output:
            print(json_output)
