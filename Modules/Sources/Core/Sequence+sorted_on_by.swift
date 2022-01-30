extension Sequence {
    public func sorted<Value>(
        on keyPath: KeyPath<Element, Value>,
        by areInIncreasingOrder: (Value, Value) -> Bool = (<)
    ) -> [Element] where Value: Comparable {
        return self.sorted { lhs, rhs in
            areInIncreasingOrder(lhs[keyPath: keyPath], rhs[keyPath: keyPath])
        }
    }
}
