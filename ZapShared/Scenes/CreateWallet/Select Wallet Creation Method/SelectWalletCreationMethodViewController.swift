//
//  Zap
//
//  Created by Otto Suess on 09.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateSetupViewController(createButtonTapped: @escaping () -> Void, recoverButtonTapped: @escaping () -> Void, connectButtonTapped: @escaping () -> Void) -> UINavigationController {
        
        let navigationController = Storyboard.createWallet.initial(viewController: UINavigationController.self)
        if let setupWalletViewController = navigationController.topViewController as? SelectWalletCreationMethodViewController {
            setupWalletViewController.createButtonTapped = createButtonTapped
            setupWalletViewController.recoverButtonTapped = recoverButtonTapped
            setupWalletViewController.connectButtonTapped = connectButtonTapped
        }
        return navigationController
    }
}

final class SelectWalletCreationMethodViewController: UIViewController {
    fileprivate var createButtonTapped: (() -> Void)?
    fileprivate var recoverButtonTapped: (() -> Void)?
    fileprivate var connectButtonTapped: (() -> Void)?
    
    @IBOutlet private weak var tableView: UITableView!
    
    // swiftlint:disable:next large_tuple
    var content: [(String, String, (() -> Void))]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = [
            ("Create", "new wallet", { [weak self] in self?.createButtonTapped?() }),
            ("Recover", "existing wallet", { self.recoverButtonTapped?() }),
            ("Connect", "remote node", { self.connectButtonTapped?() })
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 140
        tableView.isScrollEnabled = false
        tableView.registerCell(SelectWalletCreationMethodTableViewCell.self)
        tableView.backgroundColor = UIColor.zap.charcoalGrey
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}

extension SelectWalletCreationMethodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellContent = content?[indexPath.row] else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        cellContent.2()
    }
}

extension SelectWalletCreationMethodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectWalletCreationMethodTableViewCell = tableView.dequeueCellForIndexPath(indexPath)
        if let cellContent = content?[indexPath.row] {
            cell.set(title: cellContent.0, description: cellContent.1)
        }
        return cell
    }
}