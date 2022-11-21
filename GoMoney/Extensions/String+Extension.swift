extension String {
    func splitFromEnd(by length: Int) -> [String] {
        var endIndex = self.endIndex
        var results = [Substring]()

        while endIndex > self.startIndex {
            let startIndex = self.index(endIndex, offsetBy: -length, limitedBy: self.startIndex) ?? self.startIndex
            results.append(self[startIndex ..< endIndex])
            endIndex = startIndex
        }

        return results.map { String($0) }.reversed()
    }
}
