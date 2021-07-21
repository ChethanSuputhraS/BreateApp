//
//  HomeVC.swift
//  BreathingApp
//
//  Created by Ashwin on 1/30/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import Alamofire

var stretchsenseObject = StretchSenseAPI()

class HomeVC: UIViewController
{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let btnBackSession = UIButton()
    let btnRecord = UIButton()
    let btnSession = UIButton()
    let btnBackJane = UIButton()
    let btnProfile = UIButton()
    let recordView = UIView()
    let buttonViewBottom = UIView()
    let tblViewJaneMenu = UITableView()
 
    
    override func viewDidLoad()
    {
        stretchsenseObject.startBluetooth()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        
        buttonViewBottom.frame = CGRect(x: 0, y: self.view.frame.height-70, width: self.view.frame.width, height: 70)
        buttonViewBottom.backgroundColor = UIColor.clear
        self.view.addSubview(buttonViewBottom)
        
        let btnWidth = self.view.frame.width/3

        let imgViewRecord = UIImageView()
        imgViewRecord.frame = CGRect(x: (btnWidth-30)/2, y: 15, width: 30, height: 30)
        imgViewRecord.image = UIImage.init(named: "record.png")
        buttonViewBottom.addSubview(imgViewRecord)

        btnRecord.frame = CGRect(x: 0, y: 0, width: btnWidth, height: 70)
        btnRecord.backgroundColor = UIColor.clear
        btnRecord.setTitle("Record", for: .normal)
        btnRecord.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        btnRecord.addTarget(self, action: #selector(btnrecordClick), for: .touchUpInside)
        buttonViewBottom.addSubview(btnRecord)

        
        let imgViewSession = UIImageView()
        imgViewSession.frame = CGRect(x: btnWidth + ((btnWidth-30)/2), y: 10, width: 35, height: 35)
        imgViewSession.image = UIImage.init(named: "Session.png")
        buttonViewBottom.addSubview(imgViewSession)

        btnSession.frame = CGRect(x: btnWidth, y: 0, width: btnWidth, height: 70)
        btnSession.setTitle("Session", for: .normal)
        btnSession.backgroundColor = UIColor.clear
        btnSession.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        btnSession.addTarget(self, action: #selector(btnSessionClick), for: .touchUpInside)
        buttonViewBottom.addSubview(btnSession)

        
        let imgViewJane = UIImageView()
        imgViewJane.frame = CGRect(x: (btnWidth * 2) + ((btnWidth-30)/2), y: 10, width: 30, height: 35)
        imgViewJane.image = UIImage.init(named: "User.png")
        buttonViewBottom.addSubview(imgViewJane)

        btnProfile.frame = CGRect(x: btnWidth*2, y: 0, width: btnWidth, height: 70)
        btnProfile.setTitle("Profile", for: .normal)
        btnProfile.addTarget(self, action: #selector(btnProfileClick), for: .touchUpInside) 
        btnProfile.backgroundColor = UIColor.clear
        btnProfile.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        buttonViewBottom.addSubview(btnProfile)
        
        recordView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-70)
        recordView.backgroundColor = UIColor.clear
        recordView.isHidden = false
        self.view.addSubview(recordView)
        
        let lblAppName = UILabel()
        lblAppName.frame = CGRect(x: 0, y: 20, width: constants.widths, height: 50)
        lblAppName.text = "Breathing APP"
        lblAppName.textColor = UIColor.white
        lblAppName.font = UIFont.boldSystemFont(ofSize: 25)
        lblAppName.textAlignment = .center
        recordView.addSubview(lblAppName)
        
        
        let lblRecod = UILabel()
        lblRecod.frame = CGRect(x: 0, y: 300, width: constants.widths, height: 50)
        lblRecod.textAlignment = .center
        lblRecod.text = "Records"
        lblRecod.textColor = UIColor.white
        recordView.addSubview(lblRecod)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - All Buttons
    @objc func btnrecordClick()
    {
        /*let strid = "111"
        let strName : NSString = "KP"
        let strEmail : NSString = "k@mail.com"
        let strMob : NSString = "2323232"
        let update = "INSERT INTO UserData (serverID, name, email, password) VALUES ('\(strid)', '\(strName)', '\(strEmail)', '\(strMob)')"
        if DataBaseController.shared.execute(sqlStatement: update) == true
        {
            print("Success")
        }
        else
        {
            print("Error")
        }*/
        
        let popVc : PairChestVC = PairChestVC()
//        let navController = UINavigationController(rootViewController: popVc)
//        self.present(popVc, animated: true, completion: nil)
        self.navigationController?.pushViewController(popVc, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //print("adapatativePresentationStyle()")
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //print("popoverPresentationContrller()")
        viewWillAppear(true)
    }

    @objc func btnSessionClick()
    {
     UIView .transition(with: self.view, duration: 0.5, options: .transitionFlipFromRight, animations:
                {
                    let svc = SessionVC()
                    self.navigationController?.pushViewController(svc, animated: true)
             
                   }, completion: {( finished: Bool ) -> () in
            })
    
    }
    @objc func btnProfileClick()
    {
//          recordView.isHidden = true
       UIView .transition(with: self.view, duration: 0.5, options: .transitionFlipFromRight, animations:
                  {
                      let Pvc = ProfileVC()
                      self.navigationController?.pushViewController(Pvc, animated: true)
               
                     }, completion: {( finished: Bool ) -> () in
              })
      
      }


    
}
        
        
        

   

 
    
    
    
    
    

