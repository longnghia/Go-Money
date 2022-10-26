import RealmSwift
import UIKit

protocol DataServiceDelegate: AnyObject {
    func dataWillLoad()
    func dataDidLoad()
    func dataDidAdd()
    func dataDidUpdate()
    func dataDidRemove()
}

class DataService {
    let realm: Realm = try! Realm()
    static let shared = DataService()
    private var itemsToken: NotificationToken?

    private init() {
        // JUST FOR DEBUGGING
        let expenses = realm.objects(Expense.self)
        itemsToken = expenses.observe { changes in
            switch changes {
            case .update(_, let deletions, let insertions, let updates):
                print("deletions:\(deletions)")
                print("insertions:\(insertions)")
                print("updates:\(updates)")
            case .error: break
            default: break
            }
        }
    }

    deinit {
        itemsToken?.invalidate()
    }

    func getExpenses(type: ExpenseType? = .expense, filerBy: ExpenseFilter = .month, sortBy: ExpenseSort = .occuredOn, ascending: Bool = false, completion: @escaping ([Expense]) -> Void) {
        let endDate = Date()
        let startDate: Date?

        switch filerBy {
        case .week:
            startDate = Date().getLast7Day() ?? endDate
        case .month:
            startDate = Date().getLast30Day() ?? endDate
        case .year:
            startDate = Date().getLastYearDay() ?? endDate
        case .all:
            startDate = Date(timeIntervalSince1970: 0)
        }

        guard let startDate = startDate else {
            completion([])
            return
        }

        var expenses: Results<Expense>?

        if let type = type {
            expenses = realm.objects(Expense.self)
                .where { $0.type == type.rawValue && $0.occuredOn >= startDate && $0.occuredOn <= endDate }
                .sorted(
                    byKeyPath: sortBy.rawValue,
                    ascending: ascending)
        } else {
            expenses = realm.objects(Expense.self)
                .where { $0.occuredOn >= startDate && $0.occuredOn <= endDate }
                .sorted(
                    byKeyPath: sortBy.rawValue,
                    ascending: ascending)
        }

        if let expense = expenses {
            completion(Array(expense))
        } else {
            completion([])
        }
    }
}
