//
//  InfoViewController.swift
//  StretchSense Fabric App
//
//  Created by Jeremy Labrado on 17/05/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    /* Everything is in the Storyboard */
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        //print("viewDidLoad()")
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //scrollView.contentSize.height = 3000
    }

    override func didReceiveMemoryWarning() {
        //print("didReceiveMemoryWarning()")
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

}
