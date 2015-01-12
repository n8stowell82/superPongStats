//
//  GamePlayersAPI.swift
//  superPongStats
//
//  Created by Nathan Stowell on 12/28/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class GamePlayersAPI: NSObject {
    let baseAPIhost = "https://powerful-wildwood-4113.herokuapp.com/api/"
    
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
    
    func loadAllPlayers( success: (data:[PlayerModel]?, error:NSError?) -> Void){
        
        let URL = baseAPIhost + "Players"
        
        Alamofire.request(.GET, URL, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, data, error) -> Void in
            if error == nil
            {
                let players = self.populatePlayerDataFromJson(data!)
                success(data: players, error: error)
            }else{
                println(error)
            }
        }
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
    
    func savePlayerToDB() -> Void {
        
    }
    
    func savePlayerGame(path:String, playerData:PlayerModel, gameId:Int, position:Int, killerId:Int) -> Void {
        
        let parameters = [
            "playerid": playerData.id,
            "killerid": killerId,
            "gameid": gameId,
            "position": position
        ]
        
        Alamofire.request(.POST, baseAPIhost + path, parameters: parameters, encoding: .JSON)
            .response { (request, response, data, error) in
            println(request)
            println(response)
            println(error)
        }
    }
    
    func saveGame(path:String, title:String, winner:Int, active:Bool) -> Void {
        
        let parameters = [
            "title": title as NSString,
            "winner": winner,
            "active": active
        ]
        
        Alamofire.request(.POST, baseAPIhost + path, parameters: parameters, encoding: .JSON)
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func saveGameWithWinner(path:String, winner:Int)
    {
        
        let parameters = [
            "winner": winner as AnyObject,
            "active": false
        ]
        
        let url = baseAPIhost + "games?filter[where][active]=true&filter[limit]=1"
        
        Alamofire.request(.GET, url)
            .responseJSON { (request, response, jdata, error) -> Void in
                println(jdata)
            
                let jsonData = JSON(object: jdata!)
                if let data = jsonData.arrayValue {
                    let id = data[0]["id"].integerValue ?? -1
                
                    let putURL = self.baseAPIhost + path + "/" + id.description
                    Alamofire.request(.PUT, putURL, parameters: parameters, encoding: .JSON)
                        .response { (request, response, data, error) in
                            println(request)
                            println(response)
                            println(error)
                    }
                }
        }
    }
    
    func loadAllGamesForPlayer(playerId:Int, success: (data:[PlayerGameModel]?, error:NSError?) -> Void)
    {
        let url = baseAPIhost + "playergames?filter[where][playerid]=" + playerId.description
        
        Alamofire.request(.GET, url)
            .responseJSON { (request, response, jdata, error) -> Void in
                println(jdata)
                var games = [PlayerGameModel]()
                let jsonData = JSON(object: jdata!)
                if let data = jsonData.arrayValue {
                    for gameData in data{
                        let playerID: Int? = gameData["playerid"].integerValue ?? -1
                        let gameID: Int? = gameData["gameid"].integerValue ?? -1
                        let killerID: Int? = gameData["killerid"].integerValue ?? -1
                        let position: Int? = gameData["position"].integerValue ?? -1
                        let game = PlayerGameModel(playerid: playerID!, playerPosition: position!, gameid: gameID!, killerid: killerID!)
                        games.append(game)
                    }
                }
                success(data: games, error: error)
        }
        
    }
    
    private func populatePlayerDataFromJson(data:AnyObject) ->[PlayerModel]{
        var allPlayers = [PlayerModel]()
        let json = JSON(object: data)
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
    
    private func populatePlayerGamesDataFromJson(){
        
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