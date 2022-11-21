import RealmSwift
import UIKit

protocol DataServiceDelegate: AnyObject {
    func dataWillLoad()
    func dataDidLoad()
    func dataDidAdd()
    func dataDidUpdate()
    func dataDidRemove()
}

enum DataError: Error {
    case transactionNotFound(_ transaction: Expense)
    case noTransactions
    case userNotFound
    case tagNotFound

    var localizedDescription: String {
        switch self {
        case let .transactionNotFound(transaction):
            return "Transaction \(transaction._id) not found!"
        case .noTransactions:
            return "There is no transactions!"
        case .userNotFound:
            return "User not found!"
        case .tagNotFound:
            return "Tag not found!"
        }
    }
}

class DataService {
    let realm: Realm = try! Realm()

    let tracking = TrackingService.shared

    typealias ServiceCompletion = (Error) -> Void

    static let shared = DataService()
    private var itemsToken: NotificationToken?

    private init() {
        // JUST FOR DEBUGGING
        let expenses = realm.objects(Expense.self)
        itemsToken = expenses.observe { changes in
            switch changes {
            case let .update(_, deletions, insertions, updates):
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

    func getAllTransactions(completion: @escaping ([Expense]) -> Void) {
        getExpenses(type: nil, filerBy: .all, completion: completion)
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
                    ascending: ascending
                )
        } else {
            expenses = realm.objects(Expense.self)
                .where { $0.occuredOn >= startDate && $0.occuredOn <= endDate }
                .sorted(
                    byKeyPath: sortBy.rawValue,
                    ascending: ascending
                )
        }

        if let expense = expenses {
            completion(Array(expense))
        } else {
            completion([])
        }
    }

    func addExpense(_ expense: Expense, completion: ((Error?) -> Void)? = nil) {
        do {
            try realm.write {
                realm.add(expense)
                // add new transaction to temp-table
                tracking.checkAndAdd(TransactionTracking(id: expense._id, status: .updated))
            }
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

    func addTransactions(_ transactions: [Expense], completion: (Error?) -> Void) {
        do {
            try realm.write {
                realm.add(transactions)
            }
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteExpense(expense: Expense, completion: ((Error?) -> Void)? = nil) {
        do {
            try realm.write {
                // add deleted transaction to temp-table
                tracking.checkAndAdd(TransactionTracking(id: expense._id, status: .deleted))
                realm.delete(expense)
            }
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

    func updateExpense(oldTrans: Expense, newTrans: Expense, completion: ((Error?) -> Void)? = nil) {
        do {
            try realm.write {
                oldTrans.type = newTrans.type
                oldTrans.amount = newTrans.amount
                oldTrans.tag = newTrans.tag
                oldTrans.note = newTrans.note
                oldTrans.occuredOn = newTrans.occuredOn
                oldTrans.updatedAt = newTrans.updatedAt

                // add updated transaction to temp-table
                tracking.checkAndAdd(TransactionTracking(id: oldTrans._id, status: .updated))
            }
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

    /// get Transaction by id.
    func getTransaction(by id: String) -> Expense? {
        guard let objectId = try? ObjectId(string: id) else {
            return nil
        }
        return realm.object(
            ofType: Expense.self,
            forPrimaryKey: objectId
        )
    }

    func dropAllTable() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("[dropAllTable] Error \(error)")
        }
    }
}
