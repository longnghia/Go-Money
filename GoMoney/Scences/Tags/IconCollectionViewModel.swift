class IconCollectionViewModel {
    var defaultIcons = TransactionTag.localIcons

    func filterTags(by query: String, completion: @escaping () -> Void) {
        if query.isEmpty {
            defaultIcons = TransactionTag.localIcons
        } else {
            defaultIcons = TransactionTag.localIcons.filter {
                $0.lowercased().contains(query.lowercased())
            }
        }

        completion()
    }
}
