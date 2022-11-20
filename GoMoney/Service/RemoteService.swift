import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift

typealias RemoteCompletion = (Error?) -> Void

class RemoteService {
    static let shared = RemoteService()
    let local = DataService.shared
    let tagService = TagService.shared

    private init() {}

    private let db = Firestore.firestore()

    let userId = { Auth.auth().currentUser?.uid }

    /// Get all remote transaction on first login.
    func getAllTransactions(completion: @escaping ((Result<[Expense], Error>) -> Void)) {
        guard let userId = userId() else {
            completion(.failure(DataError.userNotFound))
            return
        }

        print("userId=\(userId)")

        self.db.collection("transactions")
            .document(userId)
            .collection("transactions")
            .getDocuments { snapshot, err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    var list = [Expense]()
                    snapshot?.documents.forEach {
                        if let data = try? $0.data(as: RemoteTransaction.self) {
                            if let transaction = self.remoteTransactionToRealmTransaction(remote: data) {
                                list.append(transaction)
                            }
                        }
                    }
                    completion(.success(list))
                }
            }
    }

    /// set transaction to firebase.
    /// query transaction in main-table, use id in temp-table
    func setTransaction(by id: String, completion: @escaping RemoteCompletion) {
        guard let userId = userId() else {
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
        guard let userId = userId() else {
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

    private func remoteTransactionToRealmTransaction(remote: RemoteTransaction) -> Expense? {
        guard
            let type = ExpenseType(rawValue: remote.type)
        else {
            return nil
        }

        if let tag = TagService.shared.getTagById(remote.tag) {
            return Expense(type: type, tag: tag, amount: remote.amount, note: remote.note, occuredOn: remote.occuredOn, createdAt: remote.createdAt, updatedAt: remote.updatedAt)
        }
        return nil
    }
}

// remote tag table
extension RemoteService {
    /// Get all remote tag
    func getAllTags(completion: @escaping ((Result<[TransactionTag], Error>) -> Void)) {
        guard let userId = userId() else {
            completion(.failure(DataError.userNotFound))
            return
        }

        print("userId=\(userId)")
        let doc = self.db
            .collection("tags")
            .document(userId)

        doc.getDocument { snapshot, err in
            if let err = err {
                completion(.failure(err))
            } else {
                let list = try? snapshot?.data(as: [String: [TransactionTag]].self)
                completion(.success(list?["tags"] ?? TransactionTag.defaults))
            }
        }
    }

    /// set tags on firebase:
    func setTags(tags: [TransactionTag], completion: @escaping RemoteCompletion) {
        guard let userId = userId() else {
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

// remote user table
extension RemoteService {
    func getUserData(completion: @escaping ((Result<GMUser, Error>) -> Void)) {
        guard let userId = userId() else {
            completion(.failure(DataError.userNotFound))
            return
        }

        self.db.collection("info")
            .document(userId)
            .getDocument(as: GMUser.self) { result in
                completion(result)
                switch result {
                case .success(let user):
                    print("City: \(user)")
                case .failure(let error):
                    print("Error decoding city: \(error)")
                }
            }
    }

    func checkIfUserExist(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userId = userId() else {
            completion(.failure(DataError.userNotFound))
            return
        }
        let ref = self.db.collection("tags")
            .document(userId)

        ref.getDocument { snapShot, err in
            if let err = err {
                completion(.failure(err))
            } else {
                if let snapShot = snapShot {
                    completion(.success(snapShot.exists))
                } else {
                    print("Unknown error")
                }
            }
        }
    }

    func setUserData() {}

    func restoreUserData() {}
}
