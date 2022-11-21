import RealmSwift

class ViewAllViewModel {
    let realm = try! Realm()

    var transactions = [Expense]()

    func getAllTransaction(completion: @escaping () -> Void) {
        DataService.shared.getAllTransactions { transactions in
            self.transactions = transactions
            completion()
        }
    }
}
