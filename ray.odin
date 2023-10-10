package main

Ray :: struct {
    origin: Point3,
    direction : Vec3,
}

NewRay :: proc(origin: Point3, direction: Vec3) -> Ray {
    return Ray{origin, direction}
}
RayAt :: proc(ray: ^Ray, t: f64) -> Point3 {
    using ray
    return origin + t*direction
}
