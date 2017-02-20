import simd

public class Texture {
    func colorFor(u: Float, v: Float, p: float3) -> float3 {
        return float3()
    }
}

public class ConstantTexture: Texture {
    let constant: float3
    
    init(_ constant: float3) {
        self.constant = constant
    }
    
    convenience init(r: Float, g: Float, b: Float) {
        self.init(float3(r, g, b))
    }
    
    override func colorFor(u: Float, v: Float, p: float3) -> float3 {
        return constant
    }
}
