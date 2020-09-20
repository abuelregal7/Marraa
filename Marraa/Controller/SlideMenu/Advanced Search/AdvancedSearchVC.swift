//
//  AdvancedSearchVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class AdvancedSearchVC: UIViewController {
    
    @IBOutlet weak var adTypeTextField: InsertTextField!
    @IBOutlet weak var adTitleTextField: InsertTextField!
    @IBOutlet weak var adCategoryTextField: InsertTextField!
    @IBOutlet weak var adConditionTextField: InsertTextField!
    @IBOutlet weak var adWarrantyTextField: InsertTextField!
    @IBOutlet weak var maxPriceTextField: InsertTextField!
    @IBOutlet weak var minPriceTextField: InsertTextField!
    @IBOutlet weak var locationTextField: InsertTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAllPickerViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "البحث المتقدم"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if adTitleTextField.text != "" || adConditionTextField.text != "" {
        var body = [
            "ad_title":adTitleTextField.text,
            "condition":adConditionTextField.text,
            "ad_type":adTypeTextField.text,
            "warranty":adWarrantyTextField.text,
            "min_price":minPriceTextField.text,
            "max_price":maxPriceTextField.text,
            "location":locationTextField.text
            ] as [String : Any]
        if categoryID != 0 {
            body["cat_id"] = categoryID
        }
        API.POSTAndBackArray(url: URLs.AdvancedSearch, parameters: body, headers: nil) { (success, value) in
            if success{
                let arr = value
                var posts = [AdModel]()
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
                    posts.append(AdModel(id: id!, date: "", title: title, price: price, location: location, picture: thumbnail, category: categoryName, images: images! ))
                }
                if posts.count == 0{
                    return Alert.showAlertOnVC(target: self, title: "لا توجد نتائج", message: "حاول بمعلومات أقل تحديدا")
                }else{
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
                    vc.posts = posts
                    self.show(vc, sender: nil)
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

    var adTypes = ["تبادل" , "طلب" , "عرض"]
    var categoryTypes = ["تبني" , "المواشي" , "الطيور" , "الحيوانات" , "الاكسسوارات و التغذي" , "الأسماك" , "أخرى"]
    var conditionTypes = ["جديد" , "مستعمل"]
    var warrentyTypes = ["يوجد ضمان" , "لا يوجد ضمان"]
    var adTypesPickerView = UIPickerView()
    var categoryTypesPickerView = UIPickerView()
    var conditionTypesPickerView = UIPickerView()
    var warrentyTypesPickerView = UIPickerView()
    var adTypesIndex = 0
    var categoryTypesIndex = 0
    var conditionTypesIndex = 0
    var warrentyTypesIndex = 0
    var categoryID = 0
    
    func showAllPickerViews() {
        adTypesPickerView.delegate = self
        adTypesPickerView.dataSource = self
        adTypesPickerView.tag = 1
        categoryTypesPickerView.delegate = self
        categoryTypesPickerView.dataSource = self
        categoryTypesPickerView.tag = 2
        conditionTypesPickerView.delegate = self
        conditionTypesPickerView.dataSource = self
        conditionTypesPickerView.tag = 3
        warrentyTypesPickerView.delegate = self
        warrentyTypesPickerView.dataSource = self
        warrentyTypesPickerView.tag = 4
        
        let adTypesToolbar = UIToolbar()
        adTypesToolbar.sizeToFit()
        let adTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(adTypesDonePickerView))
        let adTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let adTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        adTypesToolbar.setItems([adTypesDoneButton,adTypesSpaceButton,adTypesCancelButton], animated: false)
        
        adTypeTextField.inputAccessoryView = adTypesToolbar
        adTypeTextField.inputView = adTypesPickerView
        
        let categoryTypesToolbar = UIToolbar()
        categoryTypesToolbar.sizeToFit()
        let categoryTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(categoryTypesDonePickerView))
        let categoryTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let categoryTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        categoryTypesToolbar.setItems([categoryTypesDoneButton,categoryTypesSpaceButton,categoryTypesCancelButton], animated: false)
        
        adCategoryTextField.inputAccessoryView = categoryTypesToolbar
        adCategoryTextField.inputView = categoryTypesPickerView
        
        let conditionTypesToolbar = UIToolbar()
        conditionTypesToolbar.sizeToFit()
        let conditionTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(conditionTypesDonePickerView))
        let conditionTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let conditionTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        conditionTypesToolbar.setItems([conditionTypesDoneButton,conditionTypesSpaceButton,conditionTypesCancelButton], animated: false)
        
        adConditionTextField.inputAccessoryView = conditionTypesToolbar
        adConditionTextField.inputView = conditionTypesPickerView
        
        let warrentyTypesToolbar = UIToolbar()
        warrentyTypesToolbar.sizeToFit()
        let warrentyTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(warrentyTypesDonePickerView))
        let warrentyTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let warrentyTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        warrentyTypesToolbar.setItems([warrentyTypesDoneButton,warrentyTypesSpaceButton,warrentyTypesCancelButton], animated: false)
        
        adWarrantyTextField.inputAccessoryView = warrentyTypesToolbar
        adWarrantyTextField.inputView = warrentyTypesPickerView
    }
    
    @objc func adTypesDonePickerView() {
        let adType = adTypes[self.adTypesIndex]
        adTypeTextField.text = adType
        adTypeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func categoryTypesDonePickerView() {
        let categoryType = categoryTypes[self.categoryTypesIndex]
        adCategoryTextField.text = categoryType
        adCategoryTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func conditionTypesDonePickerView() {
        let conditionType = conditionTypes[self.conditionTypesIndex]
        adConditionTextField.text = conditionType
        adConditionTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func warrentyTypesDonePickerView() {
        let warrentyType = warrentyTypes[self.warrentyTypesIndex]
        adWarrantyTextField.text = warrentyType
        adWarrantyTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func cancelPickerView() {
        self.view.endEditing(true)
    }
}

extension AdvancedSearchVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return adTypes.count
        case 2:
            return categoryTypes.count
        case 3:
            return conditionTypes.count
        case 4:
            return warrentyTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            let adType = adTypes[row]
            return adType
        case 2:
            let categoryType = categoryTypes[row]
            return categoryType
        case 3:
            let conditionType = conditionTypes[row]
            return conditionType
        case 4:
            let warrentyType = warrentyTypes[row]
            return warrentyType
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let adType = adTypes[row]
            adTypeTextField.text = adType
            self.adTypesIndex = row
            self.adTypeTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 2:
            let categoryType = categoryTypes[row]
            adCategoryTextField.text = categoryType
            self.categoryTypesIndex = row
            switch row{
            case 0 : self.categoryID = 408
            case 1 : self.categoryID = 347
            case 2 : self.categoryID = 346
            case 3 : self.categoryID = 349
            case 4 : self.categoryID = 350
            case 5 : self.categoryID = 348
            case 6 : self.categoryID = 483
            default: self.categoryID = 0
            }
            self.adCategoryTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 3:
            let conditionType = conditionTypes[row]
            adConditionTextField.text = conditionType
            self.conditionTypesIndex = row
            self.adConditionTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 4:
            let warrentyType = warrentyTypes[row]
            adWarrantyTextField.text = warrentyType
            self.warrentyTypesIndex = row
            self.adWarrantyTextField.resignFirstResponder()
            self.view.endEditing(true)
        default:
            break
        }
    }
}
