//
//  AddAdvVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker
import Alamofire
import KRProgressHUD

class AddAdvVC: UIViewController {

    @IBOutlet weak var adTitleTextField: InsertTextField!
    @IBOutlet weak var adPriceTextField: InsertTextField!
    @IBOutlet weak var adAddressTextField: InsertTextField!
    @IBOutlet weak var adVideoLinkTextField: InsertTextField!
    @IBOutlet weak var adDecriptionTextView: UITextView!
    @IBOutlet weak var borderViewHight: NSLayoutConstraint!
    @IBOutlet weak var topPriceTF: NSLayoutConstraint!
    @IBOutlet weak var adCategoryTextField: InsertTextField!
    @IBOutlet weak var adSubCategoryTextField: InsertTextField!
    @IBOutlet weak var adPriceTypeTextField: InsertTextField!
    @IBOutlet weak var adWarrentyTextField: InsertTextField!
    @IBOutlet weak var adCurrencyTextField: InsertTextField!
    @IBOutlet weak var adConditionTextField: InsertTextField!
    @IBOutlet weak var adTypeTextField: InsertTextField!
    @IBOutlet weak var adPhoneTextField: InsertTextField!
    @IBOutlet weak var collectionHight: NSLayoutConstraint!
    @IBOutlet weak var topImgTFconstrain: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImageLabel: UILabel!
    
    var advPic: Data?
    var base64Image:String?
    var advPicsArray = [Data]()
    var advfileArray = [String]()
    var data:AdSelectTypes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topPriceTF.constant = 12
        adDecriptionTextView.textColor = UIColor.lightGray
        adDecriptionTextView.delegate = self
        showAllPickerViews()
        borderViewHight.constant = 740
        collectionView.isHidden = true
        self.topImgTFconstrain.constant = 12
        
        addImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCameraOrGallery(_:))))
        handelSelectedData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "إضافة إعلان"
        self.navigationItem.hidesBackButton = false
    }
    
    var images = [UIImage]()
    var titles = [String]()
    var count = 1
    


    @objc func openCameraOrGallery(_ recognizer: UITapGestureRecognizer ){
        var config = YPImagePickerConfiguration()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2862745098, green: 0.6784313725, blue: 0.9137254902, alpha: 1)

        config.library.maxNumberOfItems = 10
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                    self.topImgTFconstrain.constant = 50
                    self.collectionHight.constant = 50
                    if self.subCategoryTypes != nil {
                        self.borderViewHight.constant = 830

                    }else{
                        self.borderViewHight.constant = 770
                    }
                    let img = photo.image
                    self.images.append(img)
                    let title = "Image"+"\(self.count)"
                    self.titles.append(title)
                    self.count += 1
                    print(self.images.count)
                    self.addImageLabel.text = self.titles.joined(separator: ",")
                case .video(let video):
                    print(video)
                }
            }
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
        
    func handelSelectedData(){
        KRProgressHUD.show()
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let url = URLs.publish
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .success(_):
                    let json = response.data
                    let decoder = JSONDecoder()
                    let modules = try? decoder.decode(AdSelectTypes.self, from: json!)
                    self.data = modules
                    self.fill()
                    print(self.data.ad_cats?.count)
                    KRProgressHUD.dismiss()
            }
        }
    }
    
        
    
    
    @IBAction func puplishAdvBtnPressed(_ sender: Any) {
        guard var advTitle = adTitleTextField.text , !(adTitleTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة عنوان الإعلان", message:"")
        }
        
        guard var advPrice = adPriceTextField.text , !(adPriceTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة سعر الإعلان", message:"")
        }
        
        guard var advPhone = adPhoneTextField.text , !(adPhoneTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة رقم التواصل", message:"")
        }
        
        guard var advAddress = adAddressTextField.text , !(adAddressTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة عنوان الإعلان", message:"")
        }
        
        guard var advDescription = adDecriptionTextView.text , !(adDecriptionTextView.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة وصف الإعلان", message:"")
        }
        
        guard var advCategory = adCategoryTextField.text , !(adCategoryTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار القسم", message:"")
        }
        
        guard var advPriceType = adPriceTypeTextField.text , !(adPriceTypeTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار نوع السعر", message:"")
        }
        
        guard var advCurrency = adCurrencyTextField.text , !(adCurrencyTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار العملة", message:"")
        }
        
        guard var advCondition = adConditionTextField.text else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار الحالة", message:"")
        }
        
        guard var advType = adTypeTextField.text , !(adTypeTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار نوع الإعلان", message:"")
        }
        
        guard var advImage = addImageLabel.text , addImageLabel.text != "اضف صورة" else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار صورة للإعلان", message:"")
        }
      
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        var body=[
            "ad_title":advTitle,
            "contact_number":advPhone,
            "ad_cat":categoryID,
            "ad_price_type":adPriceType,
            "ad_price":advPrice,
            "ad_currency":advCurrency,
            "condition":advCondition,
            "user_address":advAddress,
            "ad_type":advType,
            "user_name":"\(UserDefaults.standard.value(forKey: "user_nicename") as! String)",
            "ad_description":advDescription
            ] as [String : Any]
        if let advWarrenty = adWarrentyTextField.text , !(adWarrentyTextField.text?.isEmpty)! {
            body["ad_warranty"] = advWarrenty
        }
        
        if let advVideoLink = adVideoLinkTextField.text , !(adVideoLinkTextField.text?.isEmpty)! {
            body["ad_yvideo"] = advVideoLink
        }
        
        if subCategoryID != nil {
            guard var advSubCategory = adSubCategoryTextField.text , !(adSubCategoryTextField.text?.isEmpty)! else{
                return Alert.showAlertOnVC(target: self, title: "يجب اختيار نوع التصنيف", message:"")
            }
            body["ad_cat_sub_sub"] = subCategoryID
        }

        API.POSTImage(url: URLs.PuplishAd, Images: self.images, Keys: self.advfileArray, header: header, parameters: body) { (success, value) in
            if success{
                let dict = value
                if let msg = dict["message"] as? String{
                    if msg == "تم الاضافة بنجاح" {
                        self.advPicsArray.removeAll()
                        Alert.showAlert(target: self, title: msg, message: "اذا لم تجد الإعلان علي الفور فهو يتم مراجعته من قبل الإداره", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        Alert.showAlertOnVC(target: self, title: msg, message: "")
                    }
                }
            } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fill(){
        adTypes = data.ad_type!
        categoryTypes = data.ad_cats!
        conditionTypes = data.conditions!
        warrentyTypes = data.ad_warraty!
        currencyTypes = data.ad_currency!
        let item = data.ad_price_type?.fixed
        let item2 = data.ad_price_type?.negotiable
        let item3 = data.ad_price_type?.on_call
        let item4 = data.ad_price_type?.auction
        let item5 = data.ad_price_type?.free
        let item6 = data.ad_price_type?.no_price
        adPriceTypes.append(item ?? "")
        adPriceTypes.append(item2 ?? "")
        adPriceTypes.append(item3 ?? "")
        adPriceTypes.append(item4 ?? "")
        adPriceTypes.append(item5 ?? "")
        adPriceTypes.append(item6 ?? "")
        showAllPickerViews()

    }
    
    var adTypes = [Ad_type]()
    var categoryTypes = [Ad_cats]()
    var conditionTypes = [Conditions]()
    var warrentyTypes = [Ad_warraty]()
    var currencyTypes = [Ad_currency]()
    var adPriceTypes = [String]()
    var subCategoryTypes:[Child]?
    var adTypesPickerView = UIPickerView()
    var categoryTypesPickerView = UIPickerView()
    var subCategoryTypesPickerView = UIPickerView()
    var conditionTypesPickerView = UIPickerView()
    var warrentyTypesPickerView = UIPickerView()
    var currencyTypesPickerView = UIPickerView()
    var adPriceTypesPickerView = UIPickerView()
    var adTypesIndex = 0
    var categoryTypesIndex = 0
    var subCategoryTypesIndex = 0
    var conditionTypesIndex = 0
    var warrentyTypesIndex = 0
    var currencyTypesIndex = 0
    var adPriceTypesIndex = 0
    var categoryID = 0
    var subCategoryID:Int?
    var adPriceType = ""
    
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
        currencyTypesPickerView.delegate = self
        currencyTypesPickerView.dataSource = self
        currencyTypesPickerView.tag = 5
        adPriceTypesPickerView.delegate = self
        adPriceTypesPickerView.dataSource = self
        adPriceTypesPickerView.tag = 6
        subCategoryTypesPickerView.delegate = self
        subCategoryTypesPickerView.dataSource = self
        subCategoryTypesPickerView.tag = 7
        
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
        
        adWarrentyTextField.inputAccessoryView = warrentyTypesToolbar
        adWarrentyTextField.inputView = warrentyTypesPickerView
        
        let currencyTypesToolbar = UIToolbar()
        currencyTypesToolbar.sizeToFit()
        let currencyTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(currencyTypesDonePickerView))//--
        let currencyTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let currencyTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        currencyTypesToolbar.setItems([currencyTypesDoneButton,currencyTypesSpaceButton,currencyTypesCancelButton], animated: false)
        
        adCurrencyTextField.inputAccessoryView = currencyTypesToolbar
        adCurrencyTextField.inputView = currencyTypesPickerView
        
        let adPriceTypesToolbar = UIToolbar()
        adPriceTypesToolbar.sizeToFit()
        let adPriceTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(adPriceTypesDonePickerView))//--
        let adPriceTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let adPriceTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        adPriceTypesToolbar.setItems([adPriceTypesDoneButton,adPriceTypesSpaceButton,adPriceTypesCancelButton], animated: false)
        
        adPriceTypeTextField.inputAccessoryView = adPriceTypesToolbar
        adPriceTypeTextField.inputView = adPriceTypesPickerView
        let subCategoryTypesToolbar = UIToolbar()
        subCategoryTypesToolbar.sizeToFit()
        let subCategoryTypesDoneButton = UIBarButtonItem(title: "اختيار", style: .plain, target: self, action: #selector(subCategoryTypesDonePickerView))
        let subCategoryTypesSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let subCategoryTypesCancelButton = UIBarButtonItem(title: "إلغاء", style: .plain, target: self, action: #selector(cancelPickerView))
        subCategoryTypesToolbar.setItems([subCategoryTypesDoneButton,subCategoryTypesSpaceButton,subCategoryTypesCancelButton], animated: false)
        
        adSubCategoryTextField.inputAccessoryView = subCategoryTypesToolbar
        adSubCategoryTextField.inputView = subCategoryTypesPickerView
    }
    
    @objc func adTypesDonePickerView() {
        let adType = adTypes[self.adTypesIndex]
        adTypeTextField.text = adType.name
        adTypeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func categoryTypesDonePickerView() {
        let categoryType = categoryTypes[self.categoryTypesIndex]
        adCategoryTextField.text = categoryType.name
        categoryID = categoryType.term_id ?? 0
        subCategoryTypes = categoryType.child
        if categoryType.child != nil {
            topPriceTF.constant = 58
            adSubCategoryTextField.isHidden = false
        }
        adCategoryTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func subCategoryTypesDonePickerView() {
        let categoryType = subCategoryTypes?[self.subCategoryTypesIndex]
        adSubCategoryTextField.text = categoryType?.name
        subCategoryID = categoryType?.term_id ?? 0
        if self.images.count != 0 {
            self.borderViewHight.constant = 830
            
        } else {
            self.borderViewHight.constant = 770
        }
        adSubCategoryTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func conditionTypesDonePickerView() {
        let conditionType = conditionTypes[self.conditionTypesIndex]
        adConditionTextField.text = conditionType.name
        adConditionTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func warrentyTypesDonePickerView() {
        let warrentyType = warrentyTypes[self.warrentyTypesIndex]
        adWarrentyTextField.text = warrentyType.name
        adWarrentyTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func currencyTypesDonePickerView() {
        let currencyType = currencyTypes[self.currencyTypesIndex]
        adCurrencyTextField.text = currencyType.name
        adCurrencyTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func adPriceTypesDonePickerView() {
        let adPriceType = adPriceTypes[self.adPriceTypesIndex]
        adPriceTypeTextField.text = adPriceType
        adPriceTypeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func cancelPickerView() {
        self.view.endEditing(true)
    }
}

extension AddAdvVC: UIPickerViewDelegate,UIPickerViewDataSource{
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
        case 5:
            return currencyTypes.count
        case 6:
            return adPriceTypes.count
        case 7:
            return subCategoryTypes?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            let adType = adTypes[row]
            return adType.name
        case 2:
            let categoryType = categoryTypes[row]
            return categoryType.name
        case 3:
            let conditionType = conditionTypes[row]
            return conditionType.name
        case 4:
            let warrentyType = warrentyTypes[row]
            return warrentyType.name
        case 5:
            let currencyType = currencyTypes[row]
            return currencyType.name
        case 6:
            let adPriceType = adPriceTypes[row]
            return adPriceType
        case 7:
            let categoryType = subCategoryTypes?[row]
            return categoryType?.name
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let adType = adTypes[row]
            adTypeTextField.text = adType.name
            self.adTypesIndex = row
            self.adTypeTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 2:
            let categoryType = categoryTypes[row]
            adCategoryTextField.text = categoryType.name
            self.categoryTypesIndex = row
            print(categoryType)
            subCategoryTypes = categoryType.child
            if categoryType.child != nil {
                topPriceTF.constant = 58
                adSubCategoryTextField.isHidden = false
                if self.images.count != 0 {
                    self.borderViewHight.constant = 830
                    
                }else{
                    self.borderViewHight.constant = 770
                }
            }
            self.categoryID = categoryType.term_id!
            self.adCategoryTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 3:
            let conditionType = conditionTypes[row]
            adConditionTextField.text = conditionType.name
            self.conditionTypesIndex = row
            self.adConditionTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 4:
            let warrentyType = warrentyTypes[row]
            adWarrentyTextField.text = warrentyType.name
            self.warrentyTypesIndex = row
            self.adWarrentyTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 5:
            let currencyType = currencyTypes[row]
            adCurrencyTextField.text = currencyType.name
            self.currencyTypesIndex = row
            self.adCurrencyTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 6:
            let adPriceType = adPriceTypes[row]
            adPriceTypeTextField.text = adPriceType
            self.adPriceTypesIndex = row
            switch row{
            case 0 : self.adPriceType = "Fixed"
            case 1 : self.adPriceType = "Negotiable"
            case 2 : self.adPriceType = "on_call"
            case 3 : self.adPriceType = "auction"
            case 4 : self.adPriceType = "free"
            case 5 : self.adPriceType = "no_price"
            default: self.adPriceType = "Fixed"
            }
            self.adPriceTypeTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 7:
            let categoryType = subCategoryTypes?[row]
            adSubCategoryTextField.text = categoryType?.name
            self.subCategoryTypesIndex = row
            self.subCategoryID = categoryType?.term_id!
            self.adSubCategoryTextField.resignFirstResponder()
            self.view.endEditing(true)
        default:
            break
        }
    }
}

extension AddAdvVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            advPic = imageData
            self.advPicsArray.append(imageData)
            self.advfileArray.removeAll()
            var i = 0
            while i <= (self.advPicsArray.count)-1 {
                self.advfileArray.append("file[\(i)]")
                i = i + 1
            }
            
            self.base64Image =  image.convertBase64String(image: image)
            
            let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset
            if let fileName = asset?.value(forKey: "filename") as? String{
                
                addImageLabel.text = fileName
                
            } else {
                addImageLabel.text = "Img\(Date())"
            }
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            advPic = imageData
            
            
            self.base64Image =  image.convertBase64String(image: image)
            let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset
            if let fileName = asset?.value(forKey: "filename") as? String{
                addImageLabel.text = fileName
            }else{
                addImageLabel.text = "Img\(Date())"
            }
        }
        dismiss(animated:true, completion: nil)
    }
}

extension AddAdvVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "وصف الإعلان"
            textView.textColor = UIColor.lightGray
        }
    }
}
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension AddAdvVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAdsCell", for: indexPath) as! addAdsCell
        let img = images[indexPath.row]
        cell.img.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        images.remove(at: indexPath.row)
        titles.remove(at: indexPath.row)
         self.addImageLabel.text = self.titles.joined(separator: ",")
        if images.count == 0 {
            self.collectionView.isHidden = true
            self.topImgTFconstrain.constant = 12
            self.collectionHight.constant = 2
            if self.subCategoryTypes != nil {
                self.borderViewHight.constant = 830
                
            }else{
                self.borderViewHight.constant = 770
            }
            self.addImageLabel.text = "اضف صورة"
        }
        collectionView.reloadData()
    }
}
