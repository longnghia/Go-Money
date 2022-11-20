import UIKit

class SyncManager {
    static let shared = SyncManager()
    private init() {}

    /// Use Timer to fire sync in inteval.
    func setSyncInterval() {
        let interval = Double(SettingsManager.shared.getValue(for: .intervalSync) as? Int ?? SyncInterval.min1.rawValue)

        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in

            // return if no internet.
            if !ConnectionService.shared.isReachable {
                return
            }

            self?.syncTransactions()
            self?.syncTags()
            self?.syncUserInfo()
        }
    }

    func syncTransactions() {
        // firebase
        let remote = RemoteService.shared
        // temp-table
        let tracking = TrackingService.shared

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
                                    self.setSyncTime()
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
                                    self.setSyncTime()
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

    func syncUserInfo() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.needSyncUserInfo) {
            RemoteService.shared.setTags(tags: TagService.shared.all, completion: { err in
                if let err = err {
                    print("[syncUserInfo] Error \(err)")
                } else {
                    UserDefaults.standard.set(false, forKey: UserDefaultKey.needSyncUserInfo)
                    self.setSyncTime()
                }
            })
        }
    }

    func syncTags() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.needSyncTag) {
            RemoteService.shared.setTags(tags: TagService.shared.all, completion: { err in
                if let err = err {
                    print("[syncTags] Error \(err)")
                } else {
                    UserDefaults.standard.set(false, forKey: UserDefaultKey.needSyncTag)
                    self.setSyncTime()
                }
            })
        }
    }

    private func setSyncTime() {
        SettingsManager.shared.setValue(
            Date().timeIntervalSince1970,
            for: .lastSync
        )
    }
}
