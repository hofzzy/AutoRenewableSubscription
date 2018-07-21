//
//  SubscribeTableViewController.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/03.
 //

import UIKit

class SubscribeTableViewController: UITableViewController {
  
  // MARK: - Instance Properties
  var subscriptions = [Subscription]()

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
}

// MARK: - UITableViewDataSource
extension SubscribeTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subscriptions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Subscription", for: indexPath) as! SubscriptionTableViewCell
    cell.prepareUI(subscription: subscriptions[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SubscribeTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    SubscriptionService.shared.purchase(subscription: subscriptions[indexPath.row])
  }
}

// MARK: - UI Methods
extension SubscribeTableViewController {
  private func prepareUI() {
    tableView.tableFooterView = UIView(frame: .zero)
    subscriptions = SubscriptionService.shared.subscriptions
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseSuccess(notification:)),
                                           name: SubscriptionService.purchaseSuccessNotification,
                                           object: nil)
  }
  
  @objc private func handlePurchaseSuccess(notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
}
