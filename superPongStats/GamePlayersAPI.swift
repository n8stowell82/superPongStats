//
//  GamePlayersAPI.swift
//  superPongStats
//
//  Created by Nathan Stowell on 12/28/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit

class GamePlayersAPI: NSObject {
    
    private var players = [PlayerModel]()
   
    //1
    class var sharedInstance: GamePlayersAPI {
        //2
        struct Singleton {
            //3
            static let instance = GamePlayersAPI()
        }
        //4
        return Singleton.instance
    }
    
    func getPlayersInGame() -> [PlayerModel] {
        return players
    }
    
    func addPlayerToGame(player: PlayerModel) {
        if !player.isInCurrentGame{
            player.isInCurrentGame = true
            players.append(player)
            notifyOfPlayerUpdate()
            notifyOfPlayerAdded(player)
        }
    }
    
    func deletePlayer(player: PlayerModel) {
        let index = (players as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        
        let player = players[index]
        players.removeAtIndex(index)
        notifyOfPlayerUpdate()
        notifyOfPlayerRemoval(player)
    }
    
    private func notifyOfPlayerUpdate(){
        NSNotificationCenter.defaultCenter().postNotificationName("InGamePlayersUpdated", object: self)
    }
    
    private func notifyOfPlayerAdded(player: PlayerModel){
        NSNotificationCenter.defaultCenter().postNotificationName("InGamePLayerAdded", object: self, userInfo: ["player":player])
    }
    
    private func notifyOfPlayerRemoval(player: PlayerModel){
        NSNotificationCenter.defaultCenter().postNotificationName("InGamePLayerRemoved", object: self, userInfo: ["player":player])
    }
}