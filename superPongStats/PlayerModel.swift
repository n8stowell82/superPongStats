//
//  PlayerModel.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/20/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import Foundation

class PlayerModel: NSObject, Printable {
    let name: String
    let rank: Int
    let wins: Int
    let totalGames: Int
    let mostKilled: String
    let mostKilledBy: String
    var isInCurrentGame: Bool
    
    init(name: String?, rank: Int?, wins: Int?, totalGames:Int?, mostKilled:String?, mostKilledBy:String?) {
        self.name = name ?? ""
        self.rank = rank ?? 0
        self.wins = wins ?? 0
        self.totalGames = totalGames ?? 0
        self.mostKilled = mostKilled ?? ""
        self.mostKilledBy = mostKilledBy ?? ""
        self.isInCurrentGame = false
    }
}