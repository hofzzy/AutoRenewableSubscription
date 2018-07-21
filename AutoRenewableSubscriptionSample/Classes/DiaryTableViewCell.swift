//
//  DiaryTableViewCell.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/04.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func prepareUI(diary: Diary) {
    titleLabel.text = diary.title
    userLabel.text = diary.user
    dateLabel.text = "on " + diary.date
    bodyLabel.text = diary.body
  }
}
