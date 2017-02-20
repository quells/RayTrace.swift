
import Foundation

public class Routine {
    private var queue: DispatchQueue
    
    public init() {
        let id = UUID().uuidString
        self.queue = DispatchQueue(label: id, qos: .background)
    }
    
    public func doOnce(block: @escaping () -> Void) {
        self.queue.async {
            block()
        }
    }
    
    public func doUntil(_ done: Channel<Bool>, block: @escaping () -> Void) {
        self.queue.async {
            while true {
                if done.hasValues() {
                    break
                }
                block()
            }
        }
    }
}
