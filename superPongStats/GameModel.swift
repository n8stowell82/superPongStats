//
//  GameModel.swift
//  superPongStats
//
//  Created by Nathan Stowell on 12/31/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import Foundation

class GameModel: NSObject, Printable {
    var title:String?
    var winner: Int?
    var active:Bool?
    var id:Int?
    
    
    init(gameId:Int, gameTitle:String, gameWinner:Int, isActive:Bool)
    {
        id = gameId
        title = gameTitle
        winner = gameWinner
        active = isActive
    }
}