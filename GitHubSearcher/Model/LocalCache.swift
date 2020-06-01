import Foundation

final class LocalCache<KeyT: Hashable, Value> {
    
    private let wrapped = NSCache<WrappedKey, Entry>()
    
    init(maximumEntryCount: Int = 500) {
        wrapped.countLimit = maximumEntryCount
    }
    
    func insert(_ value: Value, forKey vkey: KeyT) {
        let entry = Entry(key: vkey, value: value)
        wrapped.setObject(entry, forKey: WrappedKey(vkey))
    }
    
    func value(forKey key: KeyT) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func removeValue(forKey key: KeyT) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }

    subscript(key: KeyT) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}

private extension LocalCache {
    final class WrappedKey: NSObject {
        let key: KeyT
        init(_ key: KeyT) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }
}

private extension LocalCache {
    final class Entry {
        let key: KeyT
        let value: Value
        
        init(key: KeyT, value: Value) {
            self.key = key
            self.value = value
        }
    }
}
