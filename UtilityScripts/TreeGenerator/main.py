from PIL import Image, ImageDraw
import random
import math
import time

# Configuration
total_width = 256
total_height = 512
body_width = 192

border_color    = (101, 67, 33)
base_color      = (139, 90, 43)
highlight_color = (180, 130, 70)
shadow_color    = (70, 40, 10)

# How many pixels at top and bottom to ramp the envelope to zero
SEAM_MARGIN = 12

def point_in_circle(px, py, cx, cy, r):
    return (px - cx) ** 2 + (py - cy) ** 2 < r * r

def seam_envelope(y, total_height, margin):
    """Linear ramp: 0 at edges, 1 once past the margin."""
    if y < margin:
        return y / margin
    if y > total_height - 1 - margin:
        return (total_height - 1 - y) / margin
    return 1.0

def deflect_around_circles(nominal_x, y, origin_x, circles, influence_factor=4.0):
    result = float(nominal_x)
    for cx, cy, r in circles:
        dy = y - cy
        influence_radius = r * influence_factor
        if abs(dy) > influence_radius:
            continue
        dist = math.sqrt((nominal_x - cx) ** 2 + dy * dy)
        if dist >= influence_radius:
            continue
        t = 1.0 - (dist / influence_radius)
        t = t * t * (3 - 2 * t)
        half_chord = math.sqrt(max(0.0, r * r - dy * dy))
        if origin_x < cx:
            target_x = cx - half_chord - 1
            deflected = result + (target_x - result) * t
            result = min(result, deflected)
        else:
            target_x = cx + half_chord + 1
            deflected = result + (target_x - result) * t
            result = max(result, deflected)
    return result

def generate_meandering_offset(y, amplitude, frequency, phase1, phase2, phase3, total_height):
    envelope = seam_envelope(y, total_height, SEAM_MARGIN)
    return envelope * (
        amplitude        * math.sin(y * frequency       + phase1) +
        amplitude * 0.5  * math.sin(y * frequency * 2.3 + phase2) +
        amplitude * 0.25 * math.sin(y * frequency * 0.7 + phase3)
    )

def generate_meandering_path(y_start, y_end, x, amplitude, frequency, rng, left, right, total_height, circles=None):
    points = []
    phase1 = rng.uniform(0, math.pi * 2)
    phase2 = rng.uniform(0, math.pi * 2)
    phase3 = rng.uniform(0, math.pi * 2)
    for y in range(y_start, y_end + 1):
        nominal = x + generate_meandering_offset(y, amplitude, frequency, phase1, phase2, phase3, total_height)
        if circles:
            nominal = deflect_around_circles(nominal, y, x, circles)
        px = max(left, min(right, int(nominal)))
        points.append((px, y))
    return points

def generate_meandering_path_dynamic(y_start, y_end, x, amplitude, frequency, rng, left_xs, right_xs, total_height, circles=None):
    points = []
    phase1 = rng.uniform(0, math.pi * 2)
    phase2 = rng.uniform(0, math.pi * 2)
    phase3 = rng.uniform(0, math.pi * 2)
    for y in range(y_start, y_end + 1):
        nominal = x + generate_meandering_offset(y, amplitude, frequency, phase1, phase2, phase3, total_height)
        if circles:
            nominal = deflect_around_circles(nominal, y, x, circles)
        px = max(left_xs[y] + 1, min(right_xs[y] - 2, int(nominal)))
        points.append((px, y))
    return points

def generate_tree(total_width, total_height, body_width,
                  border_color, base_color, highlight_color, shadow_color,
                  ridge_spacing=18, amplitude=8, border_amplitude=2, seed=42,
                  output_path="out.png"):

    rng = random.Random(seed)
    img = Image.new("RGBA", (total_width, total_height), (0, 0, 0, 0))

    left  = (total_width - body_width) // 2
    right = left + body_width - 1

    border_frequency = rng.uniform(0.02, 0.04)
    left_border  = generate_meandering_path(0, total_height - 1, left,  border_amplitude, border_frequency, rng, left - border_amplitude, left + border_amplitude, total_height)
    border_frequency = rng.uniform(0.02, 0.04)
    right_border = generate_meandering_path(0, total_height - 1, right, border_amplitude, border_frequency, rng, right - border_amplitude, right + border_amplitude, total_height)

    left_x  = [px for px, y in left_border]
    right_x = [px for px, y in right_border]

    num_circles = rng.randint(2, 4)
    circles = []
    margin = total_height // 6
    while len(circles) < num_circles:
        r = rng.randint(6, 14)
        cx = rng.randint(left + r + 2, right - r - 2)
        cy = rng.randint(margin + r, total_height - margin - r)
        collides = False
        for circle in circles:
            hyp = math.sqrt((cx - circle[0]) ** 2 + (cy - circle[1]) ** 2)
            if hyp <= r + circle[2]:
                collides = True
        if not collides:
            circles.append((cx, cy, r))

    for y in range(total_height):
        lx = left_x[y]
        rx = right_x[y]
        for x in range(lx + 1, rx):
            img.putpixel((x, y), base_color + (255,))

    draw = ImageDraw.Draw(img)
    for cx, cy, r in circles:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=base_color + (255,), outline=border_color + (255,))

    x = left + ridge_spacing
    while x < right:
        frequency = rng.uniform(0.04, 0.08)
        highlight_pts = generate_meandering_path_dynamic(
            0, total_height - 1, x, amplitude, frequency, rng, left_x, right_x, total_height, circles
        )
        shadow_pts = [(min(px + 1, right_x[y] - 1), y) for px, y in highlight_pts]

        for px, y in shadow_pts:
            if not any(point_in_circle(px, y, cx, cy, r) for cx, cy, r in circles):
                img.putpixel((px, y), shadow_color + (255,))
        for px, y in highlight_pts:
            if not any(point_in_circle(px, y, cx, cy, r) for cx, cy, r in circles):
                img.putpixel((px, y), highlight_color + (255,))

        x += ridge_spacing

    draw = ImageDraw.Draw(img)
    for cx, cy, r in circles:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=None, outline=border_color + (255,))

    for px, y in left_border:
        img.putpixel((px, y), border_color + (255,))
    for px, y in right_border:
        img.putpixel((px, y), border_color + (255,))

    img.save(output_path)
    print(f"Saved to {output_path}")

base_name = 'TreeTrunk'
for i in range(1,11):
    generate_tree(
        total_width, total_height, body_width,
        border_color, base_color, highlight_color, shadow_color,
        ridge_spacing=18,
        amplitude=4,
        border_amplitude=2,
        seed=int(time.time_ns()),
        output_path='{}{}.png'.format(base_name, i),
)