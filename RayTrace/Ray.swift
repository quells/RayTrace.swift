import Foundation
import simd

public struct Ray {
    public var origin: float3
    public var direction: float3
    
    public init(origin: float3, direction: float3) {
        self.origin = origin
        self.direction = direction
    }
    
    public init() {
        self.origin = float3()
        self.direction = float3()
    }
    
    public func walk(_ t: Float) -> float3 {
        return origin + t*direction
    }
    
    public static func RandomSphere(around p: float3 = float3()) -> Ray {
        var x: Float = Squall.uniform(-1, 1)
        var y: Float = Squall.uniform(-1, 1)
        var z: Float = Squall.uniform(-1, 1)
        var v = float3(x, y, z)
        while true {
            if length_squared(v) <= 1 {
                break
            }
            x = Squall.uniform(-1, 1)
            y = Squall.uniform(-1, 1)
            z = Squall.uniform(-1, 1)
            v = float3(x, y, z)
        }
        return Ray(origin: p, direction: normalize(v))
    }
}
