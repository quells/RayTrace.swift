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


