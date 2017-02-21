
import Foundation

public class Routine {
    private var queue: DispatchQueue
    private var rand: Gust
    
    public init(_ offset: Int) {
        let id = UUID().uuidString
        self.queue = DispatchQueue(label: id, qos: .background)
        self.rand = Gust(offset: UInt32(offset))
    }
    
    public func doOnce(block: @escaping () -> Void) {
        self.queue.async {
            block()
        }
    }
    
    public func doUntil(_ done: Channel<Bool>, block: @escaping (_ g: Gust) -> Void) {
        self.queue.async {
            while true {
                if done.hasValues() {
                    break
                }
                block(self.rand)
            }
        }
    }
}
