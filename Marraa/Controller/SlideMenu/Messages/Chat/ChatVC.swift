//
//  ChatVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

struct Msg{
    var msg:String
    var type:String
}

class ChatVC: UIViewController {

    @IBOutlet weak var commentTextField: InsertTextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var msgs: [Msg]?
    var offer:Offer?
    var inbox:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgs = []
        getChat()
        chatTableView.reloadData()
        let index = IndexPath(item: (self.msgs?.count)! - 1, section: 0)
        print(index)
        if index[1] > 1{
            self.chatTableView.scrollToRow(at: index, at: .top, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = offer!.title
        self.navigationItem.hidesBackButton = false
    }
    
    func getChat(){
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body=[
            "inbox":inbox!,
            "user_id":offer!.toUserId,
            "ad_id":offer!.id
            ]
        print(body)
        API.POSTAndBackArray(url: URLs.GetChat, parameters: body, headers: header) { (success, value) in
            if success{
                self.msgs = []
                for val in value{
                    
                    let message_type = val["message_type"] as? String ?? ""
                    let message = val["message"] as? String ?? ""
                    self.msgs?.append(Msg(msg: message, type: message_type))
                }
                self.chatTableView.reloadData()
                let index = IndexPath(item: (self.msgs!.count) - 1, section: 0)
                print(index)
                if index[1] > 1{
                    self.chatTableView.scrollToRow(at: index, at: .top, animated: false)
                }
            } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.getChat()
                }))
                alert.addAction(UIAlertAction(title: "رجوع", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        guard let comment = commentTextField.text , !((commentTextField.text?.isEmpty)!) else {
            return Alert.showAlertOnVC(target: self, title: "لا يمكنك ارسال رسالة فارغة", message: "")
        }
        
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        var body=[
            "name": UserDefaults.standard.value(forKey: "user_nicename") as! String ,
            "email": UserDefaults.standard.value(forKey: "user_email") as! String ,
            "usr_id": offer!.toUserId,
            "rece_id":UserDefaults.standard.value(forKey: "user_id") as! String  ,
            "msg_receiver_id":UserDefaults.standard.value(forKey: "user_id") as! String  ,
            "message":comment,
            "ad_post_id": offer!.id
            ] as [String : Any]
        if self.inbox == "no" {
            body["usr_id"] =  UserDefaults.standard.value(forKey: "user_id") as! String
            body["rece_id"] = offer!.toUserId
            body["msg_receiver_id"] = offer!.toUserId
        } else if self.inbox == "yes" {
            body["usr_id"] = offer!.toUserId
            body["rece_id"] = UserDefaults.standard.value(forKey: "user_id") as! String
            body["msg_receiver_id"] = UserDefaults.standard.value(forKey: "user_id") as! String
        }
        
        print(body)
        API.POST(url: URLs.SendMessage, parameters: body, headers: header) { (success, value) in
            if success{
                let dict = value
                if let msg = dict["message"] as? String{
                    
                }else if let s = dict["success"] as? String{
                    
                }
                self.getChat()
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {return UITableViewCell()}
        let msg = msgs![indexPath.row]
        cell.configureCell(msg: msg)
        return cell
    }
}
