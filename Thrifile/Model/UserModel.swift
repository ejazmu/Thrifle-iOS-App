//
//  UserModel.swift
//
//  Created by Asad Hussain on 14/09/2020.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit

class UserModel: NSObject , NSCoding {
    
    var msg : String!
    var token : String!
    var v : Int!
    var id : String!
    var date : String!
    var email : String!
    var isAdmin : Bool!
    var isDisabled : Bool!
    var isRequestedToResetPassword : Bool!
    var isVerified : Bool!
    var otpCode : Int!
    var password : String!
    var phoneNumber : String!
    var resetCode : AnyObject!
    var username : String!

    
    func encode(with aCoder: NSCoder) {
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if v != nil{
            aCoder.encode(v, forKey: "__v")
        }
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if isAdmin != nil{
            aCoder.encode(isAdmin, forKey: "isAdmin")
        }
        if isDisabled != nil{
            aCoder.encode(isDisabled, forKey: "isDisabled")
        }
        if isRequestedToResetPassword != nil{
            aCoder.encode(isRequestedToResetPassword, forKey: "isRequestedToResetPassword")
        }
        if isVerified != nil{
            aCoder.encode(isVerified, forKey: "isVerified")
        }
        if otpCode != nil{
            aCoder.encode(otpCode, forKey: "otpCode")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if phoneNumber != nil{
            aCoder.encode(phoneNumber, forKey: "phone_number")
        }
        if resetCode != nil{
            aCoder.encode(resetCode, forKey: "resetCode")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        v = aDecoder.decodeObject(forKey: "__v") as? Int
        id = aDecoder.decodeObject(forKey: "_id") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        isAdmin = aDecoder.decodeObject(forKey: "isAdmin") as? Bool
        isDisabled = aDecoder.decodeObject(forKey: "isDisabled") as? Bool
        isRequestedToResetPassword = aDecoder.decodeObject(forKey: "isRequestedToResetPassword") as? Bool
        isVerified = aDecoder.decodeObject(forKey: "isVerified") as? Bool
        otpCode = aDecoder.decodeObject(forKey: "otpCode") as? Int
        password = aDecoder.decodeObject(forKey: "password") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? String
        resetCode = aDecoder.decodeObject(forKey: "resetCode") as? AnyObject
        username = aDecoder.decodeObject(forKey: "username") as? String
    }
    
    init(dictionary: NSDictionary) {
        if let userData = dictionary["user"] as? NSDictionary {
            v = userData["__v"] as? Int
            id = userData["_id"] as? String
            date = userData["date"] as? String
            email = userData["email"] as? String
            isAdmin = userData["isAdmin"] as? Bool
            isDisabled = userData["isDisabled"] as? Bool
            isRequestedToResetPassword = userData["isRequestedToResetPassword"] as? Bool
            isVerified = userData["isVerified"] as? Bool
            otpCode = userData["otpCode"] as? Int
            password = userData["password"] as? String
            phoneNumber = userData["phone_number"] as? String
            resetCode = userData["resetCode"] as? AnyObject
            username = userData["username"] as? String
        }
        msg = dictionary["msg"] as? String
        token = dictionary["token"] as? String
    }
    
    static func currentUser() -> UserModel? {
        var user: UserModel?
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "Thrifile.user") {
            user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UserModel
        }
        return user
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        defaults.set(data, forKey: "Thrifile.user")
        defaults.synchronize()
    }
    
    func clear() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Thrifile.user")
        defaults.synchronize()
    }

}
