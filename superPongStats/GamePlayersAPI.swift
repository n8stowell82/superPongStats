//
//  GamePlayersAPI.swift
//  superPongStats
//
//  Created by Nathan Stowell on 12/28/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit
import Foundation

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
    
    func getAllPlayersAsync() -> Void{
        var players = [PlayerModel]()
        var playerData:NSData?
        
        if Reachability.isConnectedToNetwork()
        {
            DataManager.loadPlayerDataFromURL("players", completion: {(data,error) -> Void in
                if let tmpData = data{
                    players = self.populatePlayerDataFromJson(tmpData)
                    self.notifyOfPlayerDataRecieved(players)
                }
                })
        }else{
            DataManager.getPlayerDataFromFileWithSuccess{(data) -> Void in
                players = self.populatePlayerDataFromJson(data)
                self.notifyOfPlayerDataRecieved(players)
            }
        }
    }
    
    func savePlayerSlogan(playerModel:PlayerModel) -> Void{
        let path = "players/" + playerModel.id.description
        DataManager.postPlayerDataToURL(path, playerData: playerModel, completion: {(error) -> Void in
            println(error)
        })
    }
    
    func savePlayerToDB() -> Void{
        
    }
    
    private func populatePlayerDataFromJson(data:NSData) ->[PlayerModel]{
        var allPlayers = [PlayerModel]()
        let json = JSON(data: data)
        if let playerArray = json.arrayValue {
            
            for playerData in playerArray{
                let id: Int? = playerData["id"].integerValue
                let name: String? = playerData["name"].stringValue
                let slogan: String? = playerData["slogan"].stringValue
                let rank: Int? = (playerData["rank"].integerValue == 0) ? 100 : playerData["rank"].integerValue
                let wins: Int? = playerData["wins"].integerValue
                let totalGames: Int? = playerData["totalGames"].integerValue
                let mostKilled: String? = playerData["mostKilled"].stringValue
                let mostKilledBy: String? = playerData["mostKilledBy"].stringValue
                
                let player = PlayerModel(id: id, name: name, slogan: slogan, rank: rank, wins: wins, totalGames: totalGames, mostKilled: mostKilled, mostKilledBy: mostKilledBy)
                
                allPlayers.append(player)
            }
        }
        return allPlayers
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
    
    private func notifyOfPlayerDataRecieved(players: [PlayerModel]){
        NSNotificationCenter.defaultCenter().postNotificationName("PlayerDataRecieved", object: self, userInfo: ["players":players])
    }
}