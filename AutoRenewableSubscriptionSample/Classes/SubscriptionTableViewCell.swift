//
//  SubscriptionTableViewCell.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/03.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var yourPlanLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    yourPlanLabel.isHidden = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func prepareUI(subscription: Subscription) {
    nameLabel.text = subscription.product.localizedTitle
    descriptionLabel.text = subscription.product.localizedDescription
    priceLabel.text = subscription.formattedPrice
    if
      let session = SubscriptionService.shared.currentSession,
      let currentSubscription = session.currentSubscription,
      subscription.product.productIdentifier == currentSubscription.productId
    {
      contentView.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.6745098039, blue: 0.1960784314, alpha: 1)
      yourPlanLabel.isHidden = false
    }
  }
}
