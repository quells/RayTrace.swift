import simd

public struct ScatterResult {
    var attenuation: float3
    var scattered: Ray
}

public class MaterialShader {
    func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        return nil
    }
}

public class MixedMaterial: MaterialShader {
    var a: MaterialShader
    var b: MaterialShader
    var t: Float
    
    init(_ a: MaterialShader, _ b: MaterialShader, ratio: Float) {
        (self.a, self.b, self.t) = (a, b, ratio)
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        if Squall.uniform() < t {
            return a.scatter(r: r, h: h)
        }
        return b.scatter(r: r, h: h)
    }
}
