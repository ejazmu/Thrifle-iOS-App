//
//  UserManager.swift
//

import UIKit
import Alamofire
import SVProgressHUD
import SCLAlertView

class UserManager: BaseManager {
    
    var user : UserModel?
    
    override init() {
        super.init()
    }
    
    init(user: UserModel) {
        self.user = user
    }
    
    static let shared = UserManager()
    
    func signupManagerfunc(phone_number : String ,email : String,password : String,username : String, onComplete: @escaping ((Bool, (UserModel)) -> Void)){
        
        showSVLoader()
        let params : Parameters = [
            "email"  : email,
            "password"  : password,
            "username"  : username
        ]
        
        AF.request(AppConstants.signupURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    if let json = value as? NSDictionary {
                        onComplete(true, UserModel(dictionary: json))
                    }
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Email already exist.", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func loginManagerfunc(email : String ,password : String, onComplete: @escaping ((Bool, (UserModel)) -> Void)){
        
        showSVLoader()
        let params : Parameters = [
            "username" : email,
            "password" : password
        ]
        
        self.updateHeaders()
        
        AF.request(AppConstants.loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    if let json = value as? NSDictionary {
                        
                        let user = UserModel(dictionary: json)
                        
                        if let _ = user.token{
                            onComplete(true, user)
                        }else{
                            onComplete(false, user)
                        }
                    }
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 499{
                    showErrorMessage(message: NSLocalizedString("Invalid Email or Password.", comment: ""))
                }
                else if code == 417{
                    showErrorMessage(message: NSLocalizedString("Invalid Email or Password.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func deleteAccount(onComplete: @escaping ((Bool) -> Void)){
        
        
        guard let user = UserModel.currentUser()  else { return }

        showSVLoader()
        
        
        let header : HTTPHeaders = [
            "x-auth-token": user.token!
        ]
        
        AF.request(AppConstants.deleteAccount, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    onComplete(true)
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func sendResetPasswprdLink(email : String, onComplete: @escaping ((Bool) -> Void)){
        
        showSVLoader()
        let params : Parameters = [
            "email": email
        ]
        
        
        AF.request(AppConstants.forgotPassword, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    onComplete(true)
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    
    func getAdsForUser(onComplete: @escaping ((Bool, [ListingModel]) -> Void)){
        
        let urlString = "\(AppConstants.getUserDeals)"
        showSVLoader()
        
        var listingDataToSend : [ListingModel] = []
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    if let values = value as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,listingDataToSend)
                    } else {
                        onComplete(false,[])
                    }
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func getAllAds(page : Int, onComplete: @escaping ((Bool, [ListingModel], Int) -> Void)){
        
        let urlString = "\(AppConstants.getAllDeals)\(page)"
        var listingDataToSend : [ListingModel] = []
        var pages = 1
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    
                    if let valueDic = value as? [String : Any] {
                        pages = valueDic["pages"] as? Int ?? 1
                        if let values = valueDic["deals"] as? NSArray {
                            for dataValue in values {
                                if let dataAsDic = dataValue as? [String : Any] {
                                    listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                                }
                            }
                            onComplete(true,listingDataToSend,pages)
                        } else {
                            onComplete(false,[],1)
                        }
                    } else {
                        onComplete(false,[],1)
                    }
                    
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }

    
    
    
    func getAllBlogs(onComplete: @escaping ((Bool, [ListingModel]) -> Void)){
        
        let urlString = "\(AppConstants.getAllBlogs)"
        var listingDataToSend : [ListingModel] = []
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    
                    if let valueDic = value as? [String : Any] {
                        if let values = valueDic["posts"] as? NSArray {
                            for dataValue in values {
                                if let dataAsDic = dataValue as? [String : Any] {
                                    listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                                }
                            }
                            onComplete(true,listingDataToSend)
                        } else {
                            onComplete(false,[])
                        }
                    } else {
                        onComplete(false,[])
                    }

                    
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }

    func getFeaturedDeals(page : Int, onComplete: @escaping ((Bool, [ListingModel], Int) -> Void)){
        
        let urlString = "\(AppConstants.getFeaturedDeals)\(page)"
        var listingDataToSend : [ListingModel] = []
        var pages = 1
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {

                    if let valueDic = value as? [String : Any] {
                        pages = valueDic["pages"] as? Int ?? 1
                        if let values = valueDic["featureDeals"] as? NSArray {
                            for dataValue in values {
                                if let dataAsDic = dataValue as? [String : Any] {
                                    listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                                }
                            }
                            onComplete(true,listingDataToSend,pages)
                        } else {
                            onComplete(false,[],1)
                        }
                    } else {
                        onComplete(false,[],1)
                    }


                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }

    
    
    func postDeals(title : String,price : String,category_name : String,link : String,imageUrl : [[String : String]],description : String, onComplete: @escaping ((Bool) -> Void)){
        
        
        guard let user = UserModel.currentUser()  else { return }

        showSVLoader()
        
        let params : Parameters = [
            "title":title,
            "price":price,
            "category_name":category_name,
            "link":link,
            "images":imageUrl,
            "description":description
        ]
        
        
        let header : HTTPHeaders = [
            "x-auth-token": user.token!
        ]
        
        AF.request(AppConstants.postDeal, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    onComplete(true)
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    
    func updateLogo(logoId: String, onComplete: @escaping ((Bool) -> Void)) {
        
        guard let user = UserModel.currentUser()  else { return }

        showSVLoader()
        
        let header : HTTPHeaders = [
            "x-auth-token": user.token!
        ]
        
        let url = AppConstants.updateLogo + logoId
        
        AF.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    onComplete(true)
                } else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func getAllLogos(onComplete: @escaping ((Bool,[LogoModel]) -> Void)){
        
        
        guard let user = UserModel.currentUser()  else { return }

        showSVLoader()
        
        let header : HTTPHeaders = [
            "x-auth-token": user.token!
        ]
        
        AF.request(AppConstants.getAllLogos, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    var logoModel : [LogoModel] = []
                    if let values = value as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                logoModel.append(LogoModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,logoModel)
                    }
                } else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }

    
    func contactUS(name : String, email : String, message : String, onComplete: @escaping ((Bool) -> Void)){
        
        showSVLoader()
        
        let params : Parameters = [
            "name": name,
            "email": email,
            "message": message
        ]
        
        
        AF.request(AppConstants.contactUS, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    onComplete(true)
                }
                else if code == 400 {
                    if let json = value as? NSDictionary {
                        if let errorMessage = json["errors"] as? NSArray {
                            if let json = errorMessage.firstObject as? NSDictionary {
                                let message : String = json["msg"] as? String ?? ""
                                showErrorMessage(message: message)
                            } else {
                                showErrorMessage(message: "\(errorMessage.firstObject)")
                            }
                        }
                        else {
                            showErrorMessage(message: NSLocalizedString("Unable to parse the error message", comment: ""))
                        }
                    }
                    else {
                        showErrorMessage(message: NSLocalizedString("Invalid Email", comment: ""))
                    }
                }
                else if code == 417 {
                    showWarningrMessage(message: NSLocalizedString("Email does not exist", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    
    func getCouponsDeals(onComplete: @escaping ((Bool, [ListingModel]) -> Void)){
        
        let urlString = "\(AppConstants.getCoupons)"
        showSVLoader()
        
        var listingDataToSend : [ListingModel] = []
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    guard let dataSet = value as? NSDictionary else { return }
                    if let values = dataSet["CouponDeals"] as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,listingDataToSend)
                    } else {
                        onComplete(false,[])
                    }
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    
    func getMilatrayDeals(page : Int, onComplete: @escaping ((Bool, [ListingModel], Int) -> Void)){
        
        let urlString = "\(AppConstants.getMilataryDeals)\(page)"
        var listingDataToSend : [ListingModel] = []
        var pages = 1
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    guard let dataSet = value as? NSDictionary else { return }
                    pages = dataSet["pages"] as? Int ?? 1
                    if let values = dataSet["militaryDeals"] as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,listingDataToSend, pages)
                    } else {
                        onComplete(false,[],pages)
                    }
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func getSearchResults(text: String, onComplete: @escaping ((Bool, [ListingModel]) -> Void)){
        
        let urlString = "\(AppConstants.searchADeal)\(text)"
        showSVLoader()
        
        var listingDataToSend : [ListingModel] = []
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    if let values = value as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                listingDataToSend.append(ListingModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,listingDataToSend)
                    } else {
                        onComplete(false,[])
                    }
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    
    func getImagesByTitle(text: String, onComplete: @escaping ((Bool, [ImagesModel]) -> Void)){
        
        let urlString = "\(AppConstants.getImagesByTitle)"
        showSVLoader()
        
        let params : Parameters = [
            "imageTitle": text
        ]
        
        
        var listingDataToSend : [ImagesModel] = []
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            switch response.result {
            case let .success(value):
                if code == 200 {
                    if let values = value as? NSArray {
                        for dataValue in values {
                            if let dataAsDic = dataValue as? [String : Any] {
                                listingDataToSend.append(ImagesModel(fromDictionary: dataAsDic))
                            }
                        }
                        onComplete(true,listingDataToSend)
                    } else {
                        onComplete(false,[])
                    }
                }
                else if code == 400 {
                    showWarningrMessage(message: NSLocalizedString("Password reset failed, please enter correct code", comment: ""))
                }
                else if code > 499{
                    showErrorMessage(message: NSLocalizedString("Please wait server couldn't process the request.", comment: ""))
                }
                else {
                    showErrorMessage(message: NSLocalizedString("Network Error", comment: ""))
                }
            case let .failure(error):
                showErrorMessage(message: error.errorDescription ?? error.localizedDescription)
            }
        }
    }



}

