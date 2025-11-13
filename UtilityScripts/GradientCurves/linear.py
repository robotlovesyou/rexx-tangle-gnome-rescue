from PIL import Image

# Create a new 1x256 grayscale ("L" mode) image
width, height = 256, 1
img = Image.new("L", (width, height))

# Fill with a vertical gradient from white (255) to black (0)
for x in range(width):
    # Linear interpolation: white (255) at y=0 → black (0) at y=255
    value = 255 - int((x / (width - 1)) * 255)
    img.putpixel((x, 0), value)

# Save to disk
img.save("gradient_256x1.png")

print("Saved gradient_256x1.png")
