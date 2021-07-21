//
//  Stretch-Hero
//  GameViewController.swift
//
//  Created by Jeremy Labrado on 30/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        /* Set the scale mode to scale to fit the window */
        
        let scene = StretchHeroGameScene(size:CGSize(width: screenWidth, height: screenHeight))
        scene.scaleMode = .aspectFit
        scene.backgroundColor = UIColor.white
        
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
