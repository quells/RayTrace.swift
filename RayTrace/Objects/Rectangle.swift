import simd

public class Rectangle: Object {
    let width, height: Float
    let k: Float
    let shader: MaterialShader
    
    init(width: Float, height: Float, k: Float, shader: MaterialShader) {
        (self.width, self.height, self.k) = (width, height, k)
        self.shader = shader
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> HitRecord? {
        let t = (k - r.origin.z) / r.direction.z
        if t < near || t > far {
            return nil
        }
        let x = r.origin.x + t*r.direction.x
        let y = r.origin.y + t*r.direction.y
        if x < 0 || x > width || y < 0 || y > height {
            return nil
        }
        let u = x / width
        let v = y / height
        return HitRecord(T: t, near: near, far: far-t, u: u, v: v, P: r.walk(t), Normal: float3(0, 0, 1), Material: shader)
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        let low = float3(0, 0, k-0.0001)
        let high = float3(width, height, k+0.0001)
        return AABB(min: low, max: high)
    }
}
