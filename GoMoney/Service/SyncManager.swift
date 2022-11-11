import UIKit

class SyncManager {
    static let shared = SyncManager()
    private init() {}

    /// Use Timer to fire sync in inteval.
    func setSyncInterval() {
        let interval = Double(SettingsManager.shared.getValue(for: .intervalSync) as? Int ?? SyncInterval.min1.rawValue)

        // firebase
        let remote = RemoteService.shared
        // temp-table
        let tracking = TrackingService.shared

        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in

            // return if no internet.
            if !ConnectionService.shared.isReachable {
                return
            }

            // loop through temp-table and sync to firebase.
            tracking.getTransactionTracking(completion: { transactions in
                transactions.forEach { transaction in
                    switch transaction.status {
                    case TransactionTracking.Status.updated.rawValue:
                        // if set firebase succesfully, remove from temp-table.
                        // else not remove
                        remote.setTransaction(by: transaction._id.stringValue, completion: { err in
                            if let err = err {
                                print("Sync fail: \(err)")
                            } else {
                                tracking.deleteTransactionTracking(by: transaction._id) { err in
                                    if let err = err {
                                        print("deleteTransactionTracking fail: \(err)")
                                    } else {
                                        SettingsManager.shared.setValue(
                                            Date().timeIntervalSince1970,
                                            for: .lastSync)
                                    }
                                }
                            }
                        })
                    case TransactionTracking.Status.deleted.rawValue:
                        // if delete from firebase sucessfully, remove from temp-table.
                        // else not remove
                        remote.deleteTransation(by: transaction._id.stringValue) { err in
                            if let err = err {
                                print("Sync fail: \(err)")
                            } else {
                                tracking.deleteTransactionTracking(by: transaction._id) { err in
                                    if let err = err {
                                        print("deleteTransactionTracking fail: \(err)")
                                    } else {
                                        SettingsManager.shared.setValue(
                                            Date().timeIntervalSince1970,
                                            for: .lastSync)
                                    }
                                }
                            }
                        }
                    default:
                        break
                    }
                }
            })
        }
    }
}
