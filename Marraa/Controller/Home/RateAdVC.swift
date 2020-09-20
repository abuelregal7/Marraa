//
//  RateAdVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import Cosmos

class RateAdVC: UIViewController {

    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var outerView: UIView!
    
    var userId:String?
    var adId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.text = "اترك تعليق"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = #colorLiteral(red: 0.342025131, green: 0.7362204194, blue: 0.931856513, alpha: 1)
        
        outerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outerViewDissmis(_:))))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func outerViewDissmis(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        guard let comment = commentTextView.text , !(commentTextView.text.isEmpty) else {
            return Alert.showAlertOnVC(target: self, title: "لا يمكنك ارسال تعليق فارغ", message: "قم بكتابة تعليق")
        }
        
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body=[
            "user": userId!,
            "comment": comment,
            "rating": rate.rating
            ] as [String : Any]
        API.POST(url: URLs.RateUser, parameters: body, headers: header) { (success, value) in
            if success{
                let dict = value
                if let msg = dict["message"] as? String{
                    Alert.showAlert(target: self, title: msg, message: "", okAction: "تجاهل", actionCompletion: { (ـ) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }else if let s = dict["success"] as? String{
                    Alert.showAlert(target: self, title: s, message: "", okAction: "تجاهل", actionCompletion: { (ـ) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}

extension RateAdVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "اترك تعليق"
            textView.textColor = UIColor.lightGray
        }
    }
}
