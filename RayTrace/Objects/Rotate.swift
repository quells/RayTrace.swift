import Foundation
import simd

public class Rotate: Object {
    var child: Object
    var fwd: matrix_float3x3
    var rev: matrix_float3x3
    
    init(_ child: Object, _ fwd: matrix_float3x3, _ rev: matrix_float3x3) {
        (self.child, self.fwd, self.rev) = (child, fwd, rev)
    }
    
    override public func hit(r: Ray, near: Float, far: Float) -> HitRecord? {
        var rr = r
        rr.origin = matrix_multiply(fwd, r.origin) as float3
        rr.direction = matrix_multiply(fwd, r.direction) as float3
        if var record = child.hit(r: rr, near: near, far: far) {
            record.P = matrix_multiply(rev, record.P) as float3
            record.Normal = matrix_multiply(rev, record.Normal) as float3
            return record
        }
        return nil
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        return child.boundingBox(tmin, tmax)
    }
}

public class RotateX: Rotate {
    init(_ child: Object, angle: Float) {
        let theta = angle * Float(M_PI) / 180
        let (ct, st) = (cos(theta), sin(theta))
        var a = vector_float3(1, 0, 0)
        var b = vector_float3(0, ct, -st)
        var c = vector_float3(0, st, ct)
        let fwd = matrix_float3x3(columns: (a, b, c))
        a = vector_float3(1, 0, 0)
        b = vector_float3(0, ct, st)
        c = vector_float3(0, -st, ct)
        let rev = matrix_float3x3(columns: (a, b, c))
        super.init(child, fwd, rev)
    }
}

public class RotateY: Rotate {
    init(_ child: Object, angle: Float) {
        let theta = angle * Float(M_PI) / 180
        let (ct, st) = (cos(theta), sin(theta))
        var a = vector_float3(ct, 0, -st)
        var b = vector_float3(0, 1, 0)
        var c = vector_float3(st, 0, ct)
        let fwd = matrix_float3x3(columns: (a, b, c))
        a = vector_float3(ct, 0, st)
        b = vector_float3(0, 1, 0)
        c = vector_float3(-st, 0, ct)
        let rev = matrix_float3x3(columns: (a, b, c))
        super.init(child, fwd, rev)
    }
}
