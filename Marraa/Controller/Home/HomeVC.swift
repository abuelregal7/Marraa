//
//  HomeVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeVC: UIViewController {

    @IBOutlet weak var animalCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    @IBOutlet weak var fishsView: BorderView!
    @IBOutlet weak var moashyView: BorderView!
    @IBOutlet weak var birdsView: BorderView!
    @IBOutlet weak var accessoriesView: BorderView!
    @IBOutlet weak var adoptionView: BorderView!
    @IBOutlet weak var animalsView: BorderView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addAdvBtn: UIButton!

    var selectedCategoryTag:Int?
    var birdsPosts = [AdModel]()
    var featurePosts = [AdModel]() 
    var animalPosts = [AdModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationControll()
        
        let tapFishsView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        fishsView.addGestureRecognizer(tapFishsView)
        let tapMoashyView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        moashyView.addGestureRecognizer(tapMoashyView)
        let tapBirdsView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        birdsView.addGestureRecognizer(tapBirdsView)
        let tapAccessoriesView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        accessoriesView.addGestureRecognizer(tapAccessoriesView)
        let tapAdoptionView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        adoptionView.addGestureRecognizer(tapAdoptionView)
        let tapAnimalsView = UITapGestureRecognizer(target: self, action: #selector(tapCategories(_:)))
        animalsView.addGestureRecognizer(tapAnimalsView)
     
        if let isVistor = UserDefaults.standard.value(forKey: "vistor") as? String{
            if isVistor == "yes" {
                addAdvBtn.isHidden = true
                addView.isHidden = true
            } else {
                addAdvBtn.isHidden = false
                addView.isHidden = false
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNavBar()
        getHomeData()
        getData()
    }
    
    func setNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func sideMenu(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
        let sideMenu = SlideMenuController(mainViewController:self, rightMenuViewController: rightMenuVC)
        self.presentDetails(viewControllerToPresent: sideMenu)
    }
    
   public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الصفحة الرئيسية"
        self.navigationItem.hidesBackButton = true
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Search Icon-1"), style: .plain, target: self, action: #selector(searchBtnPressed))
    }
    
    @objc func searchBtnPressed(){
        print("Search")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.show(vc, sender: nil)
    }
    
    func getHomeData(){
        API.GETWithIndicator(url: URLs.GetHome, indicator: false) { (success, value) in
            if success{
                let dict = value
                if let cats = dict["feautre_cats"] as? [[String:Any]] {
                    let birds = cats[0]
                    let animal = cats[3]
                    let categoryName = birds["name"] as? String
                    let categoryNameAnimal = animal["name"] as? String

                    if let posts = birds["posts"] as? [[String:Any]] {
                        self.birdsPosts = []
                        for p in posts {
                            let id = p["ID"] as? Int ?? 0
                            let date = (p["post_date"] as? String)?.prefix(10) ?? ""
                            let title = p["post_title"] as? String ?? ""
                            let price = p["price"] as? String ?? "0"
                            let location = p["location"] as? String ?? ""
                            let picture = p["thumbnail"] as? String ?? "0"
                            let images = p["images"] as? [String]

                            let brid = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: categoryName!, images: images ?? [""])
                            self.birdsPosts.append(brid)
                        }
                        self.birdsPosts.reverse()
                        self.birdsCollectionView.reloadData()
                        
                        let index = IndexPath(item: (self.birdsPosts.count) - 1, section: 0)
                        print(index)
                        if index[1] > 1{
                        self.birdsCollectionView.scrollToItem(at: index, at: UICollectionViewScrollPosition.right, animated: false)
                        }
                    }
                    
                    if let posts = animal["posts"] as? [[String:Any]] {
                        self.animalPosts = []
                        for x in posts {
                            let id = x["ID"] as? Int ?? 0
                            let date = (x["post_date"] as? String)?.prefix(10) ?? ""
                            let title = x["post_title"] as? String ?? ""
                            let price = x["price"] as? String ?? "0"
                            let location = x["location"] as? String ?? ""
                            let picture = x["thumbnail"] as? String ?? "0"
                            let images = x["images"] as? [String]
                            
                            let animal = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: categoryName!, images: images ?? [""])
                            self.animalPosts.append(animal)
                        }
                        self.animalPosts.reverse()
                        self.animalCollectionView.reloadData()
                        
                        let index = IndexPath(item: (self.animalPosts.count) - 1, section: 0)
                        print(index)
                        if index[1] > 1{
                            self.animalCollectionView.scrollToItem(at: index, at: UICollectionViewScrollPosition.right, animated: false)
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getHomeData()
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tapCategories(_ recognizer: UITapGestureRecognizer){
        if recognizer.view?.tag == 348 {
            goToCategoryPage(index: 348, title: "الأسماك")
        } else if recognizer.view?.tag == 347 {
            goToCategoryPage(index: 347, title: "المواشي")
        } else if recognizer.view?.tag == 346 {
            goToCategoryPage(index: 346, title: "الطيور")
        } else if recognizer.view?.tag == 350 {
            goToCategoryPage(index: 350, title: "الاكسسوارات والتغذية")
        } else if recognizer.view?.tag == 408 {
            goToCategoryPage(index: 408, title: "تبني")
        } else if recognizer.view?.tag == 349 {
            goToCategoryPage(index: 349, title: "الحيوانات")
        }
    }
    
    @IBAction func showCtegoryPageBtnPressed(_ sender: UIButton) {
        if sender.tag == 346 {
            goToCategoryPage(index: 346, title: "الطيور")
        }
        else if sender.tag == 483 {
            goToCategoryPage(index: 483, title: "آخري")
        } else if sender.tag == 349 {
            goToCategoryPage(index: 349, title: "الحيوانات")
        }
    }
    
    @IBAction func allAdsClicked(_ sender: UIButton){
        
    }
    
    @IBAction func showallAdsPageBtnPressed(_ sender: UIButton) {
            goToAllAdsPage(index: 346, title: "الطيور")
    }
    
    func goToCategoryPage(index:Int,title:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "CategoryPageVC") as! CategoryPageVC
        mainVC.id = index
        mainVC.categoryName = title
        let nav = UINavigationController(rootViewController: mainVC)
        let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
        self.presentDetails(viewControllerToPresent: sideMenu)
    }
    
    func goToAllAdsPage(index:Int,title:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightMenuVC = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "AllAdsVC") as! AllAdsVC
        
        let nav = UINavigationController(rootViewController: mainVC)
        let sideMenu = SlideMenuController(mainViewController: nav, rightMenuViewController: rightMenuVC)
        self.presentDetails(viewControllerToPresent: sideMenu)
    }
    
    @IBAction func puplishAdvBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddAdvVC")
        self.show(vc, sender: nil)
    }
    
    func getData() {

        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "vistor") as! String)"
        ]
        API.POST(url: URLs.featured, parameters: nil, headers: header) { (success, value) in
            if success{
                let dict = value
                if let feature = dict["posts"] as? [[String:Any]]{

                    self.featurePosts = []
                    for f in feature {
                        let id = f["ID"] as? Int ?? 0
                        let date = (f["post_date"] as? String)?.prefix(10) ?? ""
                        let title = f["post_title"] as? String ?? ""
                        let price = f["price"] as? String ?? "0"
                        let location = f["location"] as? String ?? ""
                        let picture = f["thumbnail"] as? String ?? ""
                        let images = f["images"] as? [String]
                    
                        let brid = AdModel(id: id, date: String(date), title: title, price: price, location: location, picture: picture, category: "مميزه", images: images ?? [""])
                        self.featurePosts.append(brid)
                    }
                   
                    self.collectionView.reloadData()
                    
                } else{
                    if self.featurePosts.count == 0 {
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

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == birdsCollectionView {
        return birdsPosts.count
        }else if collectionView == animalCollectionView {
          return animalPosts.count
        } else{
            return featurePosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == birdsCollectionView {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BirdsCellCollectionViewCell", for: indexPath) as? BirdsCellCollectionViewCell else {return UICollectionViewCell()}
        let bird = birdsPosts[indexPath.row]
        cell.configureCell(adModel: bird)
        return cell
        } else if collectionView == animalCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BirdsCellCollectionViewCell", for: indexPath) as? BirdsCellCollectionViewCell else {return UICollectionViewCell()}
            
            let bird = animalPosts[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BirdsCellCollectionViewCell", for: indexPath) as? BirdsCellCollectionViewCell else {return UICollectionViewCell()}
            let featue = featurePosts[indexPath.row]
        
            cell.configureCell(adModel: featue)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == birdsCollectionView {
        let bird = birdsPosts[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
        vc.advId = bird.id
        self.show(vc, sender: nil)
        } else if collectionView == animalCollectionView{
            let bird = animalPosts[indexPath.row]
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
            vc.advId = bird.id
            self.show(vc, sender: nil)
        } else{
            let feature = featurePosts[indexPath.row]
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
            vc.advId = feature.id
            self.show(vc, sender: nil)
        }
    }
}
