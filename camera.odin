package main

Point3 :: Vec3

Camera :: struct {
    focal_length: f64,
    center: Point3,
    width, height: f64,
    lr, tb,
    upper_left: Vec3
    
}

NewCamera :: proc(focal_length, width, height,: f64, center: Point3) -> Camera {
    lr := Vec3{width, 0, 0}
    tb := Vec3{0, -height, 0}
    return Camera {
	focal_length,
	center,
	width, height,
	lr, tb,
	center - Vec3{0, 0, focal_length} - lr/2 - tb/2
	
    }
}
