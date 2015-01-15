//
//  PlayerModel.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/20/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import Foundation

class PlayerModel: Serializable, Printable {
    let id: Int
    let name: String
    var slogan: String
    let wins: Int
    let totalGames: Int
    let mostKilled: String
    let mostKilledBy: String
    var rank: Int
    var isInCurrentGame: Bool
    
    init(id: Int?, name: String?, slogan: String?, rank: Int?, wins: Int?, totalGames:Int?, mostKilled:String?, mostKilledBy:String?) {
        self.id = id ?? 0
        self.name = name ?? ""
        self.slogan = slogan ?? ""
        self.rank = rank ?? 0
        self.wins = wins ?? 0
        self.totalGames = totalGames ?? 0
        self.mostKilled = mostKilled ?? ""
        self.mostKilledBy = mostKilledBy ?? ""
        self.isInCurrentGame = false
    }
    
    func setSlogan(newSlogan:String){
        slogan = newSlogan
    }
}