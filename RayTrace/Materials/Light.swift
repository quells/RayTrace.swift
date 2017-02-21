import simd

public class LightShader: MaterialShader {
    override func scatter(r: Ray, h: HitRecord) -> ScatterResult? {
        return nil
    }
    
    func emit(u: Float, v: Float, p: float3) -> float3 {
        return float3()
    }
}

public class DiffuseLight: LightShader {
    var emitted: Texture
    
    init(emit: Texture) {
        self.emitted = emit
    }
    
    convenience init(r: Float, g: Float, b: Float) {
        self.init(emit: ConstantTexture(r: r, g: g, b: b))
    }
    
    override func emit(u: Float, v: Float, p: float3) -> float3 {
        return emitted.colorFor(u: u, v: v, p: p)
    }
}
