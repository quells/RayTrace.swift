import simd

public class ConstantVolume: Object {
    var boundary: Object
    var idensity: Float
    var shader: MaterialShader
    
    init(boundary: Object, density: Float, shader: MaterialShader) {
        self.boundary = boundary
        self.idensity = 1.0/density
        self.shader = shader
    }
    
    override public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        guard var rec1 = boundary.hit(r: r, near: near, far: far, rand: rand) else { return nil }
        guard var rec2 = boundary.hit(r: r, near: rec1.T+0.0001, far: far, rand: rand) else { return nil }
        if rec1.T < near { rec1.T = near }
        if rec2.T > far { rec2.far = far }
        if rec1.T >= rec2.T { return nil }
        if rec1.T < 0 { rec1.T = 0 }
        let rdl = length(r.direction)
        let dib = (rec2.T - rec1.T)*rdl
        let hd = -log(rand.uniform())*idensity
        if hd < dib {
            let T = rec1.T + hd/rdl
            let P = r.walk(T)
            let normal = float3(1,1,1) // arbitrary
            return HitRecord(T: T, near: near, far: far-T, u: 0, v: 0, P: P, Normal: normal, Material: shader)
        }
        return nil
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        return boundary.boundingBox(tmin, tmax)
    }
}
