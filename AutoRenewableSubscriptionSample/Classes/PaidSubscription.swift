//
//  PaidSubscription.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/04.
//

import Foundation

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "ja_JP")
  formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
  return formatter
}()

struct PaidSubscription {
  enum SubscriptionType {
    case weekly
    case monthly
    
    init?(productId: String) {
      if productId.contains("allaccessmonthly") {
        self = .monthly
      } else if productId.contains("allaccess") {
        self = .weekly
      } else {
        return nil
      }
    }
  }
  
  let productId: String
  let purchaseDate: Date
  let expiresDate: Date
  let subscriptionType: SubscriptionType
  
  var isActive: Bool {
    return (purchaseDate...expiresDate).contains(Date())
  }
  
  init?(json: [String: Any]) {
    guard
      let productId = json["product_id"] as? String,
      let purchaseDateString = json["purchase_date"] as? String,
      let purchaseDate = dateFormatter.date(from: purchaseDateString),
      let expiresDateString = json["expires_date"] as? String,
      let expiresDate = dateFormatter.date(from: expiresDateString),
      let subscriptionType = SubscriptionType(productId: productId)
    else {
      return nil
    }
    self.productId = productId
    self.purchaseDate = purchaseDate
    self.expiresDate = expiresDate
    self.subscriptionType = subscriptionType
  }
}
