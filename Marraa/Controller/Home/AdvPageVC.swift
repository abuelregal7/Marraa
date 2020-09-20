//
//  AdvPageVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

class AdvPageVC: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var advPictureImageView: UIImageView!
    @IBOutlet weak var advTitleLabel: UILabel!
    @IBOutlet weak var advSeenCountLabel: UILabel!
    @IBOutlet weak var advLocationLabel: UILabel!
    @IBOutlet weak var advPriceLabel: UILabel!
    @IBOutlet weak var advDateLabel: UILabel!
    @IBOutlet weak var advConditionLabel: UILabel!
    @IBOutlet weak var advLocationDetailsLabel: UILabel!
    @IBOutlet weak var advContentTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRateLabel: UILabel!
    @IBOutlet weak var userLastLoginLabel: UILabel!
    @IBOutlet weak var relatedAdsCollectionView: UICollectionView!
    @IBOutlet weak var userDetailesView: BorderView!
    @IBOutlet weak var chatUserImageView: UIImageView!
    @IBOutlet weak var callUserImageView: UIImageView!
    
    var relatedPosts = [AdModel]()
    var images = [String]()
    var imageView : UIImageView?
    var advId:Int?
    var phone:String?
    var userId:String?
    var dataIsHere = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        self.initiateMenuOptions()
        
        let tapUserDetsailesView = UITapGestureRecognizer(target: self, action: #selector(tapUserDetailes(_:)))
        userDetailesView.addGestureRecognizer(tapUserDetsailesView)
        let tapUserCall = UITapGestureRecognizer(target: self, action: #selector(tapUserCall(_:)))
        callUserImageView.addGestureRecognizer(tapUserCall)
        let tapUserChat = UITapGestureRecognizer(target: self, action: #selector(tapUserChat(_:)))
        chatUserImageView.addGestureRecognizer(tapUserChat)
        
        let body=["id":advId!]
        API.POSTWithNoReturn(url: URLs.IncreseAdView, parameters: body, headers: nil) { (success, value) in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "تفاصيل الإعلان"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "More Icon"), style: .plain, target: self, action: #selector(contextMenuBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back Arrow"), style: .plain, target: self, action: #selector(backBtnPressed))
    }
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return images.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {

        let image = images[forIndex]
        print(image)
        self.advPictureImageView!.setImageWith(image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))

        return self.advPictureImageView?.image
    }
        
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressShowMeButton(sender: AnyObject) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        
        present(gallery, animated: true, completion: nil)
    }

    @objc func tapUserDetailes(_ recognizer: UITapGestureRecognizer){
        print(0)
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
                if self.dataIsHere{
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "UserAccountDetailesVC") as! UserAccountDetailesVC
                    print("user data",userId!)
                    vc.userId = userId!
                    vc.advId = advId!
                    self.show(vc, sender: nil)
                }
            }
        }
        
    }
    
    @objc func tapUserCall(_ recognizer: UITapGestureRecognizer){
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
            }else {
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
    
    func setupData(){
        
        let body=[
            "id":advId!
        ]
        print(body)
        API.POST(url: URLs.AdvPage, parameters: body, headers: nil) { (success, value) in
            if success{
                let dict = value
                if let adv = dict["adv"] as? [String:Any]{
                    let id = adv["id"] as? Int ?? 0
                    let title = adv["title"] as? String ?? ""
                    let date = adv["date"] as? String ?? ""
                    let content = adv["content"] as? String ?? ""
                    let price = adv["price"] as? String ?? "0"
                    let views = adv["views"] as? String ?? "0"
                    let thumbnail = adv["thumbnail"] as? String ?? ""
                
                    let images = adv["images"] as? [String]
                    if images != nil {
                    self.images.removeAll()
                    for x in images!{
                       
                        self.images.append(x)
                        
                        }
                    }
                    
                    print(images?.count)
                    self.sliderCollectionView.reloadData()
                    let location = adv["location"] as? String ?? ""
                    let condition = adv["condition"] as? String ?? ""
                    
                    let related = adv["related"] as? [[String:Any]]
                    self.relatedPosts = []
                    for r in related!{
                        let id = r["id"] as? Int ?? 0
                        let title = r["title"] as? String ?? ""
                        let price = r["price"] as? String ?? "0"
                        let location = r["location"] as? String ?? ""
                        let picture = r["thumbnail"] as? String ?? "0"
                        let images = r["images"] as? [String]

                        var categories = [String]()
                        if let cats = r["cats"] as? [[String:Any]]{
                            categories = []
                            for c in cats{
                                categories.append(c["name"] as! String)
                            }
                        }
                        
                        let categoryName = categories.joined(separator: " ")
                        
                        let post = AdModel(id: id, date: " ", title: title, price: price, location: location, picture: picture, category: categoryName , images: images!)
                        self.relatedPosts.append(post)
                    }
                    
                    self.relatedAdsCollectionView.reloadData()
                    
                    let user = adv["user"] as? [String:Any]
                    let userName = user!["name"] as? String ?? ""
                    let userId = user!["id"] as? String ?? "0"
                    let userRating = user!["rating"] as? String ?? "0"
                    let userLastLogin = user!["last_login"] as? String ?? ""
                    let userPhone = user!["phone"] as? String ?? "0"
                    print(userPhone)
                    self.phone = userPhone
                   self.userId = userId
                    self.dataIsHere = true
                    self.advTitleLabel.text = title
                    self.advSeenCountLabel.text = views
                    self.advLocationLabel.text = location
                    self.advPriceLabel.text = price
                    self.advDateLabel.text = date
                    self.advConditionLabel.text = condition
                    self.advLocationDetailsLabel.text = location
                    self.advContentTextView.text = content
                    self.userNameLabel.text = userName
                    self.userRateLabel.text = userRating
                    self.userLastLoginLabel.text = "اخر تسجيل دخول منذ \(userLastLogin)"
                    
                }
            } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.setupData()
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func backBtnPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeAllAdsBtnPressed(_ sender: Any) {
        
    }
    
    @objc func contextMenuBtnPressed(){
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
                self.contextMenuTableView = YALContextMenuTableView(tableViewDelegateDataSource: self)
                self.contextMenuTableView!.animationDuration = 0.11;
                self.contextMenuTableView!.yalDelegate = self
                let cellNib = UINib(nibName: "ContextMenuCell", bundle: nil)
                self.contextMenuTableView!.register(cellNib, forCellReuseIdentifier: menuCellIdentifier)
                self.contextMenuTableView!.reloadData()
                if #available(iOS 9.0, *) {
                    self.contextMenuTableView!.semanticContentAttribute = .forceRightToLeft
                } else {
                    
                }
                self.contextMenuTableView!.show(in: self.navigationController!.view, with: UIEdgeInsets.zero, animated: true)
            }
        }
    }
    
    let menuCellIdentifier = "rotationCell"
    var menuTitles : [String?] = []
    var menuIcons : [UIImage?] = []
    var contextMenuTableView: YALContextMenuTableView?
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.contextMenuTableView!.reloadData()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration:duration)
        self.contextMenuTableView!.updateAlongsideRotation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.contextMenuTableView!.reloadData()
        })
        
        self.contextMenuTableView!.updateAlongsideRotation()
    }
    
    func initiateMenuOptions() {
        self.menuTitles = ["",
                                        "حفظ كمفضلة",
                           "مشاركة الإعلان",
                           "تعليق",
                           "تقييم المعلن",
                           "إبلاغ عن الإعلان"]
        
        self.menuIcons = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "like-2"),#imageLiteral(resourceName: "network-1"),#imageLiteral(resourceName: "comment-black-oval-bubble-shape (1)-1"),#imageLiteral(resourceName: "star (2)-1"),#imageLiteral(resourceName: "wrong-access-1")]
        
    }
}

extension AdvPageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView {
            return images.count
        }else{
            return relatedPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SliderCVCell
            
            let image = images[indexPath.row]
            print(image)
            cell.img.setImageWith(image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
            
  
            return cell
        } else{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedAdCell", for: indexPath) as? RelatedAdCell else {return UICollectionViewCell()}
        relatedAdsCollectionView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        let post = relatedPosts[indexPath.row]
        cell.configureCell(adModel: post)
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == relatedAdsCollectionView {
        let post = relatedPosts[indexPath.row]
        
        self.advId = post.id
        setupData()
        } else{
            let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
            
            gallery.backgroundColor = UIColor.black
            gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
            gallery.currentPageIndicatorTintColor = UIColor.white
            gallery.hidePageControl = false
            
            present(gallery, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!

        if collectionView == sliderCollectionView {
            size = CGSize(width: sliderCollectionView.frame.width, height: sliderCollectionView.frame.size.height)
            return size

        } else{
      size = CGSize(width: 127.0, height: 170.0)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollectionView {
            return 0.0
        }else{
            return 20.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollectionView {
            return 0.0
        }else{
            return 20.0
        }
    }
}

extension AdvPageVC : UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate{
    func contextMenuTableView(_ contextMenuTableView: YALContextMenuTableView!, didDismissWith indexPath: IndexPath!) {
        print("Menu dismissed with indexpath = \(indexPath[1])")
        if indexPath[1] == 1{
            //favourite
            let header=[
                "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
            ]
            let body=[
                "id":advId!
            ]
            
            API.POST(url: URLs.AddFavourite, parameters: body, headers: header) { (success, value) in
                if success{
                    let dict = value
                    if let s = dict["success"] as? String{
                        Alert.showAlertOnVC(target: self, title: s, message: "")
                    }
                }else{
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                }
            }
            
        } else if indexPath[1] == 2{
            let activityController = UIActivityViewController(activityItems: [advPictureImageView.image, advTitleLabel.text, advPriceLabel.text],
                                                              applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        } else if indexPath[1] == 3{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "BidAdvVC") as! BidAdvVC
            vc.advId = advId
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(vc, animated: true, completion: nil)
            
        }else if indexPath[1] == 4{
            //rate
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let alert = storyBoard.instantiateViewController(withIdentifier: "RateAdVC") as! RateAdVC
            alert.adId = advId
            alert.userId = self.userId!
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(alert, animated: true, completion: nil)
            
        } else if indexPath[1] == 5{
            //report
            let header=[
                "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
            ]
            let body=[
                "id":advId!
            ]
            API.POST(url: URLs.ReportAd, parameters: body, headers: header) { (success, value) in
                if success{
                    let dict = value
                    if let msg = dict["message"] as? String{
                        Alert.showAlertOnVC(target: self, title: msg, message: "")
                    } else if let s = dict["success"] as? String{
                        Alert.showAlertOnVC(target: self, title: "تم الإبلاغ", message: "")
                    }
                }else{
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let t = tableView as! YALContextMenuTableView
        t.dismis(with: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let t = tableView as! YALContextMenuTableView
        let cell = t.dequeueReusableCell(withIdentifier: menuCellIdentifier, for:indexPath as IndexPath) as! ContextMenuCell
        
        cell.backgroundColor = UIColor.clear
        cell.menuTitleLabel.text = self.menuTitles[indexPath.row]
        cell.menuTitleLabel.textAlignment = .left
        cell.menuTitleLabel.font = UIFont(name: "Cairo-SemiBold", size: 17.0)
        cell.menuImageView.image = self.menuIcons[indexPath.row]
        cell.selectionStyle = .none
        
        return cell;
    }
}

class SliderCVCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!

}
