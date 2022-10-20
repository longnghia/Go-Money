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

    func getExpenses(filerBy: ExpenseFilter = .month, sortBy: ExpenseSort = .occuredOn, ascending: Bool = false, completion: @escaping ([Expense]) -> Void) {
        let expense = realm.objects(Expense.self).sorted(
            byKeyPath: sortBy.rawValue,
            ascending: ascending).filter {
            let endDate = Date()
            switch filerBy {
            case .week:
                let startDate: Date = .init().getLast7Day() ?? endDate
                return $0.occuredOn >= startDate && $0.occuredOn <= endDate
            case .month:
                let startDate: Date = .init().getLast30Day() ?? endDate
                return $0.occuredOn >= startDate && $0.occuredOn <= endDate
            default:
                return true
            }
        }
        completion(Array(expense))
    }
}
