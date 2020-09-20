//
//  FavVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class FavVC: UIViewController {
    
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var myFavTableView: UITableView!
    
    var myAds = [AdModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
         getData()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "المفضلة"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = true
    }
    
    func getData(){
        let header=[
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body=[
            "id": UserDefaults.standard.value(forKey: "user_id") as! String
        ]
        API.POST(url: URLs.GetFavAds, parameters: body, headers: header, completion: { (success, value) in
            if success{
                let dict = value
                if let posts = dict["posts"] as? [[String:Any]]{
                    self.myAds = []
                    for p in posts{
                        let id = p["ID"] as? Int
                        let date = (p["post_date"] as? String)?.prefix(10) ?? ""
                        let title = p["post_title"] as? String
                        let price = p["price"] as? String
                        let location = p["location"] as? String ?? ""
                        let picture = p["thumbnail"] as? String ?? "0"
                        let images = p["images"] as? [String] ?? [String]()
                        print(images)
                        let post = AdModel(id: id!, date: String(date), title: title!, price: price!, location: location, picture: picture, category: " ", images: images)
                        self.myAds.append(post)
                        
                    }
                    self.myFavTableView.reloadData()
                    if self.myAds.count>0{
                        self.noAdsLabel.isHidden = true
                    }else{
                        self.noAdsLabel.isHidden = false
                    }
                }
            }else{
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getData()
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension FavVC : UITableViewDelegate, UITableViewDataSource{
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? FavCell else {return UITableViewCell()}
        let post = myAds[indexPath.section]
        cell.configureCell(adModel: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = myAds[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
        vc.advId = post.id
        self.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let unFavAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "💔") { (_, IndexPath) in
            //remove from favourite
            let post = self.myAds[indexPath.section]
            let header=[
                "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
            ]
            let body=[
                "id": post.id
            ]
            print(body)
            API.POST(url: URLs.RemoveFavAds, parameters: body, headers: header, completion: { (success, value) in
                if success{
                    let dict = value
                    if let msg = dict["success"] as? String{
                        Alert.showAlert(target: self, title: msg, message: "", okAction: "تجاهل", actionCompletion: { (ـ) in
                            self.getData()
                        })
                    }else if let err = dict["error"] as? String{
                        Alert.showAlert(target: self, title: err, message: "", okAction: "تجاهل", actionCompletion: { (ـ) in
                            self.getData()
                        })
                    }
                    else{
                        Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                        self.getData()
                    }
                }else{
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                }
            })
            
        }
         return [unFavAction]
    }
}
