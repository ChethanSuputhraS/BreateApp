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
        self.view.addSubview(sessionView)
        
        let lblSession = UILabel()
        lblSession.frame = CGRect(x: 0, y: 25, width: constants.widths, height: 50)
        lblSession.text = "Session"
        lblSession.font = UIFont.boldSystemFont(ofSize: 20)
        lblSession.textAlignment = .center
        lblSession.textColor = UIColor.white
        sessionView.addSubview(lblSession)
        
        btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        btnBack.backgroundColor = UIColor.clear
        self.view.addSubview(btnBack)
        
        var  ya = CGFloat(70)
        if (constants.IS_IPHONE_X)
        {
            ya = ya + 10
        }
        
        tblViewSession.frame = CGRect(x:20, y: ya, width: constants.widths-40, height: constants.heighs)
        tblViewSession.register(SessionCell.self, forCellReuseIdentifier: "CellSession")
        tblViewSession.delegate = self
        tblViewSession.dataSource = self
        tblViewSession.separatorStyle = .none
        tblViewSession.backgroundColor = UIColor.clear
        sessionView.addSubview(tblViewSession)
        
        arraySessionTime = ["10:10","12:20","23:10","10:22","23:59","10:10","10:10","10:10"]
        arraySessionDate =  ["10-10-2020","20-01-2020","17-10-2020","17-10-2020","17-10-2020","17-10-2020","20-01-2020","20-01-2020"]
        
        var arryUserData = [String : String]()
        arryUserData = DataBaseController.shared.getTableReadingsFromDB()
        print(arryUserData["chest_name"] ?? "NA")
        //        var data = readDataFromCSV(fileName: "StretchSense_2020-02-24 15:46:28", fileType: "csv")
        //        data = cleanRows(file: data!)
        //        let csvRows = csv(data: data!)
        //        print(csvRows)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

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
    
    // MARK: - Reading CSV file
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
}
