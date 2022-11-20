import UIKit

import RealmSwift
import UIKit

class TransactionTracking: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var status: Int

    convenience init(id: ObjectId, status: Status) {
        self.init()
        _id = id
        self.status = status.rawValue
    }

    enum Status: Int {
        case updated = 0
        case deleted = 1
    }
}
