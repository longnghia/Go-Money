//
//  AppDelegate.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    /// Use Timer to fire sync in inteval.
    /// This is called in HomeViewController viewDidLoad.
    func setSyncInterval() {
        //  TODO: UserDefaults value
        let interval: Double = 5

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
                                tracking.deleteTransactionTracking(by: transaction._id)
                            }
                        })
                    default:
                        // if delete from firebase sucessfully, remove from temp-table.
                        // else not remove
                        remote.deleteTransation(by: transaction._id.stringValue) { err in
                            if let err = err {
                                print("Sync fail: \(err)")
                            } else {
                                tracking.deleteTransactionTracking(by: transaction._id)
                            }
                        }
                    }
                }
            })
        }
    }
}

