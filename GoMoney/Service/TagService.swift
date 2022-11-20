import RealmSwift

class TagService {
    static let shared = TagService()

    private init() {
        getAllTags()
    }

    var all = [TransactionTag]()
    var incomes = [TransactionTag]()
    var expenses = [TransactionTag]()

    private let realm: Realm = try! Realm()

    func getAllTags(completion: (() -> Void)? = nil) {
        let tags = realm.objects(TransactionTag.self)

        all = Array(tags)
        incomes = []
        expenses = []

        tags.forEach { tag in
            switch tag.type {
            case ExpenseType.expense.rawValue:
                expenses.append(tag)
            case ExpenseType.income.rawValue:
                incomes.append(tag)
            default:
                break
            }
        }

        completion?()
    }

    func setTags(tags: [TransactionTag], completion: @escaping (Error?) -> Void) {
        do {
            try realm.write {
                realm.add(tags)
            }
            getAllTags()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func getTagById(_ id: String) -> TransactionTag? {
        guard let objectId = try? ObjectId(string: id) else {
            return nil
        }
        return realm.object(
            ofType: TransactionTag.self,
            forPrimaryKey: objectId
        )
    }

    /// Create default database on first launch
    func createDefaultDb(completion: @escaping (Error?) -> Void) {
        do {
            try realm.write {
                realm.add(TransactionTag.defaults)
            }
            requireSync()
            getAllTags()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func remove(tag: TransactionTag, completion: @escaping (Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(tag)
            }
            requireSync()
            getAllTags()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func tagExist(_ name: String?) -> Bool {
        all.first(
            where: { $0.name == name }
        ) != nil
    }

    func add(tag: TransactionTag, completion: @escaping (String?) -> Void) {
        if tagExist(tag.name) {
            completion("\(tag.name) existed!")
            return
        }

        do {
            try realm.write {
                realm.add(tag)
            }
            requireSync()
            getAllTags()
            completion(nil)
        } catch {
            completion(error.localizedDescription)
        }
    }

    private func requireSync() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.needSyncTag)
    }
}
