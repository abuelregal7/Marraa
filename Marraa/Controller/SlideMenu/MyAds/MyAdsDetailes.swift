//
//  MyAdsDetailes.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class MyAdsDetailes: UIViewController {
    
    @IBOutlet weak var advPictureImageView: UIImageView!
    @IBOutlet weak var advTitleLabel: UILabel!
    @IBOutlet weak var advSeenCountLabel: UILabel!
    @IBOutlet weak var advLocationLabel: UILabel!
    @IBOutlet weak var advPriceLabel: UILabel!
    @IBOutlet weak var advDateLabel: UILabel!
    @IBOutlet weak var advConditionLabel: UILabel!
    @IBOutlet weak var advLocationDetailsLabel: UILabel!
    @IBOutlet weak var advContentTextView: UITextView!
    @IBOutlet weak var relatedAdsCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var videoLink: UILabel!
    
    var advId:Int?
    var relatedPosts = [AdModel]()
    var images = [String]()
    var currentAdv:AdModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        setupData()
        self.initiateMenuOptions()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "تفاصيل الإعلان"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "More Icon"), style: .plain, target: self, action: #selector(contextMenuBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back Arrow"), style: .plain, target: self, action: #selector(backBtnPressed))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
                    print(adv)
                    let id = adv["id"] as? Int
                    let title = adv["title"] as? String ?? ""
                    let date = adv["date"] as? String ?? ""
                    let content = adv["content"] as? String ?? ""
                    let price = adv["price"] as? String ?? "0"
                    let views = adv["views"] as? String ?? "0"
                    let thumbnail = adv["thumbnail"] as? String ?? ""
                    
                    let location = adv["location"] as? String ?? ""
                    let condition = adv["condition"] as? String ?? ""
                    let images = adv["images"] as? [String]

                    self.currentAdv = AdModel(id: id!, date: date, title: title, price: price, location: location, picture: thumbnail, category: "", images: images ?? [])
                    if images != nil {
                        self.images.removeAll()
                        for x in images!{
                            
                            self.images.append(x)
                        }
                    }
                    
                    self.advTitleLabel.text = title
                    self.advSeenCountLabel.text = views
                    self.advLocationLabel.text = location
                    self.advPriceLabel.text = "\(price) ريال"
                    self.advDateLabel.text = date
                    self.advConditionLabel.text = condition
                    self.advLocationDetailsLabel.text = location
                    self.advContentTextView.text = content
                    self.sliderCollectionView.reloadData()
                    
                }
            } else {
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
    
    @objc func backBtnPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func contextMenuBtnPressed(){
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
                           "حذف الإعلان",
                           "تعديل الإعلان",
                            "مشاركة الإعلان"]
        
        self.menuIcons = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "path-8"),#imageLiteral(resourceName: "path-9"),#imageLiteral(resourceName: "network-1")]
        
    }
}

extension MyAdsDetailes : UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate{
    func contextMenuTableView(_ contextMenuTableView: YALContextMenuTableView!, didDismissWith indexPath: IndexPath!) {
        print("Menu dismissed with indexpath = \(indexPath[1])")
        if indexPath[1] == 1{
            let header=[
                "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
            ]
            let body = [
                "ad_id":advId!
            ]
            API.POST(url: URLs.RemoveAdv, parameters: body, headers: header) { (success, value) in
                if success{
                    let dict = value
                    if let msg = dict["success"] as? String{
                        Alert.showAlert(target: self, title: msg, message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }else {
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
                }
            }
        }else if indexPath[1] == 2{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EditAdvVC") as! EditAdvVC
            vc.adContent = self.advContentTextView.text
            vc.adModel = self.currentAdv!
            vc.advId = self.advId!
            self.show(vc, sender: nil)
            
        }else if indexPath[1] == 3{
            let activityController = UIActivityViewController(activityItems: [advPictureImageView.image, advTitleLabel.text, advPriceLabel.text],
                                                              applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
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

extension MyAdsDetailes : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SliderCVCell
            
            let image = images[indexPath.row]
            print(image)
            cell.img.setImageWith(image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        
        if collectionView == sliderCollectionView {
            size = CGSize(width: sliderCollectionView.frame.width, height: sliderCollectionView.frame.size.height)
            return size
            
        } else {
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
