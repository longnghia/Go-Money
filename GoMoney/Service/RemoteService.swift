import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift
import UIKit

typealias RemoteCompletion = (Error?) -> Void

class RemoteService {
    static let shared = RemoteService()
    let local = DataService.shared

    private init() {}

    private let db = Firestore.firestore()

    func getAllTransactions(completion: @escaping ((Result<[Expense], Error>) -> Void)) {
        self.db.collection("transactions")
            .document("user-123456")
            .collection("transactions")
            .getDocuments { snapshot, err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    var list = [Expense]()

                    snapshot?.documents.forEach {
                        let id = $0.documentID
                        var data = try? $0.data(as: Expense.self)

                        if let data = data {
                            list.append(data)
                        }
                    }
                    completion(.success(list))
                }
            }
    }

    /// set transaction to firebase.
    /// query transaction in main-table, use id in temp-table
    func setTransaction(by id: String, completion: @escaping RemoteCompletion) {
        self.local.getTransaction(by: id) { transaction in
            guard let transaction = transaction else {
                print("Transaction \(id) not found at local.")
                return
            }
            do {
                try self.db.collection("transactions")
                    .document("user-123456")
                    .collection("transactions")
                    .document(id)
                    .setData(from: transaction)

                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    /// remove transaction to firebase.
    func deleteTransation(by id: String, completion: @escaping RemoteCompletion) {
        self.db.collection("transactions")
            .document("user-123456")
            .collection("transactions")
            .document(id)
            .delete { err in
                completion(err)
            }
    }
}
