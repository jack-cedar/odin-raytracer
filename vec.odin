package main

import "core:math"

Vec3 :: [3]f64

Dot :: proc(a, b: Vec3) -> f64 {
    return a.x * b.x + a.y * b.y + a.z * b.z
}

LengthSquared :: proc(v: Vec3) -> f64 {
    return v.x * v.x + v.y * v.y + v.z * v.z
}
Length :: proc(v: Vec3) -> f64 {
    return math.sqrt(LengthSquared(v)) 
}
UnitVector :: proc(vec: Vec3) -> Vec3 {
    return vec / Length(vec)
}

