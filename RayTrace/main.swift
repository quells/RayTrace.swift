import Foundation
import simd

func TestScene(width: Int, height: Int) {
//    let diffuseGreen = LambertMaterial(r: 0.1, g: 0.8, b: 0.2)
    let diffuseNorm = NormLambertMaterial()
    let metallicGold = MetalMaterial(r: 0.8, g: 0.6, b: 0.2, roughness: 0.1)
    let greenGlass = GlassMaterial(r: 0.8, g: 1.0, b: 0.8, IOR: 1.5)
    let constantWhite = ConstantTexture(r: 1, g: 1, b: 1)
    let constantBlack = ConstantTexture(r: 0, g: 0, b: 0)
    let checkered = LambertMaterial(albedo: CheckeredTexture(even: constantWhite, odd: constantBlack))
    
    let left = Sphere(center: float3(-1.02, 0, 0), radius: 0.5, shader: greenGlass)
    let middle = Sphere(center: float3(), radius: 0.5, shader: diffuseNorm)
    let right = Sphere(center: float3(1.02, 0, 0), radius: 0.5, shader: metallicGold)
    let ground = Sphere(center: float3(0, -100.5, 0), radius: 100, shader: checkered)
    let spheres = Group(members: [left, middle, right, ground])
    
    let sky = TwoColorSky(center: float3(1, 1, 1), edges: float3(0.5, 0.7, 1))
    let world = World(objects: spheres, sky: sky)
    
    let camera = Camera(lookfrom: float3(0, 0, 4), lookat: middle.center, vup: float3(0, 1, 0), vfov: 35, width: width, height: height)
    let renderer = Renderer(camera: camera)
    
    let image = renderer.render(scene: world, samples: 500)
    image.exportToDesktop()
}

Squall.seed()

let start = Date()
TestScene(width: 200, height: 100)
let duration = -start.timeIntervalSinceNow

print(Squall.count, duration)
