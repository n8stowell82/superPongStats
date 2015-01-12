//
//  PlayerGameModel.swift
//  superPongStats
//
//  Created by Nathan Stowell on 1/9/15.
//  Copyright (c) 2015 OnePixelOff. All rights reserved.
//

import Foundation

class PlayerGameModel: NSObject, Printable {
    var gameId: Int?
    var position: Int?
    var playerId: Int?
    var killerId: Int?
    var gameTitle: String?
    
    init( playerid:Int, playerPosition:Int, gameid:Int, killerid:Int)
    {
        self.playerId = playerid
        self.position = playerPosition
        self.gameId = gameid
        self.killerId = killerid
    }
}
