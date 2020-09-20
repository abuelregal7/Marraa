//
//  PackegesVC.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import WebKit
class PackegesVC: UIViewController , UIWebViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        webView.delegate = self
        self.view.addSubview(webView)
        let url = URL (string: "https://www.marraa.net/packages-and-pricing/")
        let request = URLRequest(url: url! as URL)
        webView.loadRequest(request)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("web view start loading")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("web view load completely")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("web view loading fail : ",error.localizedDescription)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
    }
    
    public func setNavigationControll(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "الباقات"
        addRightBarButtonWithImage(#imageLiteral(resourceName: "Burger Button"))
        self.navigationItem.hidesBackButton = true
    }
}
