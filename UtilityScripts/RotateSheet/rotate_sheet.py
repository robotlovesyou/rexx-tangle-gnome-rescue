import sys
from PIL import Image

def main():
    if len(sys.argv) != 5:
        print("Usage: python rotate_sprite_sheet.py <path_to_png> <h_frames> <v_frames> <rotation_factor>")
        sys.exit(1)

    path = sys.argv[1]
    h_frames = int(sys.argv[2])
    v_frames = int(sys.argv[3])
    rotation_factor = int(sys.argv[4])

    if rotation_factor < 0 or rotation_factor > 3:
        print("Error: rotation_factor must be between 0 and 3 (0, 1, 2, 3 represent multiples of PI/2).")
        sys.exit(1)

    # Load the sheet
    sheet = Image.open(path)
    width, height = sheet.size

    frame_w = width // h_frames
    frame_h = height // v_frames

    # Create output sheet (same size)
    output = Image.new("RGBA", (width, height))

    # Compute rotation in degrees (PI/2 increments)
    rotation_degrees = rotation_factor * 90  # because 90° = π/2

    for y in range(v_frames):
        for x in range(h_frames):
            # Extract frame
            box = (x * frame_w, y * frame_h, (x + 1) * frame_w, (y + 1) * frame_h)
            frame = sheet.crop(box)

            # Rotate (expand=False keeps the cell size fixed)
            rotated = frame.rotate(rotation_degrees, expand=False)

            # Paste back into correct position
            output.paste(rotated, box)

    # Save output
    output_path = path.replace(".png", "_rotated.png")
    output.save(output_path)

    print(f"Saved rotated sprite sheet to: {output_path}")


if __name__ == "__main__":
    main()
