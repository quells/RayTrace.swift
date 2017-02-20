import simd

public class Renderer {
    var near: Float
    var far: Float
    var maxBounces: Int
    var camera: Camera
    var routines: [Routine]
    
    init(near: Float = 0.001, far: Float = 1000, maxBounces: Int = 50, camera: Camera, numWorkers: Int = 4) {
        (self.near, self.far, self.maxBounces) = (near, far, maxBounces)
        self.camera = camera
        self.routines = []
        for _ in 0 ..< numWorkers {
            self.routines.append(Routine())
        }
    }
    
    func render(scene: Scene, samples: Int = 1) -> Image {
        let (width, height) = (camera.imageWidth, camera.imageHeight)
        var pixels = [float3](repeating: float3(), count: width*height)
        
        let todo = Channel<Int>()
        let completed = Channel<(Int, [float3])>()
        let done = Channel<Bool>()
        
        for j in 0 ..< height {
            todo.add(j)
        }
        
        for r in routines {
            r.doUntil(done) {
                let y = todo.get()
                let line = self.renderLine(scene: scene, y: height-y, samples: samples)
                completed.add((y, line))
            }
        }
        
        for _ in 0 ..< height {
            let (j, line) = completed.get()
            print("\(j)/\(height)")
            for i in 0 ..< width {
                let idx = i + width*j
                pixels[idx] = line[i]
            }
        }
        done.add(true)
        
        return Image(width: width, height: height, pixels: pixels)
    }
    
    func renderLine(scene: Scene, y Y: Int, samples: Int) -> [float3] {
        let (width, height) = (camera.imageWidth, camera.imageHeight)
        let (iw, ih) = (1.0/Float(width), 1.0/Float(height))
        let iS = 1.0/Float(samples)
        var pixelRow = [float3](repeating: float3(), count: width)
        let y = Float(Y)
        for i in 0 ..< width {
             let x = Float(i)
            for _ in 0 ..< samples {
                let u = (x + Squall.uniform())*iw
                let v = (y + Squall.uniform())*ih
                let r = camera.getRay(u: u, v: v)
                pixelRow[i] += scene.getColor(r: r, near: near, far: far, bounces: maxBounces)
            }
        }
        return pixelRow.map { $0 * iS }
    }
}
