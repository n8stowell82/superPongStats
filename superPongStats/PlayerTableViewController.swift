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
    
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var players = [PlayerModel]()
//    var playersInGame = [PlayerModel]()
    
    var delegate: PLayerViewDelegate?
    
    var refresher:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refresher.addTarget(self, action: "retrieveTableData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            self.navigationItem.rightBarButtonItem = nil
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deselectPlayerFromGame:", name: "InGamePLayerRemoved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectPlayerForGame:", name: "InGamePLayerAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadPlayerData:", name: "PlayerDataRecieved", object: nil)
        
        retrieveTableData()
        
        //tableView setup
       
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = 50.0
        
        self.tableView.reloadData()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // Configure the cell
        cell.canAddPlayer = true
        cell.backgroundColor = colorForIndex(indexPath.row)
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.tintColor = UIColor.blackColor()
        cell.textLabel?.text = "#" + player.rank.description + " " + player.name
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        cell.delegate = self
        cell.player = player

        return cell
    }
    
    func retrieveTableData(){
        GamePlayersAPI.sharedInstance.getAllPlayersAsync()
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = players.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func loadPlayerData(notification: NSNotification){
        let userInfo = notification.userInfo as [String: AnyObject]
        players = userInfo["players"] as [PlayerModel]
        players.sort({ $0.rank < $1.rank })
        players.reverse()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func AddPlayerToGame(player: PlayerModel) {
        GamePlayersAPI.sharedInstance.addPlayerToGame(player)
        player.isInCurrentGame = true;
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        decoratePlayerAsSelected(player)
    }
    
    func RemovePlayerFromGame(player: PlayerModel) {
        //we never really need to delete a player from this list so we will just exit
        return
    }
    
    func deselectPlayerFromGame(notification: NSNotification){
        let userInfo = notification.userInfo as [String: AnyObject]
        var player = userInfo["player"] as PlayerModel?
        
        let index = (players as NSArray).indexOfObject(player!)
        if index == NSNotFound { return }
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPathForRow)
        cell?.accessoryType = UITableViewCellAccessoryType.DetailButton
        cell?.backgroundColor = colorForIndex(index)
        
    }
    
    func selectPlayerForGame(notification: NSNotification){
        let userInfo = notification.userInfo as [String: AnyObject]
        var player = userInfo["player"] as PlayerModel?
        decoratePlayerAsSelected(player!)
    }
    
    private func decoratePlayerAsSelected(player:PlayerModel){
        let index = (players as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPathForRow)
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
                playerDetailViewController.title = "Player Stats"
                playerDetailViewController.player = selectedPlayer
            }
        }
        
        if segue.identifier == "gameView"{
            
        }
    }
}
