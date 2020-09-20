//
//  Config.swift
//  Golden Store
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import Foundation

struct URLs {
    
    static let main = "https://www.marraa.net/wp-json/wp/v2/"
    static let Login = "https://www.marraa.net/wp-json/jwt-auth/v1/token"
    static let ForgetPassword = main + "forget"
    static let Register = main+"register"
    static let GetHome = main+"home"
    static let AdvPage = main+"adv"
    static let CategoryPage = main+"advcat"
    static let AddFavourite = main+"favadd"
    static let IncreseAdView = main+"advview"
    static let GetMyAds = main+"myads"
    static let GetAboutUs = main+"about"
    static let ContactUs = main+"contact"
    static let GetFAQ = main+"faq"
    static let publish = main+"publish"
    static let GetFavAds = main+"fav"
    static let RemoveFavAds = main+"favremove"
    static let ReportAd = main+"report"
    static let RateUser = main+"rate"
    static let GetUserAccountPage = main+"account"
    static let RemoveAdv = main+"removeadv"
    static let GetRules = main+"rules"
    static let ChangeUserPassword = main+"changepass"
    static let AdvancedSearch = main+"search"
    static let UpdateUserAccount = main+"account"
    static let GetUserDataWithId = main+"user"
    static let GetChats = main+"messages"
    static let SendMessage = main+"sendmessage"
    static let GetChat = main+"message"
    static let ReceivedMessages  = main+"receivedmessages"
    static let PuplishAd = main+"publish"
    static let bidAdv = main+"bid"
    static let EditAdv = main+"editadv"
    static let socialLogin = main+"sociallogin"
    static let featured = main+"featured"
    static let allAds = main+"allads"
}
