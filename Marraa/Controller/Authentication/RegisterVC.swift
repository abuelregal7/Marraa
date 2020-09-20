//
//  RegisterVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameTextField: InsertTextField!
    @IBOutlet weak var emailTextField: InsertTextField!
    @IBOutlet weak var phoneTextField: InsertTextField!
    @IBOutlet weak var passwordTextField: InsertTextField!
    @IBOutlet weak var checkTermsBtn: CheckBoxButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "حساب جديد"
        
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        guard let userName = userNameTextField.text , !(userNameTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل اسم المستخدم")
                return
        }
        
        guard let email = emailTextField.text , !(emailTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل البريد الإلكتروني")
                return
        }
        
        guard let phone = phoneTextField.text , !(phoneTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل رقم الهاتف")
                return
        }
        
        guard let password = passwordTextField.text , !(passwordTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل كلمة المرور")
                return
        }
        
        let body = [
            "username": userName,
            "password": password,
            "user_email": email,
            "user_phone": phone
        ]
        
        if checkTermsBtn.isChecked{
            API.POST(url: URLs.Register, parameters: body, headers: nil) { (success, value) in
                if success{
                    let dict = value
                    if let message = dict["message"] as? String{
                        if message == "المعذرة، اسم المستخدم هذا موجود مسبقاً." {
                            Alert.showAlertOnVC(target: self, title: "اسم المستخدم مستخدم من قبل", message: "")
                        } else if message == "المعذرة، عنوان البريد الإلكتروني هذا مستخدم مسبقاً!"{
                            Alert.showAlertOnVC(target: self, title: "البريد الإلكتروني مستخدم من قبل", message: "")
                        }
                    }
                    
                    if let token = dict["token"] as? String{
                        Alert.showAlert(target: self, title: "تم التسجيل بنجاح", message: "اذهب لتسجيل دخولك", okAction: "تسجيل الدخول", actionCompletion: { (ـ) in
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                            self.show(vc, sender: nil)
                        })
                        
                    }
                } else{
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                }
            }
        } else{
            Alert.showAlertOnVC(target: self, title: "يجب الموافقه علي الشروط والأحكام", message: "")
        }
    }
    
    @IBAction func tooglePasswordBtnPressed(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry == true{
            sender.setImage(#imageLiteral(resourceName: "view-eye-interface-symbol"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "view-eye-interface-symbol-1"), for: .normal)
        }
    }
}
