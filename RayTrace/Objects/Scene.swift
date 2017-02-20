import simd

public class Scene {
    func getColor(r: Ray, near: Float, far: Float, bounces: Int) -> float3 {
        return float3()
    }
}

public class SkyShader {
    func color(for r: Ray) -> float3 {
        return float3()
    }
}

public class TwoColorSky: SkyShader {
    var center: float3
    var edges: float3
    
    init(center: float3, edges: float3) {
        (self.center, self.edges) = (center, edges)
    }
    
    override func color(for r: Ray) -> float3 {
        let dir = normalize(r.direction)
        let t = 0.5 * (dir.y + 1)
        return Lerp(from: center, to: edges, by: t)
    }
}

public class World: Scene {
    var objects: Object
    var sky: SkyShader
    
    init(objects: Object, sky: SkyShader = SkyShader()) {
        (self.objects, self.sky) = (objects, sky)
    }
    
    override func getColor(r: Ray, near: Float, far: Float, bounces: Int) -> float3 {
        let (didHit, record) = objects.hit(r: r, near: near, far: far)
        if didHit {
            let result = record.scatter(r: r)
            if result.didScatter && bounces > 0 {
                let color = getColor(r: result.scattered, near: near, far: far-record.T, bounces: bounces-1)
                return result.attenuation * color
            }
            
        }
        return sky.color(for: r)
    }
}
