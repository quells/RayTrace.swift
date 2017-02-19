import Foundation
import simd

func Lerp(from a: Float, to b: Float, by t: Float) -> Float {
    return t*b + (1-t)*a
}

func Lerp(from a: float3, to b: float3, by t: Float) -> float3 {
    return t*b + (1-t)*a
}
