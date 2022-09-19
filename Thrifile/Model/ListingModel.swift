//
//  ListingModel.swift
//  Thrifile
//
//  Created by Asad Hussain on 17/07/2022.
//

import UIKit

class ListingModel: NSObject {
    
    var v : Int!
    var id : String!
    var averageRating : Int!
    var categoryId : String!
    var categoryName : String!
    var comments : [AnyObject]!
    var counts : Int!
    var coupon : String!
    var date : String!
    var descriptionField : String!
    var disabled : Bool!
    var displayOnHome : Bool!
    var homeScreenAddDate : String!
    var imageUrl : String!
    var imageLinks : [String]!
    var images : [AnyObject]!
    var likes : [AnyObject]!
    var link : String!
    var postedBy : String!
    var price : Any!
    var ratings : [AnyObject]!
    var spamReportBy : [AnyObject]!
    var title : String!
    var totalSpamReports : Int!
    var userId : String!
    var content : String!
    var thumbnail : String!

    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        averageRating = dictionary["averageRating"] as? Int
        categoryId = dictionary["category_id"] as? String
        categoryName = dictionary["category_name"] as? String
        comments = dictionary["comments"] as? [AnyObject]
        counts = dictionary["counts"] as? Int
        coupon = dictionary["coupon"] as? String
        date = dictionary["date"] as? String
        descriptionField = dictionary["description"] as? String
        disabled = dictionary["disabled"] as? Bool
        displayOnHome = dictionary["displayOnHome"] as? Bool
        homeScreenAddDate = dictionary["homeScreenAddDate"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageLinks = dictionary["image_links"] as? [String]
        images = dictionary["images"] as? [AnyObject]
        likes = dictionary["likes"] as? [AnyObject]
        link = dictionary["link"] as? String
        postedBy = dictionary["posted_by"] as? String
        price = dictionary["price"] as? Any
        ratings = dictionary["ratings"] as? [AnyObject]
        spamReportBy = dictionary["spamReportBy"] as? [AnyObject]
        title = dictionary["title"] as? String
        totalSpamReports = dictionary["totalSpamReports"] as? Int
        userId = dictionary["user_id"] as? String
        content = dictionary["content"] as? String
        thumbnail = dictionary["thumbnail"] as? String
    }

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if averageRating != nil{
            dictionary["averageRating"] = averageRating
        }
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if comments != nil{
            dictionary["comments"] = comments
        }
        if counts != nil{
            dictionary["counts"] = counts
        }
        if coupon != nil{
            dictionary["coupon"] = coupon
        }
        if date != nil{
            dictionary["date"] = date
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if disabled != nil{
            dictionary["disabled"] = disabled
        }
        if displayOnHome != nil{
            dictionary["displayOnHome"] = displayOnHome
        }
        if homeScreenAddDate != nil{
            dictionary["homeScreenAddDate"] = homeScreenAddDate
        }
        if imageUrl != nil{
            dictionary["imageUrl"] = imageUrl
        }
        if imageLinks != nil{
            dictionary["image_links"] = imageLinks
        }
        if images != nil{
            dictionary["images"] = images
        }
        if likes != nil{
            dictionary["likes"] = likes
        }
        if link != nil{
            dictionary["link"] = link
        }
        if postedBy != nil{
            dictionary["posted_by"] = postedBy
        }
        if price != nil{
            dictionary["price"] = price
        }
        if ratings != nil{
            dictionary["ratings"] = ratings
        }
        if spamReportBy != nil{
            dictionary["spamReportBy"] = spamReportBy
        }
        if title != nil{
            dictionary["title"] = title
        }
        if totalSpamReports != nil{
            dictionary["totalSpamReports"] = totalSpamReports
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }


    
}

class ImagesModel: NSObject {
    
    var source : String!
    var title : String!
    var url : String!

    init(fromDictionary dictionary: [String:Any]){
        source = dictionary["source"] as? String
        title = dictionary["title"] as? String
        url = dictionary["url"] as? String
    }

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if source != nil{
            dictionary["source"] = source
        }
        if title != nil{
            dictionary["title"] = title
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }


}


class LogoModel: NSObject {
    
    
    var v : Int!
    var id : String!
    var image : String!
    var isEnabled : Bool!
    var userId : String!
    
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        image = dictionary["image"] as? String
        isEnabled = dictionary["isEnabled"] as? Bool
        userId = dictionary["user_id"] as? String
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if isEnabled != nil{
            dictionary["isEnabled"] = isEnabled
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
