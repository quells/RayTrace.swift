import Foundation
import simd

public class Sphere: Object {
    let center: float3
    let radius: Float
    let shader: MaterialShader
    
    init(center: float3, radius: Float, shader: MaterialShader) {
        self.center = center
        self.radius = radius
        self.shader = shader
    }
    
    init(x: Float, y: Float, z: Float, r: Float, shader: MaterialShader) {
        self.center = float3(x, y, z)
        self.radius = r
        self.shader = shader
    }
    
    private func uvFor(_ p: float3) -> (u: Float, v: Float) {
        let r = normalize(p - center)
        let phi: Float = sin(r[1])
        let theta: Float = atan2(r[2], r[0])
        let u: Float = 0.5 - theta*Float(M_2_PI)
        let v: Float = 0.5 + phi*Float(M_1_PI)
        return (u, v)
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> (ditHit: Bool, record: HitRecord) {
        let oc = r.origin - center
        let a = length_squared(r.direction)
        let b = dot(oc, r.direction)
        let c = length_squared(oc) - radius*radius
        let d = b*b - a*c
        if d > 0 {
            var x = (-b - sqrt(d)) / a
            if x < near || x > far {
                x = (-b + sqrt(d)) / a
                if x < near || x > far {
                    return (false, HitRecord())
                }
            }
            let p = r.walk(x)
            let normal = (p - center) * (1.0/radius)
            let (u, v) = uvFor(p)
            return (true, HitRecord(T: x, near: near, far: far, u: u, v: v, P: p, Normal: normal, Material: shader))
        }
        return (false, HitRecord())
    }
}
