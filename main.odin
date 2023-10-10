package main
import "core:fmt"
import "core:io"
import "core:math"

sphere_collide :: proc(center: Point3, radius: f64, ray: ^Ray) -> f64 {
    oc := ray.origin - center
    a := LengthSquared(ray.direction)
    half_b := Dot(oc, ray.direction)
    c :=  LengthSquared(oc) - radius*radius
    d := half_b*half_b - a*c
   
    if d < 0 do return -1
    else do return (-half_b - math.sqrt(d)) /  a
}

RayColour :: proc(ray: ^Ray) -> Colour {
    t := sphere_collide(Vec3{0, 0, -1}, 0.5, ray)
    if t > 0 {
	N := UnitVector(RayAt(ray, t) - Vec3{0, 0, -1})
	return 0.5*Colour{N.x+1, N.y+1, N.z+1}
    }
   
    
    unit_direction := UnitVector(ray.direction)
    a := 0.5*(unit_direction.y + 1.0)
    return (1-a)*Colour{1.0, 1.0, 1.0} + a*Colour{0.5, 0.7, 1.0}
}



Render :: proc(img: ^Image, camera: ^Camera) {
    pixel_delta_lr := camera.lr / f64(img.width)
    pixel_delta_tb := camera.tb / f64(img.height)
    pixel00_loc := camera.upper_left + 0.5 * (pixel_delta_lr + pixel_delta_tb)
      
    for row in 0..<img.height {
	fmt.print("\rRows Remaining:", img.height - row, "   ")
	for col in 0..<img.width {
	    pixel_center := pixel00_loc + (f64(col) * pixel_delta_lr) + (f64(row) * pixel_delta_tb)
	    ray_direction := pixel_center - camera.center
	    ray := NewRay(camera.center, ray_direction)
	    colour := RayColour(&ray)
	    img.pixels [row * img.width + col] = ColourToPixel(colour)
	  
	}
    }
    fmt.print("\rRows Remaining: 0   ")
}



main :: proc() {    
    aspect_ratio :: 4.0 / 3.0
    image_width :: 800
    image_height :: (image_width / aspect_ratio)
    assert(image_height > 1)

    img := NewImage(image_width, image_height)
    camera := NewCamera(1.0, 3.0, 1.75 * (image_width / image_height), Point3{0, 0, 0} )
    Render(&img, &camera)
    WritePPM(img, "image.ppm")
}

