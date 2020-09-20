//
//  CategoryPageVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class CategoryPageVC: UIViewController {
    
    @IBOutlet weak var featurePostsCollectionView: UICollectionView!
    @IBOutlet weak var regularPostsTableView: UITableView!
    @IBOutlet weak var noFeatureAdsLabel: UILabel!
    @IBOutlet weak var noRegularAdsLabel: UILabel!
    
    var featurePosts = [AdModel]()
    var regularPosts = [AdModel]()
    
    var categoryName: String?
    var id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = categoryName!
        self.navigationItem.hidesBackButton = true
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Search Icon-1"), style: .plain, target: self, action: #selector(searchBtnPressed))
    }
    
    @objc func searchBtnPressed(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.show(vc, sender: nil)
    }
    
    func getData(){
        
        let body=[
            "id":id!
        ]
        
        API.POST(url: URLs.CategoryPage, parameters: body, headers: nil) { (success, value) in
            if success{
                let dict = value
                if let feature = dict["feature"] as? [[String:Any]]{
                    self.noFeatureAdsLabel.isHidden = true
                    self.featurePosts = []
                    for f in feature {
                        let id = f["ID"] as? Int ?? 0
                        let date = (f["post_date"] as? String)?.prefix(10) ?? ""
                        let title = f["post_title"] as? String ?? ""
                        let price = f["price"] as? String ?? "0"
                        let location = f["location"] as? String ?? ""
                        let picture = f["thumbnail"] as? String ?? ""
                        let images = f["images"] as? [String]

                        let fe = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: self.categoryName!, images: images ?? [""])
                        self.featurePosts.append(fe)
                    }
                    if self.featurePosts.count == 0{
                        self.noFeatureAdsLabel.isHidden = false
                    }
                    self.featurePostsCollectionView.reloadData()
                    
                } else {
                    if self.featurePosts.count == 0 {
                        self.noFeatureAdsLabel.isHidden = false
                    }
                }
                
                if let posts = dict["posts"] as? [[String:Any]]{
                    self.noRegularAdsLabel.isHidden = true
                    self.regularPosts = []
                    for p in posts {
                        let id = p["ID"] as? Int ?? 0
                        let date = (p["post_date"] as? String)?.prefix(10) ?? ""
                        let title = p["post_title"] as? String ?? ""
                        let price = p["price"] as? String ?? "0"
                        let location = p["location"] as? String ?? ""
                        let picture = p["thumbnail"] as? String ?? "0"
                        let images = p["images"] as? [String]

                        let re = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: self.categoryName!, images: images ?? [""])
                        self.regularPosts.append(re)
                    }
                    
                    if self.regularPosts.count == 0{
                        self.noRegularAdsLabel.isHidden = false
                    }
                    self.regularPostsTableView.reloadData()
                    
                } else {
                    if self.regularPosts.count == 0{
                        self.noRegularAdsLabel.isHidden = false
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

extension CategoryPageVC : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return featurePosts.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturePostsCell", for: indexPath) as? FeaturePostsCell else {return UICollectionViewCell()}
            featurePostsCollectionView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            let post = featurePosts[indexPath.row]
            cell.configureCell(adModel: post)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView.tag == 1{
            let post = featurePosts[indexPath.row]
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
            vc.advId = post.id
            self.show(vc, sender: nil)
        }
    }
}

extension CategoryPageVC : UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return regularPosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RegularPostsCell", for: indexPath) as? RegularPostsCell else {return UITableViewCell()}
        let post = regularPosts[indexPath.section]
        cell.configureCell(adModel: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = regularPosts[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
        vc.advId = post.id
        self.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
}
