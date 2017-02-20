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
        let s = Sphere(center: float3(0, 0, -1), radius: 0.5, shader: NormLambertMaterial())
        let ground = Sphere(center: float3(0, -100.5, -1), radius: 100, shader: LambertMaterial(r: 0.2, g: 0.8, b: 0.2))
        let objs = Group(members: [s, ground])
        let (didHit, record) = objs.hit(r: r, near: 0.001, far: 1000)
        if didHit {
            let result = record.scatter(r: r)
            return result.attenuation
        }
        let unit_dir = normalize(r.direction)
        let t = 0.5 * (unit_dir.y + 1.0)
        let blue = float3(0.5, 0.7, 1.0)
        let white = float3(1, 1, 1)
        return Lerp(from: white, to: blue, by: t)
    }
    
    for j in 0 ..< height {
        for i in 0 ..< width {
            let u = Float(i) * iw
            let v = Float(height - j) * ih
            let dir = lowerLeftCorner + u*horizontal + v*vertical
            let r = Ray(origin: origin, direction: dir)
            let idx = i + width*j
            data[idx] = color(r)
        }
    }
    let image = Image(width: width, height: height, pixels: data)
    image.exportToDesktop()
}

func TestScene(width: Int, height: Int) {
    let diffuseGreen = LambertMaterial(r: 0.1, g: 0.8, b: 0.2)
    let diffuseNorm = NormLambertMaterial()
    let metallicGold = MetalMaterial(r: 0.8, g: 0.6, b: 0.2, roughness: 0.05)
    let greenGlass = GlassMaterial(r: 0.8, g: 1.0, b: 0.8, IOR: 1.5)
    
    let left = Sphere(center: float3(-1.02, 0, 0), radius: 0.5, shader: greenGlass)
    let middle = Sphere(center: float3(), radius: 0.5, shader: diffuseNorm)
    let right = Sphere(center: float3(1.02, 0, 0), radius: 0.5, shader: metallicGold)
    let ground = Sphere(center: float3(0, -100.5, 0), radius: 100, shader: diffuseGreen)
    let spheres = Group(members: [left, middle, right, ground])
    
    let sky = TwoColorSky(center: float3(1, 1, 1), edges: float3(0.5, 0.7, 1))
    let world = World(objects: spheres, sky: sky)
    
    let camera = Camera(lookfrom: float3(0, 0, 4), lookat: middle.center, vup: float3(0, 1, 0), vfov: 20, width: width, height: height)
    let renderer = Renderer(camera: camera)
    
    let image = renderer.render(scene: world, samples: 25)
    image.exportToDesktop()
}

Squall.seed()

let start = Date()
//TestGradient(width: 200, height: 100)
//TestSky(width: 400, height: 200)
TestScene(width: 200, height: 100)
let duration = -start.timeIntervalSinceNow

print(Squall.count, duration)
