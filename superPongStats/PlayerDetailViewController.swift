//
//  PlayerDetailViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/21/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit


class PlayerDetailViewController: UIViewController {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerRankLabel: UILabel!
    
    @IBOutlet weak var playerWinsLabel: UILabel!
    
    @IBOutlet weak var playerLossesLabel: UILabel!
    
    @IBOutlet weak var addToGameButton: UIButton!
    
    @IBAction func addToGameAction(sender: AnyObject) {
        handleAddPlayerToGame()
    }
    
    var player:PlayerModel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let total = self.player?.totalGames ?? 0
        let wins = self.player?.wins ?? 0
        let losses = abs( total - wins )
        
        let rank  = self.player?.rank.description ?? "0"
        
        playerNameLabel.text = self.player?.name ?? ""
        playerRankLabel.text = "#" + rank
        playerWinsLabel.text = "wins: " + wins.description
        playerLossesLabel.text = "losses: " + losses.description
        
        self.addToGameButton.layer.borderWidth = 1
        self.addToGameButton.layer.cornerRadius = 5
        self.addToGameButton.layer.borderColor = UIColor(red: 0.98, green: 0.53, blue: 0.0, alpha: 1.0).CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleAddPlayerToGame(){
        GamePlayersAPI.sharedInstance.addPlayerToGame(player!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
