//
//  ChangePasswordVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "تغيير كلمة المرور"
        self.navigationItem.hidesBackButton = false
    }

    @IBAction func changePasswordBtnPressed(_ sender: Any) {
        
        guard let oldPassword = oldPasswordTextField.text , !((oldPasswordTextField.text?.isEmpty)!) else{
            return Alert.showAlertOnVC(target: self, title: "يوجد حقل فارغ", message: "قم بإدخال كلمة المرور الحالية")
        }
        
        guard let newPassword = newPasswordTextField.text , !((newPasswordTextField.text?.isEmpty)!) else{
            return Alert.showAlertOnVC(target: self, title: "يوجد حقل فارغ", message: "قم بإدخال كلمة المرور الجديدة")
        }
        guard let confirmNewPassword = confirmNewPasswordTextField.text , !((confirmNewPasswordTextField.text?.isEmpty)!) else{
            return Alert.showAlertOnVC(target: self, title: "يوجد حقل فارغ", message: "قم بإدخال تأكيد كلمة المرور الجديدة")
        }
        
        if newPassword != confirmNewPassword {
            return Alert.showAlertOnVC(target: self, title: "كلمتي المرور غير متطابقتين", message: "تأكد من أن كلمة المرور الجديدة هي نفسها تأكيد كلمة المرور الجديدة")
        }
        
        let header=[
            "Authorization" : "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body = [
            "current_pass":oldPassword,
            "new_pass":newPassword,
            "con_new_pass":confirmNewPassword
        ]
        API.POST(url: URLs.ChangeUserPassword, parameters: body, headers: header) { (success, value) in
            if success{
                let dict = value
                if let code = dict["code"] as? String{
                    if code == "rest_change_password_current_not_matched"{
                        return Alert.showAlertOnVC(target: self, title: "كلمة المرور الحالية غير صحيحة", message: "تأكد من إدخالك لكلمة المرور الحالية والمسجلة لدينا")
                    }
                }
                if let s = dict["success"] as? String{
                    Alert.showAlert(target: self, title: s, message: "", okAction: "الذهاب لتسجيل الدخول مجددا", actionCompletion: { (ـ) in
                        //sign out
                        
                        //go out to login again
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "FirstVC")
                        self.present(vc, animated: true, completion: nil)
                    })
                }
            } else {
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}
