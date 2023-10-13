package main
import "core:fmt"
import "core:io"
import "core:math"



world := [dynamic]Object {
    Sphere{Point3{0, 0, -1}, 0.5},
    Sphere{Point3{-1.5, 1, -2}, 0.4},
    Sphere{Point3{0, -100.5, -1}, 100},
}

main :: proc() {    
    camera := NewCamera(800, 1.0, (4.0 / 3.0), Point3{0, 0, 0} )
   
    Render(&camera)
    WritePPM(camera.image, "image.ppm")
}

