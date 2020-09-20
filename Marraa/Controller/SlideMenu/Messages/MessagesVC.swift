//
//  MessagesVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MessagesVC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var shadowView: UIView!
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
   
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.462745098, green: 0.7176470588, blue: 0.9019607843, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.462745098, green: 0.7176470588, blue: 0.9019607843, alpha: 1)
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الرسائل"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = RecievedOffersVC(style: .plain, itemInfo: "العروض المتلقاة")
        let child_2 = SentOffersVC(style: .plain, itemInfo: "العروض المرسلة")
        return [child_1, child_2]
    }
}
