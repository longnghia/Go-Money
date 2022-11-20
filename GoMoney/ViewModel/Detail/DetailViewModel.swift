import Realm
import UIKit

class DetailViewModel {
    var transaction: Expense?
    private let service = DataService.shared

    func applyTransaction(newTrans: Expense, completion: ((Error?) -> Void)? = nil) {
        guard let transaction = transaction else {
            completion?(DataError.noTransactions)
            return
        }
        DataService.shared.updateExpense(
            oldTrans: transaction,
            newTrans: newTrans,
            completion: { err in
                completion?(err)
            }
        )
    }

    func deleteTransaction(_ expense: Expense, completion: ((Error?) -> Void)? = nil) {
        service.deleteExpense(expense: expense) { err in
            completion?(err)
        }
    }
}
