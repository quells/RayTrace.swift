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
    
    public func scatter(r: Ray, rand: Gust) -> ScatterResult? {
        return Material.scatter(r: r, h: self, rand: rand)
    }
}

public class Object {
    public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        return nil
    }
    
    public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        return nil
    }
}

public class Group: Object {
    public let members: [Object]
    
    public init(members: [Object]) {
        self.members = members
    }
    
    override public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        var closestT = far
        var closest: HitRecord? = nil
        for m in members {
            if let record = m.hit(r: r, near: near, far: far, rand: rand) {
                if record.T < closestT {
                    closestT = record.T
                    closest = record
                }
            }
        }
        return closest
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        if members.count < 1 {
            return nil
        }
        guard var box = members.first!.boundingBox(tmin, tmax) else { return nil }
        for i in 1 ..< members.count {
            guard let nextBox = members[i].boundingBox(tmin, tmax) else { return nil }
            box = combine(a: box, b: nextBox)
        }
        return box
    }
}

public class Translate: Object {
    var child: Object
    var offset: float3
    
    init(_ child: Object, offset: float3) {
        (self.child, self.offset) = (child, offset)
    }
    
    override public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        var tr = r
        tr.origin += offset
        guard var record = child.hit(r: tr, near: near, far: far, rand: rand) else { return nil }
        record.P -= offset
        return record
    }
}

public class FlipNormals: Object {
    var child: Object
    
    init(_ child: Object) {
        self.child = child
    }
    
    override public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        guard var record = child.hit(r: r, near: near, far: far, rand: rand) else { return nil }
        record.Normal *= -1
        return record
    }
}
