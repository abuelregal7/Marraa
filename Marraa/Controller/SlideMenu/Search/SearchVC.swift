//
//  SearchVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextTextField: InsertTextField!
    @IBOutlet weak var noAdsLabel: UILabel!
    var posts = [AdModel]()
    @IBOutlet var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = searchView
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchTextTextField.text != "" {
        var body = [
            "ad_title":searchTextTextField.text
            ] as [String : Any]
        API.POSTAndBackArray(url: URLs.AdvancedSearch, parameters: body, headers: nil) { (success, value) in
            if success{
                let arr = value
                 self.posts = [AdModel]()
                for p in arr{
                    let id = p["id"] as? Int
                    let title = p["title"] as? String ?? ""
                    let price = p["price"] as? String ?? ""
                    let thumbnail = p["thumbnail"] as? String ?? ""
                    let location = p["location"] as? String ?? ""
                    let cats = p["cats"] as? [[String:Any]]
                    let images = p["images"] as? [String]

                    var categoryName = ""
                    for c in cats!{
                        let name = c["name"] as? String
                        categoryName.append("\(name!) ")
                    }
                    self.posts.append(AdModel(id: id!, date: "", title: title, price: price, location: location, picture: thumbnail, category: categoryName, images: images ?? [""]))
                }
                if self.posts.count == 0{
                    self.resultsTableView.isHidden = true
                    self.noAdsLabel.isHidden = false
                }else{
                    self.resultsTableView.isHidden = false
                    self.noAdsLabel.isHidden = true
                    self.resultsTableView.reloadData()
                }
            }else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.searchBtnPressed(sender)
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }else{
            
            return Alert.showAlertOnVC(target: self, title: "تحذير", message: "يرجي ادخال البيانات")

        }
    }
    

}
extension SearchVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleSearchResultCell", for: indexPath) as? SimpleSearchResultCell else {return UITableViewCell()}
        let post = posts[indexPath.section]
        cell.configureCell(adModel: post)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AdvPageVC") as! AdvPageVC
        vc.advId = post.id
        self.show(vc, sender: nil)
    }
}
