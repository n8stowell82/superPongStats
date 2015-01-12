//
//  playerGameViewController.swift
//  superPongStats
//
//  Created by Nathan Stowell on 1/9/15.
//  Copyright (c) 2015 OnePixelOff. All rights reserved.
//

import UIKit

class PlayerGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var playerGameTable: UITableView!
    
    var playerGames = [PlayerGameModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        playerGameTable.dataSource = self
        playerGameTable.delegate = self
        playerGameTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        playerGameTable.backgroundColor = UIColor.clearColor()
        playerGameTable.separatorStyle = .None
        playerGameTable.rowHeight = 50.0
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        playerGameTable.backgroundView = blurEffectView
        
        GamePlayersAPI.sharedInstance.loadAllGamesForPlayer(1, success:{ (data, error) -> Void in
            self.playerGames = data!
            
            self.playerGameTable.reloadData()
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerGames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let game = self.playerGames[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.tintColor = UIColor.blackColor()
        cell.textLabel?.text = (indexPath.row + 1).description + ".  " + game.gameId!.description
        
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let gameCount = playerGames.count - 1
        if (gameCount > 0) {
            let val = (CGFloat(index) / CGFloat(gameCount)) * 0.4
            return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
        }else {
            return UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        }
    }
    
    // Mark: - Table view delegate
    
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
}
