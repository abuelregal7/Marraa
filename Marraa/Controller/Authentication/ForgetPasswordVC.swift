//
//  ForgetPasswordVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: InsertTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "استعادة كلمة المرور"
        
    }
    
    @IBAction func sendPasswordBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text , !(emailTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ", message: "قم بإدخال البريد الإلكتروني الخاص بك المسجل لدينا لإرسال كلمة المرور")
                return
        }
        let body = [
            "email": email
        ]
        API.POST(url: URLs.ForgetPassword, parameters: body, headers: nil) { (success, value) in
            if success{
                let dict = value
                if let message = dict["message"] as? String{
                    if message == "تم ارسال كلمة المرور على البريد الالكتروني"{
                        Alert.showAlert(target: self, title: "عملية ناجحة", message: message, okAction: "تسجيل الدخول", actionCompletion: { (ـ) in
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "FirstVC") 
                            self.present(vc, animated: true, completion: nil)
                        })
                        
                        
                    } else if message == "البريد الالكترونى خاطئ"{
                        Alert.showAlertOnVC(target: self, title: message, message: "الرجاء ادخال البريد الإلكتروني الخاص بك والمسجل لدينا")
                    }
                }
            } else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}
