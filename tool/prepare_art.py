#!/usr/bin/env python3
"""Draws the tiles of the garden: leaves, open ground and the numbers.

Usage: tool/prepare_art.py [folder with cat.jpeg and feather.jpeg]

The numbers are images, like the cards of the other games, because text drawn
in real time looks jagged on Linux. Everything is drawn four times bigger and
reduced at the end.
"""
import random
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "tiles"
FONT = ROOT / "assets" / "fonts" / "CardSerif-Bold.ttf"
SIZE = 128
SCALE = 4
BIG = SIZE * SCALE

NUMBERS = {
    1: (46, 104, 168),
    2: (54, 128, 74),
    3: (196, 62, 52),
    4: (84, 60, 150),
    5: (150, 72, 36),
    6: (30, 128, 130),
    7: (70, 62, 74),
    8: (130, 120, 112),
}


def rounded_mask(inset: int, radius: int) -> Image.Image:
    mask = Image.new("L", (BIG, BIG), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (inset, inset, BIG - inset - 1, BIG - inset - 1), radius, fill=255
    )
    return mask


def speckle(rng: random.Random, strength: int) -> Image.Image:
    small = Image.new("L", (BIG // 8, BIG // 8))
    small.putdata([128 + rng.randint(-strength, strength) for _ in range(small.width**2)])
    return small.resize((BIG, BIG), Image.BICUBIC).filter(ImageFilter.GaussianBlur(4))


def textured(colour, rng: random.Random, strength: int = 16) -> Image.Image:
    grain = speckle(rng, strength).convert("RGB")
    return ImageChops.overlay(Image.new("RGB", (BIG, BIG), colour), grain)


def finish(img: Image.Image, name: str) -> None:
    img.resize((SIZE, SIZE), Image.LANCZOS).save(OUT / f"{name}.png", optimize=True)


def leaf() -> None:
    rng = random.Random(7)
    base = textured((122, 158, 96), rng).convert("RGBA")
    draw = ImageDraw.Draw(base)
    mid = BIG // 2
    vein = (92, 128, 72, 255)
    # A soft leaf drawn over the whole tile: the central vein and its branches.
    draw.line((BIG * .14, BIG * .86, BIG * .86, BIG * .14), fill=vein, width=10)
    for t in (.3, .45, .6, .75):
        x, y = BIG * (.14 + .72 * t), BIG * (.86 - .72 * t)
        length = BIG * .17
        draw.line((x, y, x - length, y - length * .25), fill=vein, width=6)
        draw.line((x, y, x + length * .25, y + length), fill=vein, width=6)
    light = Image.new("L", (BIG, BIG), 0)
    ImageDraw.Draw(light).ellipse((-mid // 2, -mid // 2, mid + mid // 3, mid + mid // 3), fill=70)
    light = light.filter(ImageFilter.GaussianBlur(60))
    base = Image.composite(Image.new("RGBA", (BIG, BIG), (236, 240, 190, 255)), base, light)
    tile = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    tile.paste(base, (0, 0), rounded_mask(10, 44))
    edge = ImageDraw.Draw(tile)
    edge.rounded_rectangle((10, 10, BIG - 11, BIG - 11), 44, outline=(74, 104, 60, 255), width=8)
    finish(tile, "leaf")


def ground(name: str, colour) -> None:
    tile = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    tile.paste(textured(colour, random.Random(3), 9).convert("RGBA"), (0, 0), rounded_mask(6, 24))
    finish(tile, name)


def number(value: int, colour) -> None:
    img = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    font = ImageFont.truetype(str(FONT), int(BIG * .66))
    ImageDraw.Draw(img).text((BIG / 2, BIG / 2), str(value), font=font, fill=(*colour, 255), anchor="mm")
    finish(img, str(value))


def wrong() -> None:
    img = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    colour = (198, 52, 44, 235)
    a, b = BIG * .2, BIG * .8
    draw.line((a, a, b, b), fill=colour, width=30)
    draw.line((a, b, b, a), fill=colour, width=30)
    finish(img, "wrong")


def cat() -> None:
    """A cat drawn by hand, for when there is no illustration to use."""
    img = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    line = (94, 56, 34, 255)
    fur = (236, 150, 66, 255)
    light = (250, 224, 186, 255)
    w = 14
    u = BIG / 100
    for side in (1, -1):
        ear = [(50 + side * 40, 8), (50 + side * 12, 34), (50 + side * 42, 48)]
        d.polygon([(x * u, y * u) for x, y in ear], fill=fur, outline=line, width=w)
        inner = [(50 + side * 36, 19), (50 + side * 20, 34), (50 + side * 37, 42)]
        d.polygon([(x * u, y * u) for x, y in inner], fill=(244, 170, 150, 255))
    d.ellipse((10 * u, 22 * u, 90 * u, 92 * u), fill=fur, outline=line, width=w)
    d.ellipse((30 * u, 58 * u, 70 * u, 90 * u), fill=light)
    for x in (42, 50, 58):
        d.polygon([((x - 4) * u, 23 * u), ((x + 4) * u, 23 * u), (x * u, 40 * u)], fill=(198, 106, 40, 255))
    for side in (1, -1):
        cx = 50 + side * 18
        d.ellipse(((cx - 10) * u, 44 * u, (cx + 10) * u, 66 * u), fill=(250, 244, 214, 255), outline=line, width=8)
        d.ellipse(((cx - 6) * u, 48 * u, (cx + 6) * u, 65 * u), fill=(38, 34, 40, 255))
        d.ellipse(((cx - 3) * u, 50 * u, (cx + 2) * u, 56 * u), fill=(255, 255, 255, 255))
        for dy in (-3, 4):
            d.line(((50 + side * 26) * u, 72 * u, (50 + side * 47) * u, (72 + dy * 2) * u), fill=line, width=7)
    d.polygon([(45 * u, 67 * u), (55 * u, 67 * u), (50 * u, 74 * u)], fill=(214, 96, 92, 255))
    d.arc((38 * u, 68 * u, 50 * u, 84 * u), 20, 160, fill=line, width=9)
    d.arc((50 * u, 68 * u, 62 * u, 84 * u), 20, 160, fill=line, width=9)
    finish(img, "cat")


def feather() -> None:
    """A yellow feather, drawn over its curved spine."""
    img = Image.new("RGBA", (BIG, BIG), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    line = (112, 84, 42, 255)
    points = []
    for t in range(0, 41):
        v = t / 40
        points.append((BIG * (.24 + .54 * v + .08 * (1 - (2 * v - 1) ** 2)), BIG * (.86 - .72 * v)))
    left, right = [], []
    for i, (x, y) in enumerate(points[6:], 6):
        v = (i - 6) / 34
        half = BIG * .2 * (1 - (2 * v - 1) ** 2) ** .55
        left.append((x - half * .86, y - half * .5))
        right.append((x + half * .86, y + half * .5))
    outline = left + right[::-1]
    d.polygon(outline, fill=(250, 208, 76, 255))
    d.line(outline + outline[:1], fill=line, width=10, joint="curve")
    for i in range(10, 36, 4):
        x, y = points[i]
        for side in (-1, 1):
            d.line((x, y, x + side * BIG * .1, y - BIG * .02 * side + BIG * .03), fill=(214, 164, 50, 255), width=6)
    d.line(points, fill=line, width=12, joint="curve")
    finish(img, "feather")


def cutout(path: Path, threshold: int = 34) -> Image.Image:
    """Removes the plain background connected to the borders of the drawing."""
    img = Image.open(path).convert("RGB")
    flood = img.copy()
    w, h = img.size
    marker = (255, 0, 255)
    for x in range(0, w, 8):
        for y in (0, h - 1):
            if flood.getpixel((x, y)) != marker:
                ImageDraw.floodfill(flood, (x, y), marker, thresh=threshold)
    for y in range(0, h, 8):
        for x in (0, w - 1):
            if flood.getpixel((x, y)) != marker:
                ImageDraw.floodfill(flood, (x, y), marker, thresh=threshold)
    mask = Image.eval(ImageChops.difference(flood, Image.new("RGB", (w, h), marker)).convert("L"), lambda v: 255 if v > 8 else 0)
    mask = mask.filter(ImageFilter.MinFilter(5)).filter(ImageFilter.GaussianBlur(1.2))
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out.crop(mask.getbbox())


def placed(source: Path, name: str, fill: float) -> None:
    art = cutout(source)
    side = int(SIZE * fill)
    ratio = side / max(art.size)
    art = art.resize((max(1, round(art.width * ratio)), max(1, round(art.height * ratio))), Image.LANCZOS)
    tile = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    tile.alpha_composite(art, ((SIZE - art.width) // 2, (SIZE - art.height) // 2))
    tile.save(OUT / f"{name}.png", optimize=True)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    leaf()
    ground("open", (232, 220, 190))
    ground("caught", (226, 114, 91))
    for value, colour in NUMBERS.items():
        number(value, colour)
    wrong()
    cat()
    feather()
    if len(sys.argv) > 1:
        art = Path(sys.argv[1])
        placed(art / "gato.jpeg", "cat", .84)
        placed(art / "pena.jpeg", "feather", .78)


if __name__ == "__main__":
    main()
