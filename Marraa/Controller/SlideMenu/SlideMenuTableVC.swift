//
//  SlideMenuTableVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuTableVC: UIViewController {

    var cellsUser = [SlideMenuModel(pic: #imageLiteral(resourceName: "path"), title: "الرئيسية"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "user-male-black-shape"), title: "الملف الشخصي"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "Search Icon-1"), title: "البحث المتقدم"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "Mask Group 1"), title: "الرسائل"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "path-2"), title: "الباقات"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "path-3"), title: "إعلاناتي"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "path-4"), title: "إعلاناتي المميزة"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "path-5"), title: "المفضلة"),
                     SlideMenuModel(pic: #imageLiteral(resourceName: "path-6"), title: "الإعدادات")]
    
    var cellsVistor = [SlideMenuModel(pic: #imageLiteral(resourceName: "path"), title: "الرئيسية"),
                       SlideMenuModel(pic: #imageLiteral(resourceName: "Search Icon-1"), title: "البحث المتقدم"),
                       SlideMenuModel(pic: #imageLiteral(resourceName: "path-2"), title: "الباقات"),
                       SlideMenuModel(pic: #imageLiteral(resourceName: "path-6"), title: "الإعدادات")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SlideMenuTableVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
            if isVistor == "yes"{
                return cellsVistor.count
            }else {
                return cellsUser.count
            }
        }
        return cellsUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuCell", for: indexPath) as? SlideMenuCell else {return UITableViewCell()}
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
            if isVistor == "yes"{
                let slide = cellsVistor[indexPath.row]
                cell.configureCell(slide: slide)
                
            } else {
                let slide = cellsUser[indexPath.row]
                cell.configureCell(slide: slide)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
        if isVistor == "yes"{
            switch indexPath.row {
            case 0:
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 1:
                print(2)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchVC") as! AdvancedSearchVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 2:
                print(3)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "PackegesVC") as! PackegesVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 3:
                print(4)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 1:
                print(2)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 2:
                print(3)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchVC") as! AdvancedSearchVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 3:
                print(4)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 4:
                print(5)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "PackegesVC") as! PackegesVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 5:
                print(6)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "MyAdsVC") as! MyAdsVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 6:
                print(7)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "MySpecialAdsVC") as! MySpecialAdsVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 7:
                print(8)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "FavVC") as! FavVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            case 8:
                print(9)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                let nav = UINavigationController(rootViewController: mainVC)
                let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                self.presentDetails(viewControllerToPresent: sideMenu)
            default:
                break
                
            }
         }
      }
   }
}
