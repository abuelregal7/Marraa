//
//  EditAdvVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class EditAdvVC: UIViewController {

    @IBOutlet weak var adTitleTextField: InsertTextField!
    @IBOutlet weak var adPriceTextField: InsertTextField!
    @IBOutlet weak var adAddressTextField: InsertTextField!
    @IBOutlet weak var adVideoLinkTextField: InsertTextField!
    @IBOutlet weak var adDecriptionTextView: UITextView!
    @IBOutlet weak var adCategoryTextField: InsertTextField!
    @IBOutlet weak var adPriceTypeTextField: InsertTextField!
    @IBOutlet weak var adWarrentyTextField: InsertTextField!
    @IBOutlet weak var adCurrencyTextField: InsertTextField!
    @IBOutlet weak var adConditionTextField: InsertTextField!
    @IBOutlet weak var adTypeTextField: InsertTextField!
    @IBOutlet weak var addImageLabel: UILabel!
    
    var advPic = [Data]()
    var base64Image:String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesAndNamesArr = [(UIImage, Data)]()
    var imageNames = [String]()


    @IBOutlet weak var imgImageView: UIImageView!

    var imageAdv: UIImage?
    var adModel: AdModel?
    var adContent: String?
    var advId:Int?
    var isEdit: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adTitleTextField.text = adModel!.title
        self.adPriceTextField.text = adModel!.price
        self.adAddressTextField.text = adModel!.location
        self.adDecriptionTextView.text = adContent!
        self.adDecriptionTextView.textColor = UIColor.black
        if adModel?.images != nil {
            self.imgImageView.setImageWith(adModel!.images[0].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        }
        self.imageNames = (adModel?.images)!
        print(self.imageNames.count)
        adDecriptionTextView.delegate = self
        showAllPickerViews()
        
        addImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCameraOrGallery(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "تعديل إعلان"
        self.navigationItem.hidesBackButton = false
    }

    @objc func openCameraOrGallery(_ recognizer: UITapGestureRecognizer ){
        print("Heeere")
        //        pick image
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "اختيار الصورة", message: nil, preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "معرض الصور", style: .default, handler: { (action) -> Void in
            print("Photo Library tapped")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else{
                let alert = UIAlertController(title: "معرض الصور لا يعمل", message: "قم بإعادة تشغيل جهازك", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "رجوع", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        let  cameraButton = UIAlertAction(title: "الكاميرا", style: .default, handler: { (action) -> Void in
            print("Camera tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "الكاميرا لا تعمل", message: "قم بإعادة تشغيل جهازك", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "رجوع", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        alertController.addAction(galleryButton)
        alertController.addAction(cameraButton)
        alertController.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad{
            if let act = alertController.popoverPresentationController{
                act.sourceView = addImageLabel
                act.sourceRect = addImageLabel.bounds
            }
            self.present(alertController, animated: true, completion: nil)
        } else{
            self.present(alertController, animated: true, completion: nil)}
    }
    
    @IBAction func puplishAdvBtnPressed(_ sender: Any) {
        guard var advTitle = adTitleTextField.text , !(adTitleTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة عنوان الإعلان", message:"")
        }
        
        guard var advPrice = adPriceTextField.text , !(adPriceTextField.text?.isEmpty)! else{
            return Alert.showAlertOnVC(target: self, title: "يجب كتابة سعر الإعلان", message:"")
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
        
        guard var advWarrenty = adWarrentyTextField.text  else{
            return Alert.showAlertOnVC(target: self, title: "يجب اختيار الضمان", message:"")
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
    
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        
        var body=[
            "adv_id":advId!,
            "ad_title":advTitle,
            "ad_cat":categoryID,
            "ad_price_type":adPriceType,
            "ad_price":advPrice,
            "ad_warranty":advWarrenty,
            "ad_currency":advCurrency,
            "condition":advCondition,
            "user_address":advAddress,
            "ad_type":advType,
            "ad_description":advDescription
            ] as [String : Any]
        if let advVideoLink = adVideoLinkTextField.text , !(adVideoLinkTextField.text?.isEmpty)! {
            body["ad_yvideo"] = advVideoLink
        }

        API.POSTImageEdit(url: URLs.EditAdv, Images: self.advPic, Keys: ["file[0]"], header: header, parameters: body) { (success, value) in
            if success{
                
                if let dict = value as? [String:Any]{
                if let msg = dict["message"] as? String{
                    if msg == "تم الاضافة بنجاح" {
                        Alert.showAlert(target: self, title: "تم التعديل", message: "تأخذ التعديلات وقتًا حتي تدخل في حيز التفعيل", okAction: "رجوع", actionCompletion: { (ـ) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        
                    }else{
                        print(self.advPic.count)
                        Alert.showAlertOnVC(target: self, title: msg, message: "")
                    }
                }
            }
        } else {
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var adTypes = ["تبادل" , "طلب" , "عرض"]
    var categoryTypes = ["تبني" , "المواشي" , "الطيور" , "الحيوانات" , "الاكسسوارات و التغذي" , "الأسماك" , "أخرى"]
    var conditionTypes = ["جديد" , "مستعمل"]
    var warrentyTypes = ["يوجد ضمان" , "لا يوجد ضمان"]
    var currencyTypes = ["درهم" , "دينار", "ريـال" ]
    var adPriceTypes = ["ثابت" , "قابل للتفاوض" , "السعر علي المكالمة" , "على السوم" , "لا يوجد سعر" ]
    
    var adTypesPickerView = UIPickerView()
    var categoryTypesPickerView = UIPickerView()
    var conditionTypesPickerView = UIPickerView()
    var warrentyTypesPickerView = UIPickerView()
    var currencyTypesPickerView = UIPickerView()
    var adPriceTypesPickerView = UIPickerView()
    
    var adTypesIndex = 0
    var categoryTypesIndex = 0
    var conditionTypesIndex = 0
    var warrentyTypesIndex = 0
    var currencyTypesIndex = 0
    var adPriceTypesIndex = 0
    
    var categoryID = 0
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
        adWarrentyTextField.text = warrentyType
        adWarrentyTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func currencyTypesDonePickerView() {
        let currencyType = currencyTypes[self.currencyTypesIndex]
        adCurrencyTextField.text = currencyType
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

extension EditAdvVC: UIPickerViewDelegate,UIPickerViewDataSource{
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
        case 5:
            let currencyType = currencyTypes[row]
            return currencyType
        case 6:
            let adPriceType = adPriceTypes[row]
            return adPriceType
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
            adWarrentyTextField.text = warrentyType
            self.warrentyTypesIndex = row
            self.adWarrentyTextField.resignFirstResponder()
            self.view.endEditing(true)
        case 5:
            let currencyType = currencyTypes[row]
            adCurrencyTextField.text = currencyType
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
            case 4 : self.adPriceType = "no_price"
            default: self.adPriceType = "Fixed"
            }
            self.adPriceTypeTextField.resignFirstResponder()
            self.view.endEditing(true)
        default:
            break
        }
    }
}

extension EditAdvVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            self.isEdit = true
            self.imagesAndNamesArr.append((image, imageData))
            collectionView.reloadData()
            self.imgImageView.image = image
            self.base64Image =  image.convertBase64String(image: image)
            
            let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset
            if let fileName = asset?.value(forKey: "filename") as? String{
                addImageLabel.text = fileName
            }else{
                addImageLabel.text = "Img\(Date())"
            }
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            self.isEdit = true
            self.imagesAndNamesArr.append((image, imageData))
            
            collectionView.reloadData()

            self.imgImageView.image = image
            
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

extension EditAdvVC : UITextViewDelegate {
    
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

extension EditAdvVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCVCell
        
        if isEdit {
            cell.image.image = imagesAndNamesArr[indexPath.item].0
            
        }else {
 
            let orderFile = imageNames[indexPath.item]
            
            let downloadURL = URL(string:  orderFile)
            if downloadURL != nil {
                cell.image.kf.setImage(with: downloadURL)
            }
        }
        
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if isEdit {
            return imagesAndNamesArr.count
        }else {
            return imageNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 60 , height: 60)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    @objc func deleteClicked(_ sender: UIButton) {
      
        let buttonPostion = sender.convert(sender.bounds.origin, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: buttonPostion) {
            let rowIndex =  indexPath.row
            if isEdit {
                let  images  = imagesAndNamesArr[rowIndex]
                self.imagesAndNamesArr.remove(at: rowIndex)
                self.advPic.remove(at: rowIndex)
                collectionView.reloadData()
            }else{
                self.imageNames.remove(at: rowIndex)
                collectionView.reloadData()
            }
        }
    }
}
