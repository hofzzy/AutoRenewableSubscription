//
//  AppDelegate.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/03.
//

import StoreKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    SKPaymentQueue.default().add(self)
    SubscriptionService.shared.loadSubscriptions()
    return true
  }
}

extension AppDelegate: SKPaymentTransactionObserver {
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchasing:
        handlePurchasingState(for: transaction, in: queue)
      case .deferred:
        handleDeferredState(for: transaction, in: queue)
      case .failed:
        handleFailedState(for: transaction, in: queue)
      case .purchased:
        handlePurchasedState(for: transaction, in: queue)
      case .restored:
        handleRestoredState(for: transaction, in: queue)
      }
    }
  }
  
  func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
    print("🛒 Purchasing for product id: \(transaction.payment.productIdentifier)")
  }
  
  func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
    print("👮‍♂️ Purchase deferred for product id: \(transaction.payment.productIdentifier)")
  }
  
  func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
    print("❌ Purchase failed for product id: \(transaction.payment.productIdentifier)")
  }
  
  func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
    print("🎉 Purchased for product id: \(transaction.payment.productIdentifier)")
    
    queue.finishTransaction(transaction)
    SubscriptionService.shared.uploadReceipt {
      NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessNotification, object: nil)
    }
  }
  
  func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
    print("🛠 Purchase restored for product id: \(transaction.payment.productIdentifier)")
    
    queue.finishTransaction(transaction)
    SubscriptionService.shared.uploadReceipt {
      NotificationCenter.default.post(name: SubscriptionService.restoreSuccessNotification, object: nil)
    }
  }
}
