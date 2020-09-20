//
//  AppDelegate.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
import GoogleSignIn
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2862745098, green: 0.6784313725, blue: 0.9137254902, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont(name: "Cairo-SemiBold", size: 20.0)!]
        if UserDefaults.standard.value(forKey: "token") != nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let nav = UINavigationController(rootViewController: mainVC)
            let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
            window?.rootViewController = sideMenu
        }
        IQKeyboardManager.shared.enable = true
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.rightViewWidth = UIScreen.main.bounds.width - 50.0
        UIApplication.shared.statusBarStyle = .lightContent
        GIDSignIn.sharedInstance().clientID = "190471430867-nh5c86t6duibcvb09r1a796cqjljpsvv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate : GIDSignInDelegate{
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email

            UserDefaults.standard.set(email, forKey: "googleEmail")
            UserDefaults.standard.set(true, forKey: "google")
            print("GoogleEmail ",email)
            print("fullName ", fullName)
            print("givenName ", givenName)
            print("familyName ", familyName)
            print("idToken ", idToken)
            print("userId ", userId)

            let body = [
                "email":email
            ]
            API.POST(url: URLs.socialLogin, parameters: body, headers: nil) { (success, value) in
                if success{
                    if let token = value["token"] as? String{
                        let user_email = value["user_email"] as? String ?? ""
                        let userNicename = value["user_nicename"] as? String ?? ""
                        let user_id = value["user_id"] as? String ?? ""
                        let rating = value["rating"] as? String ?? ""
                        
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(rating, forKey: "rating")
                        UserDefaults.standard.set(userNicename, forKey: "user_nicename")
                        UserDefaults.standard.set(userId, forKey: "user_id")
                        UserDefaults.standard.set(user_email, forKey: "user_email")

                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                        let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let nav = UINavigationController(rootViewController: mainVC)
                        let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                        self.window?.rootViewController = sideMenu
                    }
                }else{
                    print("error")
                }
            }
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        //TODO:// make a sign out and go to first page again (login)
        
    }
}
