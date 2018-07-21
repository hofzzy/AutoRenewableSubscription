//
//  SubscriptionService.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/03.
//

import StoreKit

class SubscriptionService: NSObject {
  
  static let itcAccountSecret = ""
  
  static let sessionIdDidSetNotification = Notification.Name("sessionid.didset")
  static let purchaseSuccessNotification = Notification.Name("purchase.success")
  static let restoreSuccessNotification = Notification.Name("restore.success")
  
  static let shared = SubscriptionService()
  
  var hasReceiptData: Bool {
    return fetchReceipt() != nil
  }
  var subscriptions = [Subscription]()
  var currentSession: Session?
  
  func loadSubscriptions() {
    let allAccessWeekly = "allaccess"
    let allAccessMonthly = "allaccessmonthly"
    let productIDs = Set([allAccessWeekly, allAccessMonthly])
    
    let request = SKProductsRequest(productIdentifiers: productIDs)
    request.delegate = self
    request.start()
  }
  
  func purchase(subscription: Subscription) {
    let payment = SKPayment(product: subscription.product)
    SKPaymentQueue.default().add(payment)
  }
  
  func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func uploadReceipt(completion: (() -> Void)? = nil) {
    guard let receiptData = fetchReceipt() else { return }
    
    let body = [
      "receipt-data": receiptData.base64EncodedString(),
      "password": SubscriptionService.itcAccountSecret
    ]
    let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
    
    var request = URLRequest(url: URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!)
    request.httpMethod = "POST"
    request.httpBody = bodyData
    
    let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
      if let data = responseData {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
        let session = Session(parsedReceipt: json)
        self.currentSession = session
        NotificationCenter.default.post(name: SubscriptionService.sessionIdDidSetNotification, object: nil)
        completion?()
      } else if let error = error {
        print("❌ Invalidate receipt: \(error.localizedDescription)")
      }
    }
    task.resume()
  }
  
  private func fetchReceipt() -> Data? {
    guard let url = Bundle.main.appStoreReceiptURL else { return nil }
    
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      print("❌ Failed loading receipt data: \(error.localizedDescription)")
      return nil
    }
  }
}

extension SubscriptionService: SKProductsRequestDelegate {
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    subscriptions = response.products.map { Subscription(product: $0) }
    
    response.invalidProductIdentifiers.forEach {
      print("❌ Invalid product identifier: \($0)")
    }
  }
}
