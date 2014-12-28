//
//  PlayerTableViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/20/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit

//protocol PLayerViewDelegate{
//    func AddPlayersToGame(players: [PlayerModel])
//}

protocol PLayerViewDelegate {
    func AddNewPlayerToGame(player: PlayerModel)
}

class PlayerTableViewController: UITableViewController, TableViewCellDelegate {
    
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var players = [PlayerModel]()
    var playersInGame = [PlayerModel]()
    
    var delegate: PLayerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getPlayers()
        //tableView setup
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = 50.0
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getPlayers(){
        players = [PlayerModel]()
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
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.players.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableViewCell

        // Get the corresponding candy from our candies array
        let player = self.players[indexPath.row]
        cell.backgroundColor = colorForIndex(indexPath.row)
        
        // Configure the cell
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.tintColor = UIColor.blueColor()
        cell.textLabel?.text = player.name
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        cell.delegate = self
        cell.player = player

        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = players.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func AddPlayerToGame(player: PlayerModel) {
        let index = (players as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPathForRow)
        playersInGame.append(player)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        cell?.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("playerDetail", sender: tableView)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "playerDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow(){
                let selectedPlayer = players[indexPath.row]
                let playerDetailViewController = (segue.destinationViewController as UINavigationController).topViewController as PlayerDetailViewController
//                let playerDetailViewController = segue.destinationViewController as PlayerDetailViewController
                playerDetailViewController.title = selectedPlayer.name
                playerDetailViewController.player = selectedPlayer
            }
        }
    }
}
