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

func TestSky(width: Int, height: Int) {
    let (w, h) = (Float(width), Float(height))
    let (iw, ih) = (1.0/w, 1.0/h)
    let lowerLeftCorner = float3(-2, -1, -1)
    let horizontal = float3(4, 0, 0)
    let vertical = float3(0, 2, 0)
    let origin = float3()
    var data = [float3](repeating: float3(), count: width*height)
    
    func color(_ r: Ray) -> float3 {
        let unit_dir = normalize(r.direction)
        let t = 0.5 * (unit_dir.y + 1.0)
        let blue = float3(0.5, 0.7, 1.0)
        let white = float3(1, 1, 1)
        return Lerp(from: blue, to: white, by: t)
    }
    
    for j in 0 ..< height {
        for i in 0 ..< width {
            let u = Float(i) * iw
            let v = Float(j) * ih
            let dir = lowerLeftCorner + u*horizontal + v*vertical
            let r = Ray(origin: origin, direction: dir)
            let idx = i + width*j
            data[idx] = color(r)
        }
    }
    let image = Image(width: width, height: height, pixels: data)
    image.exportToDesktop()
}

//TestGradient(width: 200, height: 100)
TestSky(width: 400, height: 200)
