import simd

public class GlassMaterial: MaterialShader {
    var albedo: Texture
    var IOR: Float
    
    init(albedo: Texture, IOR: Float) {
        self.albedo = albedo
        self.IOR = IOR
    }
    
    convenience init(r: Float, g: Float, b: Float, IOR: Float) {
        self.init(albedo: ConstantTexture(r: r, g: g, b: b), IOR: IOR)
    }
    
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        let reflectedDir = reflect(v: r.direction, n: h.Normal)
        let att = albedo.colorFor(u: 0, v: 0, p: h.P)
        let outwardNormal: float3
        let (iorr, cosine): (Float, Float)
        let dp = dot(r.direction, h.Normal)
        if dp > 0 {
            outwardNormal = -h.Normal
            iorr = IOR
            cosine = IOR * dp
        } else {
            outwardNormal = h.Normal
            iorr = 1.0/IOR
            cosine = -dp
        }
        let (didRefract, refractDirection) = refract(v: r.direction, n: outwardNormal, iorr: iorr)
        var reflectProb: Float
        if didRefract {
            reflectProb = schlick(cosine: cosine, ref: IOR)
        } else {
            reflectProb = 1
        }
        var scatteredRay: Ray
        if Squall.uniform() < reflectProb {
            scatteredRay = Ray(origin: h.P, direction: reflectedDir)
        } else {
            scatteredRay = Ray(origin: h.P, direction: refractDirection)
        }
        return ScatterResult(attenuation: att, scattered: scatteredRay)
    }
}
