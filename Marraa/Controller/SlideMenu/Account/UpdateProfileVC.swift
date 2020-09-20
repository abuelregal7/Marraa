//
//  UpdateProfileVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import Photos

class UpdateProfileVC: UIViewController {

    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var name:String?
    var email:String?
    var phone:String?
    var location:String?
    var advPic: Data?
    var base64Image:String?
    var advPicsArray = [Data]()
    var advfileArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UserDefaults.standard.value(forKey: "user_pic") as? String
        nameTextField.text = name!
        phoneTextField.text = phone!
        locationTextField.text = location!
        self.userButton.addTarget(self, action: #selector(openCameraOrGallery(_:)), for: .touchUpInside)
        
        if image != nil {
            self.userImage.setImageWith(image!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "تعديل الملف الشخصي"
        self.navigationItem.hidesBackButton = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        let header=[
            "Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as! String)"
        ]
        let body = [
            "name":nameTextField.text!,
            "contact":phoneTextField.text!,
            "address":locationTextField.text!
        ]
        API.POSTImageProfile(url: URLs.UpdateUserAccount, Images: self.advPic, header: header, parameters: body as [String : Any]){ (success, value) in
            if success{
                let dict = value
                if let msg = dict["message"] as? String{
                    Alert.showAlert(target: self, title: msg, message: "", okAction: "رجوع", actionCompletion: { (ـ) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    Alert.showAlertOnVC(target: self, title: "حدث خطأ", message: "حاول في وقت لاحق")
                }
            }else{
                let alert = UIAlertController(title:"شبكة الإنترنيت سيئة أو ضعيفة", message: "تفقد اتصالك بالشبكة ثم أعد المحاولة", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "أعد المحاولة", style: UIAlertActionStyle.default, handler: { (ـ) in
                    self.saveBtnPressed(sender)
                }))
                alert.addAction(UIAlertAction(title: "تجاهل", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func changePasswordBtnPressed(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC")
        self.show(vc, sender: nil)
        
    }
}

extension UpdateProfileVC{
    @objc func openCameraOrGallery(_ recognizer: UITapGestureRecognizer ){
        print("Heeere")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "اختيار الصورة", message: nil, preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "معرض الصور", style: .default, handler: { (action) -> Void in
            print("Photo Library tapped")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }else{
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
            if let act = alertController.popoverPresentationController {
            }
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.present(alertController, animated: true, completion: nil)}
    }
}

extension UpdateProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            advPic = imageData
            self.userImage.image = image
            self.advPicsArray.removeAll()
            self.advPicsArray.append(imageData)
            self.advPic = imageData
            self.base64Image =  image.convertBase64String(image: image)
            
            let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset
            if let fileName = asset?.value(forKey: "filename") as? String{
            } else {
                
            }
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageData:Data = UIImagePNGRepresentation((image))! as Data
            advPic = imageData
            
            
            self.base64Image =  image.convertBase64String(image: image)
            let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset
            if let fileName = asset?.value(forKey: "filename") as? String{
            } else {
                
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
}
