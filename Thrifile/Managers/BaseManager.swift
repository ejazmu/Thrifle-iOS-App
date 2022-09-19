//
//  BaseManager.swift
//  Centropix_Mobile
//
//  Created by Asad Hussain on 23/08/2020.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD

class BaseManager: NSObject {
    
    var headers: HTTPHeaders!
    
    func func_Show_Progress(){
        //            SVProgressHUD.setMinimumSize(CGSize(width: 200, height: 200))
        //            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        //            SVProgressHUD.setBackgroundColor(UIColor.clear)
        //            SVProgressHUD.setImageViewSize(CGSize(width: 100, height: 100))
        SVProgressHUD.setMinimumDismissTimeInterval(60)
        //            SVProgressHUD.show()
        
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    //        func func_showErrorMessage(_ message : String){
    //            let banner = GrowingNotificationBanner(title: "Message", subtitle: message, style: .danger)
    //            banner.show()
    //        }
    
    override init() {
        let user = UserModel.currentUser()
        headers = nil
        
//        if user != nil {
//            headers = [
//                "Authorization": "Bearer " + user!.token!
//            ]
//        }
    }
    
    open func updateHeaders(){
//        let user = UserModel.currentUser()
//        self.headers = nil
//        
//        if user != nil {
//            self.headers = [
//                "Authorization": "Bearer " + user!.token!
//            ]
//        }
    }
    
}


func showSVLoader(){
    SVProgressHUD.setBackgroundLayerColor(UIColor.white)
    SVProgressHUD.setBackgroundColor(UIColor.clear)
    SVProgressHUD.setForegroundColor(UIColor.white)
    SVProgressHUD.setImageViewSize(CGSize(width: 100, height: 100))
//    SVProgressHUD.setMinimumDismissTimeInterval(60)
    SVProgressHUD.show()
    SVProgressHUD.setDefaultMaskType(.gradient)
}

func hideSVLoader(){
    SVProgressHUD.dismiss()
}
