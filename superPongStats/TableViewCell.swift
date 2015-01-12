//
//  TableViewCell.swift
//  SuperPong
//
//  Created by Nathan Stowell on 12/21/14.
//  Copyright (c) 2014 OnePixelOff. All rights reserved.
//

import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    func AddPlayerToGame(player: PlayerModel)
    func RemovePlayerFromGame(player:PlayerModel)
}

class TableViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    
    var canAddPlayer:Bool = false
    var canRemovePlayer:Bool = false
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var addPlayerOnDragRelease = false
    
    var delegate: TableViewCellDelegate?
    var player: PlayerModel?
    
    var tickLabel: UILabel, crossLabel: UILabel
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.nullRect)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(32.0)
            label.backgroundColor = UIColor.clearColor()
            return label
        }
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .Right
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2715}"
        crossLabel.textAlignment = .Left
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(tickLabel)
        addSubview(crossLabel)
        
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
        
        
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
    }
    
    // utility method for creating the contextual cues
    func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(32.0)
        label.backgroundColor = UIColor.clearColor()
        return label
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = canRemovePlayer ? frame.origin.x < -frame.size.width / 3.2 : false
            addPlayerOnDragRelease = canAddPlayer ? frame.origin.x > frame.size.width / 2.0 : false
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = canAddPlayer ? cueAlpha : 0.0
            crossLabel.alpha = canRemovePlayer ? cueAlpha : 0.0
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = addPlayerOnDragRelease ? UIColor.greenColor() : UIColor.whiteColor()
            crossLabel.textColor = deleteOnDragRelease ? UIColor.redColor() : UIColor.whiteColor()
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            
            if addPlayerOnDragRelease{
                if delegate != nil && player != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.AddPlayerToGame(player!)
                }
            }else if deleteOnDragRelease{
                if delegate != nil && player != nil{
                    delegate!.RemovePlayerFromGame(player!)
                }
            }
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
