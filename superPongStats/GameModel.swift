//
//  GameModel.swift
//  superPongStats
//
//  Created by Nathan Stowell on 12/31/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import Foundation

class GameModel: NSObject, Printable {
    var gameTitle:String
    var winner: PlayerModel?
    var players = [PlayerModel]()
    //Dictionary of kills in game <Killed, KilledBy>
    var kills = Dictionary<Int,Int>()
    
    
    override init()
    {
        gameTitle = NSDate().description
    }
}