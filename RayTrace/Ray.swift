import simd

public struct Ray {
    public let origin: float3
    public let direction: float3
    
    public init(origin: float3, direction: float3) {
        self.origin = origin
        self.direction = direction
    }
    
    public func walk(_ t: Float) -> float3 {
        return origin + t*direction
    }
}
