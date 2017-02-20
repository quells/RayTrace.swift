import Foundation
import simd

func Lerp(from a: Float, to b: Float, by t: Float) -> Float {
    return t*b + (1-t)*a
}

func Lerp(from a: float3, to b: float3, by t: Float) -> float3 {
    return t*b + (1-t)*a
}

func reflect(v: float3, n: float3) -> float3 {
    return v - 2*dot(v, n)*n
}

func refract(v: float3, n: float3, iorr: Float) -> (didRefract: Bool, refractDirection: float3) {
    let dt = dot(v, n)
    let d = 1 - iorr*iorr*(1 - dt*dt)
    if d > 0 {
        let dir = iorr*(v - dt*n) - sqrt(d)*n
        return (true, dir)
    }
    return (false, float3())
}

func schlick(cosine: Float, ref: Float) -> Float {
    var r = (1 - ref) / (1 + ref)
    r = r*r
    return r + (1-r)*pow(1-cosine, 5)
}
