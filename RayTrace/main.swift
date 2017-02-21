import Foundation
import simd

func TestCornell(width: Int, height: Int) {
    let red   = LambertMaterial(r: 0.65, g: 0.05, b: 0.05)
    let white = LambertMaterial(r: 0.75, g: 0.75, b: 0.75)
    let green = LambertMaterial(r: 0.12, g: 0.45, b: 0.15)
    let light = DiffuseLight(white: 15)
    
//    let temp = Sphere(center: float3(278, 555, 278), radius: 65, shader: light)
    let a = RotateY(Rectangle(p: float3(-555, 0, 555), width: 555, height: 555, shader: red), angle: -90)
    let b = RotateY(Rectangle(p: float3(0, 0, 0), width: 555, height: 555, shader: green), angle: 90)
    let c = RotateX(Rectangle(p: float3(0, 0, 0), width: 555, height: 555, shader: white), angle: 90)
    let d = RotateX(Rectangle(p: float3(0, -555, 555), width: 555, height: 555, shader: white), angle: -90)
    let e = Rectangle(p: float3(0, 0, 555), width: 555, height: 555, shader: white)
    let f = RotateX(Rectangle(p: float3(210, -350, 554.9), width: 140, height: 140, shader: light), angle: -90)
//    let g = FlipNormals(Rectangle(p: float3(0, 0, 0), width: 555, height: 555, shader: white))
    
    let objects = Group(members: [a, b, c, d, e, f])
    
    let sky = OneColorSky(color: float3())
    let world = World(objects: objects, sky: sky)
    
    let camera = Camera(lookfrom: float3(278, 278, -800), lookat: float3(278, 278, 0), vup: float3(0, 1, 0), vfov: 36, width: width, height: height)
    let renderer = Renderer(far: 1000000, camera: camera)
    
    let image = renderer.render(scene: world, samples: 1024)
    image.exportToDesktop()
}

Squall.seed()

let start = Date()
TestCornell(width: 100, height: 100)
let duration = -start.timeIntervalSinceNow

print(Squall.count, duration)
