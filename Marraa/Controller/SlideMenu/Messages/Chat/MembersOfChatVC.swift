//
//  MembersOfChatVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

struct Member{
    var adv_title:String
    var adv_id:String
    var sent_to:String
    var sent_to_id:String
}

class MembersOfChatVC: UIViewController {

    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var noMembersLabel: UILabel!
    
    var members = [Member]()
    var offer:Offer?
    var inbox:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.members = []
        getMembers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        noMembersLabel.isHidden = true
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = offer!.title
        self.navigationItem.hidesBackButton = false
    }
    
    func getMembers(){
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body=[
            "ad_id":offer!.id
        ]
        print(body)
        API.POSTAndBackArray(url: URLs.ReceivedMessages, parameters: body, headers: header, completion: { (success, value) in
            if success{
                self.members = []
                for m in value{
                    let adv_title = m["adv_title"] as? String ?? ""
                    let adv_id = m["adv_id"] as? String ?? ""
                    let sent_to = m["sent_to"] as? String ?? "الرسائل"
                    let sent_to_id = m["sent_to_id"] as? String ?? ""
                    self.members.append(Member(adv_title: adv_title, adv_id: adv_id, sent_to: sent_to, sent_to_id: sent_to_id))
                }
                if self.members.count>0{
                    self.membersTableView.isHidden = false
                    self.noMembersLabel.isHidden = true
                }else{
                    self.membersTableView.isHidden = true
                    self.noMembersLabel.isHidden = false
                }
                self.membersTableView.reloadData()
            }else{
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getMembers()
                }))
                alert.addAction(UIAlertAction(title: "رجوع", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}

extension MembersOfChatVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as? MemberCell else { return UITableViewCell() }
        let member = self.members[indexPath.row]
        cell.configureCell(adTitle: member.adv_title, memberName: member.sent_to)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let member = self.members[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.inbox = "yes"
        vc.offer = Offer(id: member.adv_id, img: "", title: member.adv_title , toUserName: member.sent_to, toUserId: member.sent_to_id)
        self.show(vc, sender: nil)
    }
}
