//
//  UserAccountDetailesVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class UserAccountDetailesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapUserCall = UITapGestureRecognizer(target: self, action: #selector(tapUserCall(_:)))
        callUserImageView.addGestureRecognizer(tapUserCall)
        let tapUserChat = UITapGestureRecognizer(target: self, action: #selector(tapUserChat(_:)))
        chatUserImageView.addGestureRecognizer(tapUserChat)
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var userLastLoginLabel: UILabel!
    @IBOutlet weak var userSoldAds: UILabel!
    @IBOutlet weak var userAllAds: UILabel!
    @IBOutlet weak var chatUserImageView: UIImageView!
    @IBOutlet weak var callUserImageView: UIImageView!
    var phone:String?
    var myAds = [AdModel]()
    var userId:String?
    var advId:Int?
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var noAdsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        getData()
        if userId == UserDefaults.standard.value(forKey: "user_id") as! String{
            chatUserImageView.isHidden = true
            callUserImageView.isHidden = true
        }else{
            chatUserImageView.isHidden = false
            callUserImageView.isHidden = false
        }
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الملف الشخصي"
        
        self.navigationItem.hidesBackButton = false
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
        } else{
            Alert.showAlertOnVC(target: self, title: "معذره", message: "المستخدم لم يضع رقم هاتفه أو لا يريد الاتصال")
        }
    }
    
    @objc func tapUserChat(_ recognizer: UITapGestureRecognizer){
        print(1)
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
            if isVistor == "yes"{
                let alert = UIAlertController(title:"لا يمكنك فعل ذلك", message: "يجب أن تسجل دخول", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "الذهاب لتسجيل الدخول", style: UIAlertActionStyle.default, handler: { (ـ) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "FirstVC")
                    self.present(vc, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "رجوع", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "SendMessageVC") as! SendMessageVC
                vc.adId = advId!
                vc.toUserId = userId!
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func getData(){
            let header=[
                "Authorization" : "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
            ]
            let body = [
                "user_id":userId!
            ]
        print("head ",header)
        print("body ",body)
            API.POST(url: URLs.GetUserDataWithId, parameters: body, headers: header) { (success, value) in
                if success{
                    let dict = value
                    
                    let displayName = dict["display_name"] as? String ?? ""
                    let userPhone = dict["user_phone"] as? String ?? ""
                    let userLastlogin = dict["user_lastlogin"] as? String ?? ""
                    let userRating = dict["user_rating"] as? String ?? "0"
                    let soldAds = dict["sold_ads"] as? Int ?? 0
                    let allAds = dict["all_ads"] as? String ?? "0"
                    self.phone = userPhone
                    self.userNameLabel.text = displayName
                    self.userRatingLabel.text = userRating
                    self.userLastLoginLabel.text = "اخر تسجيل دخول منذ \(userLastlogin)"
                    self.userSoldAds.text = "\(soldAds)"
                    self.userAllAds.text = allAds
                    
                    if let posts = dict["posts"] as? [[String:Any]]{
                        for p in posts{
                            let id = p["ID"] as? Int ?? 0
                            let date = (p["post_date"] as? String)?.prefix(10) ?? ""
                            let title = p["post_title"] as? String ?? ""
                            let price = p["price"] as? String ?? "0"
                            let location = p["location"] as? String ?? ""
                            let picture = p["thumbnail"] as? String ?? "0"
                            let categories = p["categories"] as? [[String:Any]]
                            let images = p["images"] as? [String]

                            var categoryName = ""
                            if categories != nil{
                                for c in categories!{
                                    categoryName.append("\(c["name"]!)  ")
                                }
                            }
                            let post = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: categoryName, images: images ?? [])
                            self.myAds.append(post)
                            
                        }
                        
                        self.adsTableView.reloadData()
                        if self.myAds.count>0{
                            self.noAdsLabel.isHidden = true
                            self.adsTableView.isHidden = false
                        }else{
                            self.noAdsLabel.isHidden = false
                            self.adsTableView.isHidden = true
                        }
                    }
                    
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
}

extension UserAccountDetailesVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return myAds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostsCell", for: indexPath) as? UserPostsCell else {return UITableViewCell()}
        let post = myAds[indexPath.section]
        cell.configureCell(adModel: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = myAds[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MyAdsDetailes") as! MyAdsDetailes
        vc.advId = post.id
        self.show(vc, sender: nil)
    }
}
