import Foundation
import simd

public struct Image {
    public let width, height: Int
    public let pixels: [float3]
    
    public init(width: Int, height: Int, pixels: [float3]? = nil) {
        (self.width, self.height) = (width, height)
        if let pixels = pixels {
            self.pixels = pixels
        } else {
            self.pixels = [float3](repeating: float3(), count: width*height)
        }
    }
    
    private static let _sizeOfDims = 2 * MemoryLayout<UInt16>.size
    private static let _sizeOfRGB  = 3 * MemoryLayout<Float32>.size
    private func encode() -> Data? {
        guard !pixels.isEmpty else { return nil }
        
        let bufferLength = Image._sizeOfDims + (pixels.count * Image._sizeOfRGB)
        precondition(bufferLength > (Image._sizeOfDims + Image._sizeOfRGB), "Empty buffer?")
        
        let rawMemory = UnsafeMutableRawPointer.allocate(bytes: bufferLength, alignedTo: MemoryLayout<UInt32>.alignment)
        var offset: Int = 0
        
        rawMemory.storeBytes(of: UInt16(width), as: UInt16.self)
        offset += MemoryLayout<UInt16>.size
        rawMemory.storeBytes(of: UInt16(height), toByteOffset: offset, as: UInt16.self)
        offset += MemoryLayout<UInt16>.size
        
        for p in pixels {
            let r = Float32(p.x); let g = Float32(p.y); let b = Float32(p.z)
            rawMemory.storeBytes(of: r, toByteOffset: offset, as: Float32.self)
            offset += MemoryLayout<Float32>.size
            rawMemory.storeBytes(of: g, toByteOffset: offset, as: Float32.self)
            offset += MemoryLayout<Float32>.size
            rawMemory.storeBytes(of: b, toByteOffset: offset, as: Float32.self)
            offset += MemoryLayout<Float32>.size
        }
        
        return Data(bytesNoCopy: rawMemory, count: bufferLength, deallocator: .free)
    }
    
    public func exportToDesktop(filename: String = "image.dat") {
        let desktop = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Desktop", isDirectory: true)
        let filepath = desktop.appendingPathComponent(filename)
        if let imgData = encode() {
            do {
                try imgData.write(to: filepath)
            } catch {
                print(error)
            }
        }
    }
}
