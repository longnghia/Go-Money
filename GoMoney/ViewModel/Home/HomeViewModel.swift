import RealmSwift
import UIKit

class HomeViewModel {
    let realm = try! Realm()
    
    private let service = DataService.shared
    
    weak var delegate: DataServiceDelegate?
    
    var expenses: [Expense]? = [] {
        didSet {
            incomeSum = expenses?.filter { $0.type == ExpenseType.income.rawValue }.reduce(0) { $0 + $1.amount }
            expenseSum = expenses?.filter { $0.type == ExpenseType.expense.rawValue }.reduce(0) { $0 + $1.amount }
        }
    }
    
    var incomeSum: Double? = 0
    var expenseSum: Double? = 0
    
    func loadExpenses() {
        delegate?.dataWillLoad()
        
        service.getExpenses { result in
            self.expenses = result
            self.delegate?.dataDidLoad()
        }
    }
}
