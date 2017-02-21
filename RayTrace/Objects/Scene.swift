import simd

public class Scene {
    func getColor(r: Ray, near: Float, far: Float, bounces: Int, rand: Gust) -> float3 {
        return float3()
    }
}

public class SkyShader {
    func color(for r: Ray) -> float3 {
        return float3()
    }
}

public class OneColorSky: SkyShader {
    var color: float3
    
    init(color: float3) {
        self.color = color
    }
    
    override func color(for r: Ray) -> float3 {
        return color
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
    
    override func getColor(r: Ray, near: Float, far: Float, bounces: Int, rand: Gust) -> float3 {
        if let record = objects.hit(r: r, near: near, far: far) {
            if record.Material is LightShader {
                let light = record.Material as! LightShader
                return light.emit(u: record.u, v: record.v, p: record.P)
            }
            if let result = record.scatter(r: r, rand: rand), bounces > 0 {
                let color = getColor(r: result.scattered, near: near, far: far-record.T, bounces: bounces-1, rand: rand)
                return result.attenuation * color
            }
        }
        return sky.color(for: r)
    }
}
