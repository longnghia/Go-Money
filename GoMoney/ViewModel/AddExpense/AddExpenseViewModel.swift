import Realm
import UIKit

class AddExpenseViewModel {
    private let service = DataService.shared

    func validateFields(date: Date?, category: TransactionTag?, amount: String, completion: (String?) -> Void) {
        if date == nil || category == nil || amount == "" {
            return completion(Content.fieldEmpty)
        }

        // TODO: validate amount field

        completion(nil)
    }

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

extension AddExpenseViewModel {
    enum Content {
        static let amountInvalid = "Amount is invalid"
        static let fieldEmpty = "Make sure you fill in all fields"
    }
}
