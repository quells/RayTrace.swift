import simd

public class Box: Object {
    var faces: Group
    
    init(width: Float, height: Float, depth: Float, shader: MaterialShader) {
        let front = Rectangle(width: width, height: height, k: 0, shader: shader)
        let back = Rectangle(width: width, height: height, k: depth, shader: shader)
        let a = RotateY(Rectangle(width: width, height: height, k: 0, shader: shader), angle: 90)
        let b = RotateY(Rectangle(width: width, height: height, k: -depth, shader: shader), angle: 90)
        let top = RotateX(Rectangle(width: width, height: height, k: 0, shader: shader), angle: 90)
        let bottom = RotateX(Rectangle(width: width, height: depth, k: -height, shader: shader), angle: 90)
        self.faces = Group(members: [front, back, a, b, top, bottom])
    }
    
    override public func hit(r: Ray, near: Float, far: Float, rand: Gust) -> HitRecord? {
        return faces.hit(r: r, near: near, far: far, rand: rand)
    }
    
    override public func boundingBox(_ tmin: Float, _ tmax: Float) -> AABB? {
        return faces.boundingBox(tmin, tmax)
    }
}
