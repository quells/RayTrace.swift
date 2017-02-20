
import Foundation

public class Channel<T> {
    private var fifo = Queue<T>()
    private var closed: Bool = false
    
    private var queue: DispatchQueue
    
    public init() {
        let id = UUID().uuidString
        self.queue = DispatchQueue(label: id, qos: .background)
    }
    
    public func add(_ value: T) {
        self.queue.sync {
            self.fifo.enqueue(value)
        }
    }
    
    public func get() -> T {
        var val: T? = nil
        while true {
            var flag = false
            self.queue.sync {
                guard let v = self.fifo.dequeue() else {
                    return
                }
                val = v
                flag = true
            }
            if flag { break }
        }
        return val!
    }
    
    public func hasValues() -> Bool {
        var valuesFlag = false
        self.queue.sync {
            valuesFlag = self.fifo.hasValues()
        }
        return valuesFlag
    }
}
