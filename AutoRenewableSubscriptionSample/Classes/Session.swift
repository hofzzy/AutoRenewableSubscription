//
//  Session.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/04.
//

import Foundation

typealias SessionId = String

struct Session {
  let id: SessionId
  let paidSubscriptions: [PaidSubscription]
  
  var currentSubscription: PaidSubscription? {
    let activeSubscriptions = paidSubscriptions.filter { $0.isActive }
    let sortedByLatestPurchaseDate = activeSubscriptions.sorted { $0.purchaseDate > $1.purchaseDate }
    return sortedByLatestPurchaseDate.first
  }
  
  init(parsedReceipt: [String: Any]) {
    id = UUID().uuidString
    
    guard let latestReceipt = parsedReceipt["latest_receipt_info"] as? Array<[String: Any]> else {
      paidSubscriptions = []
      return
    }
    var subscriptions = [PaidSubscription]()
    for receipt in latestReceipt {
      if let paidSubscription = PaidSubscription(json: receipt) {
        subscriptions.append(paidSubscription)
      }
    }
    paidSubscriptions = subscriptions
  }
}
