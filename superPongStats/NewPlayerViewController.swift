//
//  NewPlayerViewController.swift
//  superPongStats
//
//  Created by Nathan Stowell on 1/12/15.
//  Copyright (c) 2015 OnePixelOff. All rights reserved.
//

import UIKit

class NewPlayerViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    
    @IBOutlet weak var playerSloganTextField: UITextField!
    
    @IBAction func saveButtonHit(sender: AnyObject) {
        handleSaveButtonHit()
    }
    
    let accentColor = UIColor(red: 0.98, green: 0.53, blue: 0.0, alpha: 1.0)
    
    var newPlayer:PlayerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, atIndex: 0)
        
        self.playerNameTextField.textColor = accentColor
        self.playerNameTextField.backgroundColor = UIColor.clearColor()
        self.playerNameTextField.layer.borderColor = accentColor.CGColor
        self.playerNameTextField.layer.borderWidth = 1
        self.playerNameTextField.layer.cornerRadius = 6
        self.playerNameTextField.layer.masksToBounds = true
        
        self.playerSloganTextField.textColor = accentColor
        self.playerSloganTextField.backgroundColor = UIColor.clearColor()
        self.playerSloganTextField.layer.borderColor = accentColor.CGColor
        self.playerSloganTextField.layer.borderWidth = 1
        self.playerSloganTextField.layer.cornerRadius = 6
        self.playerSloganTextField.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        
        textField.resignFirstResponder()
        return true;
    }
    
    func handleSaveButtonHit(){
        GamePlayersAPI.sharedInstance.saveNewPlayerToDB(newPlayer!)
    }
}
