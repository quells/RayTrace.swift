import simd

public class Rectangle: Object {
    let left: float2
    let right: float2
    let k: Float
    let shader: MaterialShader
    
    init(p: float3, width: Float, height: Float, shader: MaterialShader) {
        (self.left, self.k) = (float2(p.x, p.y), p.z)
        self.right = self.left + float2(width, height)
        self.shader = shader
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> HitRecord? {
        let t = (k - r.origin.z) / r.direction.z
        if t < near || t > far {
            return nil
        }
        let x = r.origin.x + t*r.direction.x
        let y = r.origin.y + t*r.direction.y
        if x < left.x || x > right.x || y < left.y || y > right.y {
            return nil
        }
        let u = (x - left.x) / (right.x - left.x)
        let v = (y - left.y) / (right.y - left.y)
        return HitRecord(T: t, near: near, far: far-t, u: u, v: v, P: r.walk(t), Normal: float3(0, 0, 1), Material: shader)
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        let low = float3(left.x, left.y, k-0.0001)
        let high = float3(right.x, right.y, k+0.0001)
        return AABB(min: low, max: high)
    }
}
