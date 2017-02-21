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

public class CheckeredMaterial: MaterialShader {
    let even: MaterialShader
    let odd: MaterialShader
    let scale: Float
    
    init(even: MaterialShader, odd: MaterialShader, scale: Float = 10) {
        (self.even, self.odd, self.scale) = (even, odd, scale)
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        let sines = sin(scale*h.P.x) * sin(scale*h.P.y) * sin(scale*h.P.z)
        if sines > 0 {
            return even.scatter(r: r, h: h)
        }
        return odd.scatter(r: r, h: h)
    }
}
