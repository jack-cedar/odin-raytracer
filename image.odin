package main

import "core:fmt"
import "core:strings"
import "core:os"


Colour :: Vec3
Pixel :: distinct [3]u8
Pixels :: [dynamic]Pixel 
Image :: struct { 
    width, height: int,
    pixels: Pixels 
}

ColourToPixel :: proc(c: Colour) -> Pixel {
   return Pixel {
       u8(255 * c.r),
       u8(255 * c.g),
       u8(255 * c.b),
    }
}


NewImage :: proc (width, height: int) -> Image {
    pixels := make(Pixels, width * height)
    return Image{width, height, pixels}
}

WritePPM :: proc(i: Image, filepath: string) {
    header := fmt.aprintf("P3 %i %i \n255\n", i.width, i.height)
    sb : strings.Builder
    strings.builder_init(&sb)
    strings.write_string(&sb, header)
    for p in i.pixels {
	pixel := fmt.aprintf("%i %i %i\n", p.r, p.g, p.b)
	strings.write_string(&sb, pixel)
    }
    os.write_entire_file(filepath, sb.buf[:])
}
