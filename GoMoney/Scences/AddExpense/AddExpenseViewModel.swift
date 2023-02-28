class AddExpenseViewModel {
    private let service = DataService.shared

    func addExpense(expense: Expense, completion: ((Error?) -> Void)? = nil) {
        service.addExpense(expense) { err in
            if let err = err {
                completion?(err)
            } else {
                completion?(nil)
            }
        }
    }
}
