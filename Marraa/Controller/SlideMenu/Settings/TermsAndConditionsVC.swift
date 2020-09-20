//
//  TermsAndConditionsVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الشروط والأحكام"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "path-10"), style: .plain, target: self, action: #selector(backBtn))
    }
    
    @objc func backBtn(){
        self.dismiss(animated: true, completion: nil)
    }

    func getData(){
        API.GET(url: URLs.GetRules) { (success, value) in
            if success{
                let dict = value
                if let allRules = dict["rules"] as? [String:Any] {
                    let first = allRules["1"] as! [String:Any]
                    let firstTitle = first["title"] as! String
                    let firstRules = first["rules"] as! [String:Any]
                    let one = firstRules["1"] as! String
                    let two = firstRules["2"] as! String
                    let three = firstRules["3"] as! String
                    let four = firstRules["4"] as! String
                    let five = firstRules["5"] as! String
                    let six = firstRules["6"] as! String
                    let seven = firstRules["7"] as! String
                    let second = allRules["2"] as! [String:Any]
                    let secondTitle = second["title"] as! String
                    let secondRules = second["rules"] as! [String:Any]
                    let eight = firstRules["8"] as! String
                    let nine = firstRules["9"] as! String
                    let ten = firstRules["10"] as! String
                    let eleven = firstRules["11"] as! String
                    let twelve = firstRules["12"] as! String
                    let third = allRules["3"] as! [String:Any]
                    let thirdTitle = third["title"] as! String
                    let thirdRules = third["rules"] as! [String:Any]
                    let thirten = firstRules["13"] as! String
                    let fourten = firstRules["14"] as! String
                    let fiften = firstRules["15"] as! String
                    let sixten = firstRules["16"] as! String
                    let seventen = firstRules["17"] as! String
                    let eighten = firstRules["18"] as! String
                    let nineten = firstRules["19"] as! String
                    let twenty = firstRules["20"] as! String
                    
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
