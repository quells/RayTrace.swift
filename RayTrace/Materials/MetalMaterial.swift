import simd

public class MetalMaterial: MaterialShader {
    var albedo: Texture
    var roughness: Float
    
    init(albedo: Texture, roughness: Float) {
        self.albedo = albedo
        self.roughness = roughness
    }
    
    convenience init(r: Float, g: Float, b: Float, roughness: Float) {
        self.init(albedo: ConstantTexture(r: r, g: g, b: b), roughness: roughness)
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        var reflection = reflect(v: normalize(r.direction), n: h.Normal)
        if roughness > 0 {
            reflection += roughness*Ray.RandomSphere().direction
            reflection = normalize(reflection)
        }
        let reflected = Ray(origin: h.P, direction: reflection)
        let att = albedo.colorFor(u: 0, v: 0, p: h.P)
        if dot(reflection, h.Normal) < 0 { return nil }
        return ScatterResult(attenuation: att, scattered: reflected)
    }
}
