//
//  SessionVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/7/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class SessionVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
   
    
   let sessionView = UIView()
    let btnBack = UIButton()
    let tblViewSession = UITableView()
    
    var arraySessionDate :  Array<Any> = []
      var arraySessionTime :  Array<Any> = []
    
    
    
    
    
    
    override func viewDidLoad()
    {
        self.navigationController?.isNavigationBarHidden = true
               self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        sessionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
         sessionView.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
//         sessionView.isHidden = true
         self.view.addSubview(sessionView)
        
        let lblSession = UILabel()
        lblSession.frame = CGRect(x: 0, y: 25, width: GlobalVariables.Device_Width, height: 50)
        lblSession.text = "Session"
        lblSession.font = UIFont.boldSystemFont(ofSize: 30)
        lblSession.textAlignment = .center
        lblSession.textColor = UIColor.white
        sessionView.addSubview(lblSession)
        
        btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
        let btnImgViewBack = UIImageView()
        btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 20, height: 30)
        btnImgViewBack.image = UIImage.init(named: "back.png")
        btnBack.addSubview(btnImgViewBack)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        btnBack.backgroundColor = UIColor.clear
        self.view.addSubview(btnBack)
        

                tblViewSession.frame = CGRect(x:20, y: GlobalVariables.Device_Height-550, width: GlobalVariables.Device_Width-40, height: GlobalVariables.Device_Height)
                tblViewSession.register(SessionCell.self, forCellReuseIdentifier: "CellSession")
                tblViewSession.delegate = self
                tblViewSession.dataSource = self
                tblViewSession.separatorStyle = .none
        //        tblViewSession.isScrollEnabled = false
                tblViewSession.backgroundColor = UIColor.clear
                sessionView.addSubview(tblViewSession)
        
        
          arraySessionTime = ["10:10","12:20","23:10","10:22","23:59","10:10","10:10","10:10"]
        arraySessionDate =  ["10-10-2020","20-01-2020","17-10-2020","17-10-2020","17-10-2020","17-10-2020","20-01-2020","20-01-2020"]
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

// MARK: - Navigation
    
@objc func btnBackClicked()
{
    
     UIView .transition(with: self.view, duration: 0.5, options: .transitionFlipFromRight, animations:
                {
                    self.navigationController?.popViewController(animated: true)
                    
                }, completion: {( finished: Bool ) -> () in
            })
    
    }
//MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arraySessionTime.count
//        return arraySessionDate.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
            if tableView == tblViewSession 
                  {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "CellSession", for: indexPath) as! SessionCell
                     
                      cell.lblDate.text = (arraySessionDate[indexPath.row]) as? String
                      cell.lblTime.text = (arraySessionTime[indexPath.row]) as? String
                      cell.selectionStyle = UITableViewCell.SelectionStyle.none
                      cell.layer.cornerRadius = 26
                    cell.backgroundColor = UIColor.init(red: 9.0/255, green: 100.0/255, blue: 133.0/255, alpha: 1)
                    
                      return cell
                  }
                  let tmpCell = UITableViewCell()
                  return tmpCell
       }
}
