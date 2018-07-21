//
//  Subscription.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/03.
//

import StoreKit

private var formatter: NumberFormatter {
  let formatter = NumberFormatter()
  formatter.formatterBehavior = .behavior10_4
  formatter.numberStyle = .currency
  return formatter
}

struct Subscription {
  let product: SKProduct
  let formattedPrice: String
  
  init(product: SKProduct) {
    self.product = product
    
    if formatter.locale != self.product.priceLocale {
      formatter.locale = self.product.priceLocale
    }
    formattedPrice = formatter.string(from: product.price) ?? "\(product.price)"
  }
}
