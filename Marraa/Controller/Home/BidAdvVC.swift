//
//  BidAdvVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class BidAdvVC: UIViewController {

    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var bidCommentTextView: UITextView!
    @IBOutlet weak var outerView: UIView!
    
    var advId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bidCommentTextView.text = "اترك تعليق"
        bidCommentTextView.textColor = UIColor.lightGray
        bidCommentTextView.delegate = self
        bidCommentTextView.layer.borderWidth = 1.0
        bidCommentTextView.layer.borderColor = #colorLiteral(red: 0.342025131, green: 0.7362204194, blue: 0.931856513, alpha: 1)
        
        priceTextView.text = "مبلغ السوم"
        priceTextView.textColor = UIColor.lightGray
        priceTextView.delegate = self
        priceTextView.layer.borderWidth = 1.0
        priceTextView.layer.borderColor = #colorLiteral(red: 0.342025131, green: 0.7362204194, blue: 0.931856513, alpha: 1)
        
        outerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outerViewDissmis(_:))))
    }
    
    @objc func outerViewDissmis(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        guard let price = priceTextView.text , !(priceTextView.text.isEmpty) else {
            return Alert.showAlertOnVC(target: self, title: "يجب أن تقوم بكتابة السعر", message: "")
        }
        
        guard let comment = bidCommentTextView.text , !(bidCommentTextView.text.isEmpty) else {
            return Alert.showAlertOnVC(target: self, title: "لا يمكنك ارسال تعليق فارغ", message: "قم بكتابة تعليق")
        }
        
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body = [
            "ad_id":advId!,
            "bid_comment":comment,
            "bid_amount":price
            ] as [String : Any]
        
        API.POST(url: URLs.bidAdv, parameters: body, headers: header) { (success, value) in
            if success{
                if let  msg = value["message"] as? String{
                    if msg == "Ad author can't post bid."{
                        Alert.showAlert(target: self, title: "صاحب الإعلان لا يمكنه القيام بذلك", message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
                if let s = value["success"] as? String{
                    if s == "تم النشر بنجاح" {
                        Alert.showAlert(target: self, title: s, message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else if s == "تم التحديث بنجاح"{
                        Alert.showAlert(target: self, title: s, message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}

extension BidAdvVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.tag == 2{
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView.textColor == UIColor.lightGray && textView.tag == 1{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView.tag == 2{
            textView.text = "اترك تعليق"
            textView.textColor = UIColor.lightGray
        }
        if textView.text.isEmpty && textView.tag == 1{
            textView.text = "مبلغ السوم"
            textView.textColor = UIColor.lightGray
        }
    }
}
