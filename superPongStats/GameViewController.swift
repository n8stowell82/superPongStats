//
//  GameViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/23/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit
import QuartzCore

extension Array {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
    
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [T] {
        var list = self
        list.shuffle()
        return list
    }
}

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate{
    
    @IBOutlet weak var gamePlayersTable: UITableView!
    
    @IBOutlet weak var playerCountLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButtonHit(sender: UIButton) {
        handleStartHit()
    }
    
    let currentGame: GameModel!
    var playersInGame = [PlayerModel]()
    var playersKilled = [PlayerModel]()
    var gameInProgress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePlayerTable", name: "InGamePlayersUpdated", object: nil)
        
        //tableView setup
        var bg = UIImage(named: "spLogo.png")
        var bgImage:UIImageView = UIImageView(image: bg)
        bgImage.contentMode = .ScaleAspectFit
        bgImage.alpha = 0.2
        
        gamePlayersTable.dataSource = self
        gamePlayersTable.delegate = self
        gamePlayersTable.backgroundColor = UIColor.darkGrayColor()
        gamePlayersTable.backgroundView = bgImage
        gamePlayersTable.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        gamePlayersTable.separatorStyle = .None
        gamePlayersTable.rowHeight = 50.0
        
        updatePlayerTable()
        
        //start button setup
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderColor = UIColor(red: 0.98, green: 0.53, blue: 0.0, alpha: 1.0).CGColor
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlayerTable(){
        playersInGame = GamePlayersAPI.sharedInstance.getPlayersInGame()
        playerCountLabel.text = "Players In Game " + playersInGame.count.description
        gamePlayersTable.reloadData()
    }
    
    func RemovePlayerFromGame(player: PlayerModel) {
        if gameInProgress{
            handlePlayerOutOfGame(player)
        }
        GamePlayersAPI.sharedInstance.deletePlayer(player)
    }
    
    func handleStartHit(){
        if(!gameInProgress && playersInGame.count > 1){
            playersInGame.shuffle()
            gamePlayersTable.reloadData()
            self.startButton.setTitle("Started", forState: UIControlState.Normal)
            gameInProgress = true
        }
    }
    
    func handlePlayerOutOfGame(player:PlayerModel){
        let index = (playersInGame as NSArray).indexOfObject(player)
        if index == NSNotFound { return }
        player.isInCurrentGame = false
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        let cell = self.gamePlayersTable.cellForRowAtIndexPath(indexPathForRow)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        cell?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        cell?.textLabel?.textColor = UIColor.redColor()
        //notify of player out of game and update records to reflect that
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
        cell.canRemovePlayer = true
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.tintColor = UIColor.blackColor()
        cell.textLabel?.text = (indexPath.row + 1).description + ".  " + player.name
        cell.delegate = self
        cell.player = player
        
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let playerCount = playersInGame.count - 1
        if (playerCount > 0) {
            let val = (CGFloat(index) / CGFloat(playerCount)) * 0.4
            return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
        }else {
            return UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        }
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

}
