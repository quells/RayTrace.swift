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

public class CheckeredTexture: Texture {
    let even: Texture
    let odd: Texture
    let scale: Float
    
    init(even: Texture, odd: Texture, scale: Float = 10) {
        (self.even, self.odd, self.scale) = (even, odd, scale)
    }
    
    override func colorFor(u: Float, v: Float, p: float3) -> float3 {
        let sines = sin(scale*p.x) * sin(scale*p.y) * sin(scale*p.z)
        if sines > 0 {
            return even.colorFor(u: u, v: v, p: p)
        }
        return odd.colorFor(u: u, v: v, p: p)
    }
}
