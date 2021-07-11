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
    var carImage : Data?
    var carImageURl:String
}

let urlString = "https://carfax-for-consumers.firebaseio.com/assignment.json"
var imageDownloadCounter = 0 

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
                carsObject.append(cars(Year: subJson["year"].int ?? 0 , Make: subJson["make"].string ?? " " , Model: subJson["model"].string ?? " ", Trim: subJson["trim"].string ?? " " , Price: subJson["listPrice"].double ?? 0.0 , Mileage: subJson["mileage"].double ?? 0.0, Location: ((subJson["dealer"]["city"].string ?? "") + "," + (subJson["dealer"]["state"].string ?? " ")), DealerNumber: subJson["dealer"]["phone"].string ?? " ", carImageURl: subJson["images"]["firstPhoto"]["medium"].string ?? " "))
            }
            completionHandler(carsObject)
        }else{
            NSLog("URL request failed")
        }
    }.resume()
}

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
            print("fail")
            print(urlString)
        }
    }.resume()
}
