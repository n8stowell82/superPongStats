//
//  GameViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/23/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var gamePlayersTable: UITableView!
    
    var playersInGame = [PlayerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tableView setup
        gamePlayersTable.dataSource = self
        gamePlayersTable.delegate = self
        gamePlayersTable.backgroundColor = UIColor.blackColor()
        gamePlayersTable.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        gamePlayersTable.separatorStyle = .None
        gamePlayersTable.rowHeight = 50.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Mark: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersInGame.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableViewCell
        
        let player = self.playersInGame[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.tintColor = UIColor.blueColor()
        cell.textLabel?.text = player.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.delegate = self
//        cell.player = player
        
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let playerCount = playersInGame.count - 1
        let val = (CGFloat(index) / CGFloat(playerCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func AddPlayerToGame(player: PlayerModel) {
        let index = (playersInGame as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = gamePlayersTable.cellForRowAtIndexPath(indexPathForRow)
        playersInGame.append(player)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        cell?.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    }
    
    // Mark: - Table view delegate
    
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gameDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "gameDetail" {
            if let indexPath = self.gamePlayersTable.indexPathForSelectedRow(){
                let selectedPlayer = playersInGame[indexPath.row]
                let playerDetailViewController = (segue.destinationViewController as UINavigationController).topViewController as PlayerDetailViewController
                playerDetailViewController.title = selectedPlayer.name
                playerDetailViewController.player = selectedPlayer
            }
        }
    }

}
