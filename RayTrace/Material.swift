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

//public class NormLambertMaterial: MaterialShader {
//    override func scatter(r: Ray, h: HitRecord) -> ScatterResult {
//        let att = 0.5 * (h.Normal + float3(1, 1, 1))
//        let scattered =
//    }
//}
