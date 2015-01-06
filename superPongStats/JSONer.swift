//
//  JSONer.swift
//  superPongStats
//
//  Created by Nathan Stowell on 1/5/15.
//  Copyright (c) 2015 OnePixelOff. All rights reserved.
//

import Foundation

public class JSONer{
    

    class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }
}