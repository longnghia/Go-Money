import Realm
import UIKit

class DetailViewModel {
    var transaction: Expense?

    func applyTransaction(newTrans: Expense, completion: ((Error?) -> Void)? = nil) {
        guard let transaction = transaction else {
            completion?(DataError.noTransactions)
            return
        }
        DataService.shared.updateExpense(
            oldTrans: transaction,
            newTrans: newTrans,
            completion: { _ in
                print("update done")
                completion?(nil)
            })
    }
}
