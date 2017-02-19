import Foundation
import simd

public struct ScatterResult {
    var didScatter: Bool
    var attenuation: float3
    var scattered: Ray
}

public class MaterialShader {
    func scatter(r: Ray, h: HitRecord) -> ScatterResult {
        return ScatterResult(didScatter: false, attenuation: float3(), scattered: Ray())
    }
}

public class LambertMaterial: MaterialShader {
    var albedo: Texture
    
    init(albedo: Texture) {
        self.albedo = albedo
    }
    
    convenience init(color: float3) {
        self.init(albedo: ConstantTexture(color))
    }
    
    convenience init(r: Float, g: Float, b: Float) {
        self.init(albedo: ConstantTexture(r: r, g: g, b: b))
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult {
        let scattered = Ray.RandomSphere(around: h.P)
        let att = albedo.colorFor(u: 0, v: 0, p: h.P)
        return ScatterResult(didScatter: true, attenuation: att, scattered: scattered)
    }
}

public class NormLambertMaterial: LambertMaterial {
    init() {
        super.init(albedo: Texture())
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult {
        var result = super.scatter(r: r, h: h)
        result.attenuation = 0.5 * (h.Normal + float3(1, 1, 1))
        return result
    }
}
