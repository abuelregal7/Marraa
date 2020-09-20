//
//  SentOffersVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SentOffersVC: UITableViewController ,IndicatorInfoProvider{
    
    let cellIdentifier = "SentOffersCell"
    var itemInfo = IndicatorInfo(title: "View")
    let label = UILabel()
    var offers = [Offer]()
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SentOffersCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.sectionHeaderHeight = 8.0
        tableView.sectionFooterHeight = 8.0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "لا توجد رسائل"
        
        self.parent?.view.addSubview(label)
        self.parent?.view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.parent?.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.parent?.view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.parent?.view, attribute: .centerY, multiplier: 1, constant: -50))
        label.isHidden = true
        
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //call service to get data then reload tableview
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        let header=[
            "Authorization" : "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        
        let body = [
            "message_type":"sent"
        ]
        
        API.POSTAndBackArray(url: URLs.GetChats, parameters: body, headers: header) { (success, value) in
            if success{
                self.offers = []
                for offer in value{
                    let id = offer["adv_id"] as? String ?? ""
                    let img = offer["image"] as? String ?? " "
                    let title = offer["adv_title"] as? String ?? " "
                    let toUserName = offer["sent_to"] as? String ?? ""
                    let toUserId = offer["sent_to_id"] as? String ?? ""
                    
                    self.offers.append(Offer(id: id, img: img, title: title, toUserName: toUserName, toUserId: toUserId))
                }
                if self.offers.count > 0 {
                    self.label.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }else{
                    self.label.isHidden = false
                    self.tableView.isHidden = true
                    self.tableView.reloadData()
                }
            }else{
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getData()
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.offers.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SentOffersCell else { return UITableViewCell() }
        let offer = self.offers[indexPath.section]
        cell.configureCell(offer: offer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let offer = self.offers[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.inbox = "no"
        vc.offer = offer
        self.show(vc, sender: nil)
    }
}
