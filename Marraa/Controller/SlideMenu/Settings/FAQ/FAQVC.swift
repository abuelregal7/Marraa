//
//  FAQVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class FAQVC: UITableViewController,ExpandableHeaderViewDelegate{

    var sectionsData = [sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }

    func getData(){
        API.GET(url: URLs.GetFAQ) { (success, value) in
            if success{
                let dict = value
                if let faq = dict["faq"] as? [[String:Any]]{
                    if faq.count != 0{
                        self.sectionsData = []
                    }
                    for f in  faq{
                        let title = f["title"] as? String ?? " "
                        let content = f["content"] as? String ?? " "
                        self.sectionsData.append(sections(name: title, expanded: false, content: content))
                    }
                    self.tableView.reloadData()
                }
            }else{
                Alert.showAlertOnVC(target: self, title: "حدث خطأ بالشبكة", message: "تأكد من اتصالك بشبكة الانترنيت ثم أعد المحاولة")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sectionsData[indexPath.section].expanded) {
            return 90
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sectionsData[section].name, section: section, delegate: self)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let r = sectionsData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as! FAQCell
        cell.configureCell(content: r.content)
        cell.layer.cornerRadius = 15.0
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        cell.backgroundColor = UIColor.clear
        self.tableView.reloadData()
    }
    
    func toggelSection(header: ExpandableHeaderView, section: Int) {
        sectionsData[section].expanded = !sectionsData[section].expanded
        tableView.beginUpdates()

        tableView.endUpdates()
    }
}

struct sections {
    var name: String!
    var content: String!
    var expanded: Bool!
    init(name: String, expanded: Bool,content:String) {
        self.name = name
        self.expanded = expanded
        self.content = content
    }
}
