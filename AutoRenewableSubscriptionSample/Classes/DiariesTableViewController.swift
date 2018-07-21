//
//  DiariesTableViewController.swift
//  AutoRenewableSubscriptionSample
//
//  Created by 増山 洸輝 on 2018/07/04.
//

import UIKit

struct Diary {
  let title: String
  let body: String
  let user: String
  let date: String
}

class DiariesTableViewController: UITableViewController {
  
  // MARK: - Instance Properties
  private var diaries = [Diary]()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
}

// MARK: - UITableViewDataSource
extension DiariesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diaries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as! DiaryTableViewCell
    cell.prepareUI(diary: diaries[indexPath.row])
    return cell
  }
}

// MARK: - UI Methods
extension DiariesTableViewController {
  private func prepareUI() {
    tableView.tableFooterView = UIView(frame: .zero)
    
    guard
      let session = SubscriptionService.shared.currentSession,
      session.currentSubscription != nil,
      SubscriptionService.shared.hasReceiptData
    else {
      showRestoreAlert()
      return
    }
    fetchDiaries()
  }
  
  private func showRestoreAlert() {
    let alertController = UIAlertController(
      title: "Subscription Issue",
      message: "We are having a hard time finding your subscription. If you've recently reinstalled the app or got a new device please choose to restore your purchase. Otherwise go Back to Subscribe.",
      preferredStyle: .alert
    )
    let restoreAction = UIAlertAction(title: "Restore", style: .default) { [weak self] _ in
      SubscriptionService.shared.restorePurchases()
      self?.showRestoreProgressAlert()
    }
    let backAction = UIAlertAction(title: "Back", style: .cancel) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    alertController.addAction(restoreAction)
    alertController.addAction(backAction)
    
    present(alertController, animated: true)
  }
  
  private func showRestoreProgressAlert() {
    let alertController = UIAlertController(
      title: "Restoring Purchase",
      message: "Your purchase history is being restored. Upon completion this dialog will close and you will be sent back to the previous screen where you can then comeback in to load your purchases.",
      preferredStyle: .alert
    )
    present(alertController, animated: true)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseSuccess(notification:)),
                                           name: SubscriptionService.restoreSuccessNotification,
                                           object: nil)
  }
  
  @objc private func handlePurchaseSuccess(notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      self?.dismiss(animated: true)
      self?.prepareUI()
      self?.tableView.reloadData()
    }
  }
  
  private func fetchDiaries() {
    diaries = [Diary(title: "", body: "", user: "", date: "")]
  }
}
