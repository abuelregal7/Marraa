//
//  AboutVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
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
        navigationItem.title = "عن مرعى"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "path-10"), style: .plain, target: self, action: #selector(backBtn))
    }
    
    @objc func backBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getData(){
        API.GET(url: URLs.GetAboutUs) { (success, value) in
            if success{
                let dict = value
                if let content = dict["content"] as? String{
                    self.contentTextView.text = content
                }
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}
