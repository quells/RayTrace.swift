import simd

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
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        let scattered = Ray.RandomSphere(around: h.P)
        let att = albedo.colorFor(u: 0, v: 0, p: h.P)
        return ScatterResult(attenuation: att, scattered: scattered)
    }
}

public class NormLambertMaterial: LambertMaterial {
    init() {
        super.init(albedo: Texture())
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        guard var result = super.scatter(r: r, h: h) else { return nil }
        result.attenuation = 0.5 * (h.Normal + float3(1, 1, 1))
        return result
    }
}
