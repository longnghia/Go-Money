import RealmSwift
import UIKit

class HomeViewModel {
    let realm = try! Realm()

    private let service = DataService.shared

    private let widgetService = WidgetService()

    weak var delegate: DataServiceDelegate?

    var transactions: [Expense]? = [] {
        didSet {
            guard let transactions = transactions else {
                return
            }

            expenses = []
            incomes = []

            transactions.forEach {
                if $0.isExpense() {
                    expenses.append($0)
                } else {
                    incomes.append($0)
                }
            }
            incomeSum = incomes.reduce(0) { $0 + $1.amount }
            expenseSum = expenses.reduce(0) { $0 + $1.amount }

            widgetService.updateIncomeWidget(income: incomeSum ?? 0, expense: expenseSum ?? 0)
            widgetService.updateChartWidget()

            groupedExpenses = expenses.groupExpensesByTag()
        }
    }

    var incomeSum: Double?
    var expenseSum: Double?
    var expenses: [Expense] = []
    var incomes: [Expense] = []
    var groupedExpenses: [TagAmount] = []

    func loadExpenses() {
        delegate?.dataWillLoad()

        service.getExpenses(type: nil) { result in
            self.transactions = result
            self.delegate?.dataDidLoad()
        }
    }

    func deleteTransaction(_ expense: Expense, completion: ((Error?) -> Void)? = nil) {
        let index = transactions?.firstIndex(of: expense)

        guard let index = index else {
            completion?(DataError.transactionNotFound(expense))
            return
        }

        transactions?.remove(at: index)

        service.deleteExpense(expense: expense) { err in
            if err != nil {
                completion?(err)
                return
            }
        }
        completion?(nil)
    }

    func applyTransaction(transaction: Expense, newTrans: Expense, completion: @escaping (Error?) -> Void) {
        DataService.shared.updateExpense(
            oldTrans: transaction,
            newTrans: newTrans,
            completion: { err in
                completion(err)
            }
        )
    }
}
