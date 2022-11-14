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
    let tagService = TagService.shared

    private init() {}

    private let db = Firestore.firestore()

    let userId = Auth.auth().currentUser?.uid

    /// Get all remote transaction on first login.
    func getAllTransactions(completion: @escaping ((Result<[Expense], Error>) -> Void)) {
        guard let userId = userId else {
            completion(.failure(DataError.userNotFound))
            return
        }

        self.db.collection("transactions")
            .document(userId)
            .collection("transactions")
            .getDocuments { snapshot, err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    var list = [Expense]()

                    snapshot?.documents.forEach {
                        let id = $0.documentID
                        let data = try? $0.data(as: Expense.self)
                        if let data = data {
                            data._id = try! ObjectId(string: String(id))
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
        guard let userId = userId else {
            completion(DataError.userNotFound)
            return
        }

        self.local.getTransaction(by: id) { transaction in
            guard let transaction = transaction else {
                print("Transaction \(id) not found at local.")
                return
            }
            do {
                try self.db.collection("transactions")
                    .document(userId)
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
        guard let userId = userId else {
            completion(DataError.userNotFound)
            return
        }

        self.db.collection("transactions")
            .document(userId)
            .collection("transactions")
            .document(id)
            .delete { err in
                completion(err)
            }
    }

    /// set tags on firebase:
    func setTags(tags: [TransactionTag], completion: @escaping RemoteCompletion) {
        guard let userId = userId else {
            completion(DataError.userNotFound)
            return
        }

        let doc = self.db
            .collection("tags")
            .document(userId)

        doc.delete { err in
            if let err = err {
                completion(err)
            } else {
                do {
                    try doc.setData(from: ["tags": tags]) { err in
                        if let err = err {
                            completion(err)
                        } else {
                            completion(nil)
                        }
                    }
                } catch {
                    completion(error)
                }
            }
        }
    }
}
