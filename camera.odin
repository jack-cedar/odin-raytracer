package main
import "core:fmt"
import "core:math"



Camera :: struct {
    center: Point3,

    focal_length,
    aspect_ratio,
    viewport_width,
    viewport_height: f64,
   
    lr, tb,
    upper_left,
    pixel00_loc,
    pixel_delta_lr,
    pixel_delta_tb: Vec3,

    image: Image,
}

NewCamera :: proc(image_width: int, focal_length,  aspect_ratio: f64,  center: Point3) -> (camera: Camera) {
    camera.focal_length = focal_length
    camera.aspect_ratio = aspect_ratio
    camera.center = center
    using camera
    viewport_width = 2
    viewport_height = (viewport_width / aspect_ratio)
    lr = Vec3{viewport_width, 0, 0}
    tb = Vec3{0, -viewport_height, 0}
    upper_left = center - Vec3{0, 0, focal_length} - lr/2 - tb/2

    image = NewImage(image_width, int(f64(image_width) / aspect_ratio))
    pixel_delta_lr = camera.lr / f64(image.width)
    pixel_delta_tb = camera.tb / f64(image.height)
    pixel00_loc = upper_left + 0.5 * (pixel_delta_lr + pixel_delta_tb)

    return camera
}


RayColour :: proc(objects: ^[dynamic]Object, ray: ^Ray) -> Colour {
    info, ok := DoCollisions(objects, ray, 0, math.F64_MAX).?
    if ok {
	return 0.5 * (info.normal + Colour{1.0, 1.0, 1.0})
    }
    unit_direction := UnitVector(ray.direction)
    a := 0.5*(unit_direction.y + 1.0)
    
    return (1-a)*Colour{1.0, 1.0, 1.0} + a*Colour{0.5, 0.7, 1.0}
}

Render :: proc(camera: ^Camera) -> ^Image {
    using camera
    
    for row in 0..<image.height {
	fmt.print("\rRows Remaining:", image.height - row, "   ")
	for col in 0..<image.width {
	    pixel_center := pixel00_loc + (f64(col) * pixel_delta_lr) + (f64(row) * pixel_delta_tb)
	    ray_direction := pixel_center - camera.center
	    ray := NewRay(camera.center, ray_direction)
	    colour := RayColour(&world, &ray)
	    image.pixels [row * image.width + col] = ColourToPixel(colour)
	  
	}
    }
    fmt.printf("\rFinished rendering image %ix%i", image.width, image.height)
    return &camera.image
}

