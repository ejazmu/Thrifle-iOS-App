//
//  AppConstants.swift
//  Thrifile
//

import UIKit

class AppConstants: NSObject {
    
    static let keyViewType = "ViewType"
    static var isListView: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyViewType)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyViewType)
        }
    }

    static let BaseURL : String = "https://thrifle-api.herokuapp.com"
    
    // Enviremnet URL's
    static let loginURL : String = "https://www.thrifle.com/api/auth"
    static let signupURL : String = "https://www.thrifle.com/api/users"
    static let forgotPassword : String = "https://www.thrifle.com/api/users/send-reset-password"
    static let getUserDeals : String = "https://www.thrifle.com/api/deals?sorted=mostRecent"
    static let getAllDeals : String = "https://www.thrifle.com/api/pagination/all-deals?sorted=mostRecent&limit=25&pageNumber="
    static let getFeaturedDeals : String = "https://www.thrifle.com/api/pagination/feature-deals?sorted=mostRecent&limit=25&pageNumber="
    static let postDeal : String = "https://www.thrifle.com/api/deals"
    static let contactUS : String = "https://www.thrifle.com/api/contact_us/send"
    static let getCoupons : String = "https://www.thrifle.com/api/deals/coupons?sorted=mostRecent"
    static let getMilataryDeals : String = "https://www.thrifle.com/api/pagination/military-deals?sorted=mostRecent&limit=25&pageNumber="
    static let searchADeal : String = "https://www.thrifle.com/api/deals?sorted=&searchText="
    static let getDealByCategory : String = "https://www.thrifle.com/api/deals/deal-by-category/60c4790db3d65c4dd7354e8b"
    static let getImagesByTitle : String = "https://www.thrifle.com/api/scrap/images"
    static let getAllBlogs : String = "https://www.thrifle.com/api/blog/posts/get-all"
    static let getAllLogos : String = "https://www.thrifle.com/api/web/get/logos/all"
    static let updateLogo : String = "https://www.thrifle.com/api/web/enable-logo-image/"
    static let deleteAccount : String = "https://www.thrifle.com/api/users/delete-account"

}


class StoryboardRef {
    static let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

class Colors {
    static let lightRedButtonShadow = "D93957"
//    static let NAV_BAR_COLOR = UIColor(hexString: "#F7F7F7")
    static let BACKGROUND_COLOR = UIColor(hexString: "#F7F7F7")
    static let AppAlertWarningColor = UIColor(hexString: "#F98C3D") // Orange color
    static let AppAlertSuccessColor = UIColor(hexString: "#7BAF5C") // Green color
    static let AppAlertErrorColor = UIColor(hexString: "#FA2A32") // Red color
    static let AppThemeBlueColor = UIColor(hexString: "#3497FD") // Blue
}
