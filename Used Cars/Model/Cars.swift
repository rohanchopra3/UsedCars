//
//  Cars.swift
//  Used Cars
//
//  Created by Rohan Chopra on 7/7/21.
//

import Foundation
import SwiftyJSON

struct cars {
    var Year:Int
    var Make:String
    var Model:String
    var Trim:String
    var Price:Double
    var Mileage:Double
    var Location:String
    var DealerNumber:String
    var carImage : UIImage?
    var carImageURl:String
}
// change the url to fetch for more items
let urlString = "https://carfax-for-consumers.firebaseio.com/assignment.json"

// helper Variables to implement pagination
var imageDownloadCounter = 0
var endimageDownloadCounter = 0
var interval = 10 

// To make a get request and store data in the cars object
func makeAPICall(UrlString :String, completionHandler: @escaping ([cars])-> () ) {
    
    // Setup the url request
    guard let url = URL(string: UrlString) else { return }
    var getRequest = URLRequest(url: url)
    getRequest.httpMethod = "GET"
    
    // Making the request
    
    URLSession.shared.dataTask(with: getRequest){
        (data, _ , error) in
    
        if let error = error{
            // get request failed
            NSLog("URL request failed with error: \(error)")
            
        }
        
        if let data = data{
            let json = JSON(data)
            var carsObject:[cars] = []
            for (_,subJson):(String, JSON) in json["listings"] {
                carsObject.append(cars(Year: subJson["year"].int ?? 0 , Make: subJson["make"].string ?? " " , Model: subJson["model"].string ?? " ", Trim: subJson["trim"].string ?? " " , Price: subJson["listPrice"].double ?? 0.0 , Mileage: subJson["mileage"].double ?? 0.0, Location: ((subJson["dealer"]["city"].string ?? "") + "," + (subJson["dealer"]["state"].string ?? " ")), DealerNumber: subJson["dealer"]["phone"].string ?? " ", carImageURl: subJson["images"]["firstPhoto"]["large"].string ?? " "))
            }
            completionHandler(carsObject)
        }else{
            NSLog("URL request failed")
        }
    }.resume()
}

// To make a get request and store images in the cars object
func downloadImages(UrlString:String,completionHandler: @escaping (Data?)-> ()){
    guard let url = URL(string: UrlString) else { return }
    
    URLSession.shared.dataTask(with: url){
        
        (data, _ , error) in
        if let error = error{
            // get request failed
            NSLog("URL request failed with error: \(error)")
            completionHandler(nil)
        }
        
        if let data = data{
            completionHandler(data)
        }else{
            NSLog("fail with \(urlString)")
        }
    }.resume()
}

func calculatePaginationParametersfor(interval: Int, total_count: Int){
    // This function is important as is computes pagination parameters, number of items to fetch.
    // change the interval parameters for number of items per fetch, default 10
    if imageDownloadCounter != total_count{
        
        if (endimageDownloadCounter + interval) < total_count{
            endimageDownloadCounter += interval
        }else{
            endimageDownloadCounter = total_count
        }
        
    }
}
