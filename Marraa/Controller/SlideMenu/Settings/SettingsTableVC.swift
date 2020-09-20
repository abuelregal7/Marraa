//
//  SettingsTableVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
class SettingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsVC")
            let nav = UINavigationController(rootViewController: mainVC)
            let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
            self.presentDetails(viewControllerToPresent: sideMenu)
        }else if indexPath.row == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "FAQVC") 
            let nav = UINavigationController(rootViewController: mainVC)
            let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
            self.presentDetails(viewControllerToPresent: sideMenu)
        }else if indexPath.row == 2 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            let nav = UINavigationController(rootViewController: mainVC)
            let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
            self.presentDetails(viewControllerToPresent: sideMenu)
        }else if indexPath.row == 3 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            let nav = UINavigationController(rootViewController: mainVC)
            let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
            self.presentDetails(viewControllerToPresent: sideMenu)
        }else if indexPath.row == 4 {
            UIApplication.shared.open(URL(string : "https://www.marraa.com/news/")!, options: [:], completionHandler: { (status) in
                
            })
        }
    }
}
