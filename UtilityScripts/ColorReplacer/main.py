import sys
from PIL import Image

COLOR_HI = 'c8c8c8ff'
COLOR_MID = '888888ff'
COLOR_LOW = '444444ff'

def main():
    if len(sys.argv) != 5:
        print('Usage: python3 main.py /path/to/image hex_color_hi hex_color_mid hex_color_low')
        sys.exit(1)

    path = sys.argv[1]
    hi = hex_to_rgba(sys.argv[2])
    mid = hex_to_rgba(sys.argv[3])
    low = hex_to_rgba(sys.argv[4])


    source = Image.open(path)
    width, height = source.size

    output = Image.new('RGBA', (width, height))

    source_hi = hex_to_rgba(COLOR_HI)
    source_mid = hex_to_rgba(COLOR_MID)
    source_low = hex_to_rgba(COLOR_LOW)

    for y in range(height):
        for x in range(width):
            pixel = source.getpixel((x, y))
            if pixel == source_hi:
                output.putpixel((x, y), hi)
            elif pixel == source_mid:
                output.putpixel((x, y), mid)
            elif pixel == source_low:
                output.putpixel((x, y), low)
            else:
                output.putpixel((x, y), pixel)

    output.save('out.png')

def hex_to_rgba(hex_color):
    r = int(hex_color[:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    a = int(hex_color[6:8], 16)
    return (r, g, b, a)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
