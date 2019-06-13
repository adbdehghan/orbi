//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit
import SideMenuSwift

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuViewController: UIViewController {
    var isDarkModeEnabled = false
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .none
        }
    }
    @IBOutlet weak var selectionTableViewHeader: UILabel!

    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController")
        }, with: "1")

        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")
        }, with: "2")

        sideMenuController?.delegate = self
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }

    private func configureView() {

        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2980392157, blue: 0.5490196078, alpha: 1)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        view.layoutIfNeeded()
    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 1)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }

    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        cell.contentView.backgroundColor = .none
        cell.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2980392157, blue: 0.5490196078, alpha: 1)
        
        cell.titleLabel.font = UIFont(name: "Vazir-Bold", size: 20)
        cell.titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let row = indexPath.row
        if row == 0 {
            cell.titleLabel?.text = "اوربی"
            cell.iconUIImageView.image = UIImage(named: "orbi_setting")
        
        } else if row == 1 {
            cell.titleLabel?.text = "پشتیبانی"
            cell.iconUIImageView.image = UIImage(named: "orbi_support")
        } else if row == 2 {
            cell.titleLabel?.text = "درباره ما"
            cell.iconUIImageView.image = UIImage(named: "orbi_contact")
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0.2364221811, green: 0.213052392, blue: 0.4845560789, alpha: 1)
        cell.selectedBackgroundView = selectedView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row       
        sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)

        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconUIImageView: UIImageView!
}
