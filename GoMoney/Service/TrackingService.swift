import RealmSwift

enum TrackingError: Error {
    case transactionNotFound(_ id: ObjectId)

    var localizedDescription: String {
        switch self {
        case .transactionNotFound(let id):
            return "Transaction \(id.stringValue) not found."
        }
    }
}

class TrackingService {
    static let shared = TrackingService()

    private let realm: Realm = try! Realm()

    private init() {}

    func getTransactionTracking(completion: @escaping ([TransactionTracking]) -> Void) {
        var transactions = realm.objects(TransactionTracking.self)
        completion(Array(transactions))
    }

    /// add to temp-table
    func addTransactionTracking(_ transaction: TransactionTracking, completion: ((Error?) -> Void)? = nil) {
        do {
            try realm.write {
                realm.add(transaction)
            }
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

    /// remove from temp-table
    func deleteTransactionTracking(by id: ObjectId, completion: ((Error?) -> Void)? = nil) {
        do {
            guard let transaction = realm.objects(TransactionTracking.self)
                .first(where: { $0._id == id })
            else {
                completion?(TrackingError.transactionNotFound(id))
                return
            }

            try realm.write {
                realm.delete(transaction)
            }
            completion?(nil)
        } catch {
            completion?(error)
        }
    }
}
