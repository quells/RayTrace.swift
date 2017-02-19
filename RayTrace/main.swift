import Foundation
import simd

func TestGradient(width: Int, height: Int) {
    let (w, h) = (Float(width), Float(height))
    let (iw, ih) = (1.0/w, 1.0/h)
    var data = [float3](repeating: float3(), count: width*height)
    for j in 0 ..< height {
        for i in 0 ..< width {
            let r = Float(i) * iw
            let g = Float(height - j) * ih
            let b = 0.2 as Float
            let idx = i + width*j
            data[idx] = float3(r, g, b)
        }
    }
    let image = Image(width: width, height: height, pixels: data)
    image.exportToDesktop()
}

TestGradient(width: 200, height: 100)
