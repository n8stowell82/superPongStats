//
//  PlayerDetailViewController.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/21/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit


class PlayerDetailViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBAction func backToPlayersDetailViewController(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var visualEffectViewBackground: UIVisualEffectView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerSlogan: UILabel!
    
    @IBOutlet weak var newPlayerSlogan: UITextField!
    
    @IBOutlet weak var playerRankLabel: UILabel!
    
    @IBOutlet weak var playerWinsLabel: UILabel!
    
    @IBOutlet weak var playerLossesLabel: UILabel!
    
    @IBOutlet weak var addToGameButton: UIButton!
    
    @IBAction func addToGameAction(sender: AnyObject) {
        handleAddPlayerToGame()
    }
    
    var player:PlayerModel?
    
    let accentColor = UIColor(red: 0.98, green: 0.53, blue: 0.0, alpha: 1.0)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        recognizer.delegate = self
//        addGestureRecognizer(recognizer)
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        gestureRecognizer.delegate = self
        containerView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
        let total = self.player?.totalGames ?? -1
        let wins = self.player?.wins ?? 0
        let losses = -1 // abs( total - wins )
        let slogan = self.player?.slogan ?? ""
        
        let rank  = self.player?.rank.description ?? "0"
        
        playerNameLabel.text = self.player?.name ?? ""
        playerSlogan.text = "\"" + slogan + "\""
        playerRankLabel.text = "#" + rank
        playerWinsLabel.text = "wins: " + wins.description
        playerLossesLabel.text = "losses: " + losses.description
        
        self.addToGameButton.layer.borderWidth = 1
        self.addToGameButton.layer.cornerRadius = 5
        self.addToGameButton.layer.borderColor = accentColor.CGColor
//        self.addToGameButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        self.newPlayerSlogan.textColor = accentColor
        self.newPlayerSlogan.backgroundColor = UIColor.clearColor()
        self.newPlayerSlogan.layer.borderColor = accentColor.CGColor
        self.newPlayerSlogan.layer.borderWidth = 1
        self.newPlayerSlogan.layer.cornerRadius = 6
        self.newPlayerSlogan.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleAddPlayerToGame(){
        GamePlayersAPI.sharedInstance.addPlayerToGame(player!)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        player?.setSlogan(textField.text)
        GamePlayersAPI.sharedInstance.savePlayerSlogan(player!)
        playerSlogan.text = "\"" + textField.text + "\""
        textField.resignFirstResponder()
        textField.text = nil
        return true;
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended{
            newPlayerSlogan.resignFirstResponder()
            newPlayerSlogan.text = "Input New Slogan"
        }
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
