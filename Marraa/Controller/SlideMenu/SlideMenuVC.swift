//
//  SlideMenuVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import GoogleSignIn
class SlideMenuVC: UIViewController {

    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var name = UserDefaults.standard.value(forKeyPath: "user_nicename") as? String 
        var email = UserDefaults.standard.value(forKeyPath: "user_email") as? String
        var image = UserDefaults.standard.value(forKey: "user_pic") as? String

        userNameLabel.text = name
        userEmailLabel.text = email
        
        if image != nil {
            self.userImage.setImageWith(image!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        }
        
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
            if isVistor == "yes"{
                signOutBtn.isHidden = false
                signOutBtn.setTitle("تسجيل دخول", for: .normal)

                userEmailLabel.isHidden = true
                userNameLabel.isHidden = false
                userNameLabel.text = "زائر"
            } else {
                signOutBtn.isHidden = false
                userEmailLabel.isHidden = false
                userNameLabel.isHidden = true
                userNameLabel.text = name
                userEmailLabel.text = email
            }
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "rating")
        UserDefaults.standard.removeObject(forKey: "user_nicename")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_role")
        
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "google")
        UserDefaults.standard.removeObject(forKey: "vistor")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FirstVC")
        self.present(vc, animated: true, completion: nil)
    }
}
