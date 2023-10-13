package main
import "core:math"

Sphere :: struct {
    center: Point3,
    radius: f64,
}
NewSphere :: proc(center: Point3, radius: f64) -> Sphere {
    return Sphere {center, radius}
}

SphereCollide :: proc (sphere: ^Sphere, ray: ^Ray, ray_tmin, ray_tmax: f64) -> Maybe(HitInfo) {
    using sphere
    oc := ray.origin - center
    a := LengthSquared(ray.direction)
    half_b := Dot(oc, ray.direction)
    c :=  LengthSquared(oc) - radius*radius
    discriminant := half_b*half_b - a*c
    if discriminant < 0 do return nil

    
    sqrtd :=math.sqrt(discriminant)

    root := (-half_b - sqrtd) / a

    if root <= ray_tmin || ray_tmax <= root {
	root := (-half_b + sqrtd) / a
	if root <= ray_tmin || ray_tmax <= root do return nil
    }
    info : HitInfo
    info.t = root
    info.p = RayAt(ray, info.t)
    outward_normal := (info.p - center) / radius
    SetFaceNormal(&info, ray, &outward_normal)
 
    return info
}

