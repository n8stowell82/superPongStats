//
//  PlayerViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/19/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit

//protocol PLayerViewDelegate{
//    func AddPlayersToGame(players: [PlayerModel])
//}

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var playerTable: UITableView!
    
    var players = [PlayerModel]()
    var playersInGame = [PlayerModel]()
    
    override func viewWillAppear(animated: Bool) {
        //init the player array if empty
        if players.count == 0 {
            getPlayers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView setup
        playerTable.dataSource = self
        playerTable.delegate = self
        playerTable.backgroundColor = UIColor.blackColor()
        playerTable.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        playerTable.separatorStyle = .None
        playerTable.rowHeight = 50.0
        
        
        
        playerTable.reloadData()
    }
    
    func getPlayers(){
        DataManager.getPlayerDataFromFileWithSuccess{(data) -> Void in
            let json = JSON(data: data)
            if let playerArray = json["Players"].arrayValue {
                
                for playerData in playerArray{
                    var name: String? = playerData["Player"]["Name"].stringValue
                    var rank: Int? = playerData["Player"]["Rank"].integerValue
                    var wins: Int? = playerData["Player"]["Wins"].integerValue
                    var totalGames: Int? = playerData["Player"]["TotalGames"].integerValue
                    var MostKilled: String? = playerData["Player"]["MostKilled"].stringValue
                    var MostKilledBy: String? = playerData["Player"]["MostKilledBy"].stringValue
                    
                    var player = PlayerModel(name: name, rank: rank, wins: wins, totalGames: totalGames, MostKilled: MostKilled, MostKilledBy: MostKilledBy)
                    
                    self.players.append(player)
                }
                self.playerTable.reloadData()
            }
        }
    }
    
    
    // Mark: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableViewCell
        
        let player = self.players[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.tintColor = UIColor.blueColor()
        cell.textLabel?.text = player.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.delegate = self
        cell.player = player
        
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let playerCount = players.count - 1
        let val = (CGFloat(index) / CGFloat(playerCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func AddPlayerToGame(player: PlayerModel) {
        let index = (players as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = playerTable.cellForRowAtIndexPath(indexPathForRow)
        playersInGame.append(player)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        cell?.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    }
    
    // Mark: - Table view delegate
    
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("playerDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "playerDetail" {
            if let indexPath = self.playerTable.indexPathForSelectedRow(){
                let selectedPlayer = players[indexPath.row]
                let playerDetailViewController = (segue.destinationViewController as UINavigationController).topViewController as PlayerDetailViewController
                playerDetailViewController.title = selectedPlayer.name
                playerDetailViewController.player = selectedPlayer
            }
        }
    }
}

