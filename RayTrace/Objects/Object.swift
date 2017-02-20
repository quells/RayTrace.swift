import Foundation
import simd

public struct HitRecord {
    var T, near, far: Float
    var u, v: Float
    var P, Normal: float3
    var Material: MaterialShader
    
    public init(
        T: Float = 0, near: Float = 0, far: Float = 0, u: Float = 0, v: Float = 0,
        P: float3 = float3(), Normal: float3 = float3(),
        Material: MaterialShader = MaterialShader()
        ) {
        (self.T, self.near, self.far, self.u, self.v) = (T, near, far, u, v)
        (self.P, self.Normal) = (P, Normal)
        self.Material = Material
    }
    
    public func scatter(r: Ray) -> ScatterResult {
        return Material.scatter(r: r, h: self)
    }
}

public class Object {
    public func hit(r: Ray, near: Float, far: Float) -> (ditHit: Bool, record: HitRecord) {
        return (false, HitRecord())
    }
}

public class Group: Object {
    public let members: [Object]
    
    public init(members: [Object]) {
        self.members = members
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> (ditHit: Bool, record: HitRecord) {
        var hitAnything = false
        var closestT = far
        var closest = HitRecord()
        for m in members {
            let (didHit, record) = m.hit(r: r, near: near, far: far)
            if didHit {
                hitAnything = true
                if record.T < closestT {
                    closestT = record.T
                    closest = record
                }
            }
        }
        if hitAnything {
            return (true, closest)
        }
        return (false, closest)
    }
}
