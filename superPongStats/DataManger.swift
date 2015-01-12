//
//  DataManger.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/20/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import Foundation
import Alamofire

let baseAPIhost = "https://powerful-wildwood-4113.herokuapp.com/api/"

class DataManager {
    
    class func getPlayerDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        //1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("Players",ofType:"json")
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        })
    }
    
    class func loadPlayerDataFromURL(path: String, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        let url = NSURL(string: baseAPIhost + path)
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.nathanstowell", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func postPlayerDataToURL(path: String, playerData:PlayerModel, completion:(data: NSData?, error: NSError?) -> Void){
        let url = NSURL( string: baseAPIhost + path )
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var error: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(playerData.toDictionary(), options: nil, error: &error)
        Alamofire.request(request).responseJSON{ (request, response, responseObject, error) in
            if responseObject == nil {
                println(error)
            } else {
                println(responseObject)
            }
        }
    }
}