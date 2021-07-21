//
//  NotificationVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/6/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController
{
    let lblNotification = UILabel()
    let btnBack = UIButton()
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        self.navigationController?.isToolbarHidden = true
        
        
        
        
        
        
        lblNotification.frame = CGRect(x: 0, y: 25, width: constants.widths, height: 50)
        lblNotification.text = "Notification"
        lblNotification.textColor = UIColor.white
        lblNotification.textAlignment = .center
        lblNotification.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(lblNotification)
        
                btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
                let btnImgViewBack = UIImageView()
                btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 20, height: 30)
                btnImgViewBack.image = UIImage.init(named: "back.png")
                btnBack.addSubview(btnImgViewBack)
                
                btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
                btnBack.backgroundColor = UIColor.clear
        self.view.addSubview(btnBack)
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - button
@objc func btnBackClicked()
    {
         self.navigationController?.popViewController(animated: true)
    }

  

}
