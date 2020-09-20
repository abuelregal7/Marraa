//
//  ContactUsVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import  SlideMenuControllerSwift
class ContactUsVC: UIViewController {

    @IBOutlet weak var emailTextField: InsertTextField!
    @IBOutlet weak var nameTextField: InsertTextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "اتصل بنا"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "path-10"), style: .plain, target: self, action: #selector(backBtn))
    }
    
    @objc func backBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text , !(emailTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل البريد الإلكتروني")
                return
        }
        
        guard let name = nameTextField.text , !(nameTextField.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل اسم المستخدم")
                return
        }
        
        guard let content = contentTextView.text , !(contentTextView.text?.isEmpty)!
            else{
                Alert.showAlertOnVC(target: self, title: "هناك حقل فارغ", message: "ادخل نص الرسالة")
                return
        }
        
        let body=[
            "name":name,
            "email":email,
            "message":content
        ]
        API.POST(url: URLs.ContactUs, parameters: body, headers: nil) { (success, value) in
            if success{
                let dict = value
                if let msg = dict["success"] as? String{
                    Alert.showAlert(target: self, title: msg, message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
                        let mainVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                        let nav = UINavigationController(rootViewController: mainVC)
                        let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
                        self.presentDetails(viewControllerToPresent: sideMenu)
                    })
                }
                if let code = dict["code"] as? String{
                    Alert.showAlertOnVC(target: self, title: "ادخل البيانات بشكل صحيح", message: "")
                }
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}
