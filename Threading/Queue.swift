
private class QueueNode<T> {
    let value: T
    var next: QueueNode<T>? = nil
    
    init(_ value: T) {
        self.value = value
    }
}

public class Queue<T> {
    private var first: QueueNode<T>? = nil
    private var last: QueueNode<T>? = nil
    
    public func enqueue(_ value: T) {
        let n = QueueNode<T>(value)
        guard let l = self.last else {
            self.first = n
            self.last = self.first
            return
        }
        l.next = n
        self.last = n
    }
    
    public func dequeue() -> T? {
        guard let f = self.first else {
            return nil
        }
        let v = f.value
        guard let n = f.next else {
            self.first = nil
            self.last = nil
            return v
        }
        self.first = n
        return v
    }
    
    public func hasValues() -> Bool {
        return self.first != nil
    }
}
