import UIKit

class StatViewModel {
    var didChangeFilter: (() -> Void)?

    private let service = DataService.shared

    var filterBy: ExpenseFilter = .week {
        didSet {
            getFilteredExpense()
        }
    }

    var dateExpenses: [DateAmount]?
    var tagExpenses: [TagAmount]?
    var topExpenses: [Expense]?

    func getFilteredExpense(completion: (() -> Void)? = nil) {
        service.getExpenses(filerBy: filterBy, ascending: true) { [self] result in

            dateExpenses = result.groupExpensesByDate(type: filterBy)
            tagExpenses = result.groupExpensesByTag()
            topExpenses = result.getTopExpenses()

            self.didChangeFilter?()

            completion?()
        }
    }
}
