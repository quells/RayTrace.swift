import simd

public struct AABB {
    let Min: float3
    let Max: float3
    
    init(min: float3, max: float3) {
        (self.Min, self.Max) = (min, max)
    }
    
    public func hit(r: Ray, tmin: Float, tmax: Float) -> (ditHit: Bool, tmin: Float, tmax: Float) {
        var (tmin, tmax) = (tmin, tmax)
        for a in 0 ..< 3 {
            let iD = 1.0/r.direction[a]
            var t0 = (Min[a] - r.origin[a]) * iD
            var t1 = (Max[a] - r.origin[a]) * iD
            if iD < 0 {
                (t0, t1) = (t1, t0)
            }
            tmin = max(t0, tmin)
            tmax = min(t1, tmax)
            if tmax <= tmin {
                return (false, tmin, tmax)
            }
        }
        return (false, tmin, tmax)
    }
}

func combine(a: AABB, b: AABB) -> AABB {
    var (small, big) = (float3(), float3())
    for i in 0 ..< 3 {
        small[i] = min(a.Min[i], b.Min[i])
        big[i] = max(a.Max[i], b.Max[i])
    }
    return AABB(min: small, max: big)
}

public class AABBNode: Object {
    var bb: AABB
    var left: Object
    var right: Object
    
    init(objects: [Object]) {
        if objects.count < 1 {
            self.bb = AABB(min: float3(), max: float3())
            self.left = Object()
            self.right = Object()
            return
        }
        if objects.count == 1 {
            guard let box = objects.first!.boundingBox(0, 0) else {
                self.bb = AABB(min: float3(), max: float3())
                self.left = Object()
                self.right = Object()
                return
            }
            self.bb = box
            self.left = Group(members: [objects.first!])
            self.right = self.left
            return
        }
        let axis = Int(Squall.random() as UInt32 % 3)
        var objects = objects.sorted { (left, right) in
            guard let leftBox = left.boundingBox(0, 0) else {
                print("No bounding box in node construction")
                abort()
            }
            guard let rightBox = right.boundingBox(0, 0) else {
                print("No bounding box in node construction")
                abort()
            }
            return leftBox.Min[axis] < rightBox.Min[axis]
        }
        if objects.count == 2 {
            let (leftBox, rightBox) = (objects[0].boundingBox(0, 0)!, objects[1].boundingBox(0, 0)!)
            self.bb = combine(a: leftBox, b: rightBox)
            self.left = objects[0]
            self.right = objects[1]
            return
        }
        let leftObjects = Array(objects[0 ..< objects.count/2])
        let rightObjects = Array(objects[objects.count/2 ..< objects.count])
        let left = AABBNode(objects: leftObjects)
        let right = AABBNode(objects: rightObjects)
        self.bb = combine(a: left.bb, b: right.bb)
        self.left = left
        self.right = right
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> HitRecord? {
        let (didHit, near, far) = bb.hit(r: r, tmin: near, tmax: far)
        if didHit {
            let leftRecord = left.hit(r: r, near: near, far: far)
            let rightRecord = right.hit(r: r, near: near, far: far)
            if leftRecord != nil && rightRecord != nil {
                return (leftRecord!.T < rightRecord!.T) ? leftRecord : rightRecord
            }
            if let l = leftRecord { return l }
            if let r = rightRecord { return r }
        }
        return nil
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        return bb
    }
}

