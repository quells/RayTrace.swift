import Foundation
import simd

func TestCornell(width: Int, height: Int) {
    let red   = LambertMaterial(r: 0.65, g: 0.05, b: 0.05)
    let white = LambertMaterial(r: 0.75, g: 0.75, b: 0.75)
    let green = LambertMaterial(r: 0.12, g: 0.45, b: 0.15)
    let light = DiffuseLight(white: 15)
    
    let a = Translate(RotateY(Rectangle(width: 555, height: 555, k: 0, shader: red), angle: 90), offset: float3(-555, 0, 0))
    let b = RotateY(Rectangle(width: 555, height: 555, k: 0, shader: green), angle: 90)
    let c = RotateX(Rectangle(width: 555, height: 555, k: 0, shader: white), angle: 90)
    let d = Translate(RotateX(Rectangle(width: 555, height: 555, k: 0, shader: white), angle: 90), offset: float3(0, -555, 0))
    let e = Rectangle(width: 555, height: 555, k: 555, shader: white)
    let f = Translate(RotateX(Rectangle(width: 255, height: 255, k: 0, shader: light), angle: 90), offset: float3(-150, -554.5, -150))
    let tall = Translate(RotateY(Box(width: 160, height: 380, depth: 160, shader: white), angle: -25), offset: float3(-300, 1, -260))
    let short = Translate(RotateY(Box(width: 140, height: 140, depth: 140, shader: white), angle: 40), offset: float3(-200, 1, -60))
    let smoke = ConstantVolume(boundary: Box(width: 555, height: 120, depth: 555, shader: MaterialShader()), density: 0.004, shader: white)
    
    let objects = Group(members: [a, b, c, d, e, f, tall, short, smoke])
    
    let sky = OneColorSky(color: float3())
    let world = World(objects: objects, sky: sky)
    
    let lookfrom = float3(278, 278, -800)
    let lookat = float3(278, 278, 0)
//    let lookfrom = float3(0, 150, -300)
//    let lookat = float3(278, 0, 278)
    let camera = Camera(lookfrom: lookfrom, lookat: lookat, vup: float3(0, 1, 0), vfov: 37, width: width, height: height)
    let renderer = Renderer(far: 1000000, camera: camera)
    
    let image = renderer.render(scene: world, samples: 1024*32)
    image.exportToDesktop()
}

Squall.seed()

let start = Date()
TestCornell(width: 400, height: 400)
let duration = -start.timeIntervalSinceNow

print(duration)
