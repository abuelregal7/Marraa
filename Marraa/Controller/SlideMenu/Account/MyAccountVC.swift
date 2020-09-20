//
//  MyAccountVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MyAccountVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var userLastLoginLabel: UILabel!
    @IBOutlet weak var userSoldAds: UILabel!
    @IBOutlet weak var userAllAds: UILabel!
    @IBOutlet weak var userDisableAds: UILabel!
    @IBOutlet weak var userName2Label: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userAccountTypeLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userPackageTypeLabel: UILabel!
    @IBOutlet weak var userFeaturedAdsLabel: UILabel!
    @IBOutlet weak var userBumbAdsLabel: UILabel!
    @IBOutlet weak var userExpirtyLabel: UILabel!
    @IBOutlet weak var unActiveAdsView: UIView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var chatUserImageView: UIImageView!
    @IBOutlet weak var callUserImageView: UIImageView!
    
    var phone:String?
    var myAccount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapUserCall = UITapGestureRecognizer(target: self, action: #selector(tapUserCall(_:)))
        callUserImageView.addGestureRecognizer(tapUserCall)
        let tapUserChat = UITapGestureRecognizer(target: self, action: #selector(tapUserChat(_:)))
        
        chatUserImageView.addGestureRecognizer(tapUserChat)
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.userImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        if myAccount{
            chatUserImageView.isHidden = true
            callUserImageView.isHidden = true
            unActiveAdsView.alpha = 1.0
            editProfileBtn.isHidden = false
            getData()
        } else {
            editProfileBtn.isHidden = true
            unActiveAdsView.alpha = 0.0
        }
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الملف الشخصي"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = true
    }
    
    func getData(){
        let header=[
            "Authorization" : "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        API.GETwithHeader(url: URLs.GetUserAccountPage, header: header) { (success, value) in
            if success{
                let dict = value
                
                let user_pic = dict["user_pic"] as? String ?? ""
                let displayName = dict["display_name"] as? String ?? ""
                let userEmail = dict["user_email"] as? String ?? ""
                let userPhone = dict["user_phone"] as? String ?? ""
                let userAddress = dict["user_address"] as? String ?? ""
                let userType = dict["user_type"] as? String ?? ""
                let userPkgType = dict["user_pkg_type"] as? String ?? ""
                let userLastlogin = dict["user_lastlogin"] as? String ?? ""
                let userRating = dict["user_rating"] as? String ?? "0"
                let soldAds = dict["sold_ads"] as? Int ?? 0
                let allAds = dict["all_ads"] as? String ?? "0"
                let disbaleAds = dict["disbale_ads"] as? Int ?? 0
                let expiry = dict["expiry"] as? String ?? "ابدا"
                let featuredAds = dict["featured_ads"] as? String ?? "0"
                let bumpAds = dict["bump_ads"] as? String ?? "0"
                
                self.phone = userPhone
                
                if user_pic != nil {
                    self.userImage.setImageWith(user_pic.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
                }
                
                UserDefaults.standard.set(user_pic, forKey: "user_pic")

                self.userNameLabel.text = displayName
                self.userRatingLabel.text = userRating
                self.userLastLoginLabel.text = "اخر تسجيل دخول منذ \(userLastlogin)"
                self.userSoldAds.text = "\(soldAds)"
                self.userAllAds.text = allAds
                self.userDisableAds.text = "\(disbaleAds)"
                self.userName2Label.text = displayName
                self.userEmailLabel.text = userEmail
                self.userPhone.text = userPhone.isEmpty ? "لا يوجد" : userPhone
                self.userAccountTypeLabel.text = userType.isEmpty ? "لم يحدد" : userType
                self.userLocationLabel.text = userAddress.isEmpty ? "لم يحدد" : userAddress
                self.userPackageTypeLabel.text = userPkgType.isEmpty ? "مجانية" : userPkgType
                self.userFeaturedAdsLabel.text = featuredAds
                self.userBumbAdsLabel.text = bumpAds
                self.userExpirtyLabel.text = expiry
                
                
            } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getData()
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tapUserCall(_ recognizer: UITapGestureRecognizer){
        print(phone)
        if phone != nil , !(phone?.isEmpty)! {
            let myString = phone
            let formattedString = myString!.replacingOccurrences(of: " ", with: "")
            print(formattedString)
            if let url = URL(string: "tel://\(formattedString)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                print(url)
            }
        } else {
            Alert.showAlertOnVC(target: self, title: "معذره", message: "المستخدم لم يضع رقم هاتفه أو لا يريد الاتصال")
        }
    }

    @objc func tapUserChat(_ recognizer: UITapGestureRecognizer){
        print(1)
    }
    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        vc.name = userNameLabel.text
        vc.email = userEmailLabel.text
        vc.phone = userPhone.text
        vc.location = userLocationLabel.text
        self.show(vc, sender: nil)
    }
}
