//
//  LoginVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import GoogleSignIn

class LoginVC: UIViewController {
    
    var remeber_clicked = false
    
    @IBOutlet weak var RememberMePic:UIImageView!
    @IBOutlet weak var emailTextField: InsertTextField!
    @IBOutlet weak var passwordTextField: InsertTextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPasswordBtn.setAttributedTitle(NSAttributedString(string:"هل نسيت كلمة المرور ؟", attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2862745098, green: 0.6784313725, blue: 0.9137254902, alpha: 1),]), for: .normal)
        checkRemember()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setNavBar()
        
    }
    
    func setNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func checkRemember(){
        if (UserDefaults.standard.value(forKey: "isRemember") != nil) {
            let Email = UserDefaults.standard.value(forKey: "emailRemember") as? String
            let password = UserDefaults.standard.value(forKey: "passwordRemember") as? String
            self.emailTextField.text = Email
            self.passwordTextField.text = password
            remeber_clicked = true
            self.RememberMePic.image = UIImage(named: "check_on")
        } else{
            self.RememberMePic.image = UIImage(named: "check_off")
            remeber_clicked = false
        }
    }
    
    @IBAction func tooglePasswordBtnPressed(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry == true{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "view-eye-interface-symbol"), for: .normal)
        }else{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "view-eye-interface-symbol-1"), for: .normal) 
        }
    }
    
    @IBAction func forgetPasswordBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordVC")
        self.show(vc, sender: nil)
    }
    
    @IBAction func  rememberMeBtn(_ sender:UIButton){
        if remeber_clicked == false {
            self.RememberMePic.image = UIImage(named: "check_on")
            UserDefaults.standard.set(true, forKey: "isRemember")
            remeber_clicked = true
        } else{
            self.RememberMePic.image = UIImage(named: "check_off")
            UserDefaults.standard.removeObject(forKey: "isRemember")
            remeber_clicked = false
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        guard let userName = emailTextField.text , !(emailTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل اسم المستخدم")
                return
        }
        
        guard let password = passwordTextField.text , !(passwordTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل كلمة المرور")
                return
        }
        
        let body = [
            "username": userName,
            "password": password
        ]
        API.POST(url: URLs.Login, parameters: body, headers: nil) { (success, value) in
            if success{
                let dict = value
                if let token = dict["token"] as? String{
                    
                    UserDefaults.standard.set(token, forKey: "token")
                    let rating = dict["rating"] as? String ?? ""
                    UserDefaults.standard.set(rating, forKey: "rating")
                    let userNicename = dict["user_nicename"] as? String ?? ""
                    UserDefaults.standard.set(userNicename, forKey: "user_nicename")
                    let userId = dict["user_id"] as? String ?? ""
                    UserDefaults.standard.set(userId, forKey: "user_id")
                    let userEmail = dict["user_email"] as? String ?? ""
                    UserDefaults.standard.set(userEmail, forKey: "user_email")
                    if (UserDefaults.standard.value(forKey: "isRemember") != nil) {
                        UserDefaults.standard.set(userName, forKey: "emailRemember")
                        UserDefaults.standard.set(password, forKey: "passwordRemember")
                    }
                    let userRole = dict["user_role"] as? String ?? ""
                    UserDefaults.standard.set(userRole, forKey: "user_role")
                    UserDefaults.standard.set("no", forKey: "vistor")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                    let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let nav = UINavigationController(rootViewController: mainVC)
                    mainVC.setNavigationControll()
                    let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                    self.presentDetails(viewControllerToPresent: sideMenu)
                    
                }else if let code = dict["code"] as? String{
                    if code == "[jwt_auth] invalid_username"{
                        Alert.showAlertOnVC(target: self, title: "اسم المستخدم خاطئ", message: "")
                    }else if code == "[jwt_auth] incorrect_password"{
                        Alert.showAlertOnVC(target: self, title: "كلمة المرور خاطئة", message: "")
                    }else if code == "[jwt_auth] invalid_email"{
                        Alert.showAlertOnVC(target: self, title: "الايميل الالكتروني خاطئ", message: "")
                    }
                }
            } else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
    
    @IBAction func btnVisitor(_ sender: Any) {
        UserDefaults.standard.set("yes", forKey: "vistor")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = UINavigationController(rootViewController: mainVC)
        mainVC.setNavigationControll()
        let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
        self.presentDetails(viewControllerToPresent: sideMenu)
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")
        self.show(vc, sender: nil)
    }
}

extension LoginVC : GIDSignInUIDelegate{

    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
}
