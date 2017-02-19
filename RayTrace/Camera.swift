import simd

public class Camera {
    var imageWidth, imageHeight: Int
    
    private var Origin, LLCorner, Horizontal, Vertical: float3
    
    init(
        lookfrom: float3, lookat: float3,
        vup: float3, vfov: Float = 35,
        width: Int = 200, height: Int = 100
        ) {
        self.imageWidth = width
        self.imageHeight = height
        
        let aspect = Float(width) / Float(height)
        let halfTheta = vfov * Float(M_PI) / 360
        let halfHeight = tan(halfTheta)
        let halfWidth = aspect * halfHeight
        
        self.Origin = lookfrom
        let w = normalize(lookfrom - lookat)
        let u = normalize(cross(vup, w))
        let v = cross(w, u)
        
        self.LLCorner = Origin - halfWidth*u + halfHeight*v - w
        self.Horizontal = 2*halfWidth*u
        self.Vertical = 2*halfHeight*v
    }
    
    func GetRay(u: Float, v: Float) -> Ray {
        let a = LLCorner - Origin
        let b = u*Horizontal + v*Vertical
        let dir = a + b
        return Ray(origin: Origin, direction: dir)
    }
}
