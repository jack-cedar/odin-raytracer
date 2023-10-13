package main

HitInfo :: struct {
    normal: Vec3,
    p: Point3,
    t: f64,
    front_face: bool
}


SetFaceNormal :: proc (info: ^HitInfo, ray: ^Ray, outward_normal: ^Vec3) {
    info.front_face = Dot(ray.direction, outward_normal^) < 0
    info.normal = info.front_face ? outward_normal^ : -outward_normal^
}

World :: struct {
    objects: [dynamic]Object,
}


Object :: union {
    Sphere
}

Collide :: proc(thing: Object ray: ^Ray, ray_tmin, ray_tmax: f64) -> Maybe(HitInfo)  {
    switch &t in thing {
    case Sphere: return SphereCollide(&t, ray, ray_tmin, ray_tmax)
	case: return nil
    }

}

DoCollisionsObjects :: proc(objects: ^[dynamic]Object, ray: ^Ray, ray_tmin, ray_tmax: f64) -> Maybe(HitInfo) {
    hit_somthing : bool
    closest : HitInfo
    closest.t = ray_tmax
    for thing in objects {
	info, ok := Collide(thing,  ray, ray_tmin, closest.t).?
	    if ok {
		hit_somthing = true
		closest = info
	    }
    }
    if hit_somthing do return closest
    else do return nil


}

DoCollisionsWorld :: proc(world: ^World, ray: ^Ray, ray_tmin, ray_tmax: f64) -> Maybe(HitInfo) {
    return DoCollisionsObjects(&world.objects, ray, ray_tmin, ray_tmax)
}



DoCollisions :: proc {DoCollisionsObjects, DoCollisionsWorld}

