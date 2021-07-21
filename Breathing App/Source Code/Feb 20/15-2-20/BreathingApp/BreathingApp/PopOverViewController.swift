//
//  PopOverViewController.swift
//
//  Created by Kalpesh Panchasara on 12/02/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import CoreBluetooth

class PopOverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var LabelInfo: UILabel = UILabel()
    var tblView: UITableView = UITableView()
    var btnRefresh : UIButton = UIButton()
    
    
    override func viewDidLoad() {
        print("viewDidLoad()")
        super.viewDidLoad()
        
        stretchsenseObject.startScanning()
        
        self.view.backgroundColor = UIColor.white
        
        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 0, y: 0, width: GlobalVariables.Device_Width, height: 60)
        lblTitle.text = "Devices"
        lblTitle.font = UIFont.boldSystemFont(ofSize: 30)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.white
        self.view.addSubview(lblTitle)

        let btnImgViewBack = UIImageView()
        btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 30, height: 30)
        btnImgViewBack.image = UIImage.init(named: "refresh_white.png")
        self.view.addSubview(btnImgViewBack)

        btnRefresh.frame = CGRect(x: 10, y: 0, width: 60, height: 60)
        btnRefresh.addTarget(self, action: #selector(btnRefreshClicked), for: .touchUpInside)
        btnRefresh.backgroundColor = UIColor.clear
        self.view.addSubview(btnRefresh)

        tblView.frame = CGRect(x:20, y: 60, width: self.view.frame.width, height: self.view.frame.height-60)
        tblView.register(SessionCell.self, forCellReuseIdentifier: "CellSession")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.backgroundColor = UIColor.clear
        self.view.addSubview(tblView)
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(PopOverViewController.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        tblView.reloadData()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillDisappear()")
        tblView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        parent?.viewWillAppear(true)
        viewWillAppear(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        parent?.viewWillAppear(true)
        viewWillAppear(true)
        presentedViewController?.viewWillAppear(true)
    }
    
    @objc func btnRefreshClicked()
    {
        
    }
    @objc func newInfoDetected() {
        print("newInfoDetected()")
        LabelInfo.text = stretchsenseObject.getLastInformation()
        print(stretchsenseObject.getLastInformation())
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)
        tblView.reloadData()
    }
    
    @objc func update() {
        tblView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stretchsenseObject.getNumberOfPeripheralAvailable()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        let listperipheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if listPeripheralsAvailable.count != 0
        {
            if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.connected
            {
                cell.backgroundColor = UIColor.green
            }
        }
        else if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.disconnected
        {
                cell.backgroundColor = UIColor.lightGray
        }
        cell.textLabel?.text = "\(listPeripheralsAvailable[(indexPath as NSIndexPath).row]!.identifier.uuidString)"
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.connected{
            let refreshAlert = UIAlertController(title: "Disconnect", message: "Are you sure you want to disconnect the peripheral? ", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                stretchsenseObject.disconnectOnePeripheralWithUUID(cell!.textLabel!.text!)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        else if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.disconnected{
            if (indexPath as NSIndexPath).row <= listPeripheralsAvailable.count{
                    stretchsenseObject.connectToPeripheralWithUUID(cell!.textLabel!.text!)
                if (UserDefaults.standard.value(forKey: "ChestUUID") == nil)
                {
                    print("Chest Not available")
                    UserDefaults.standard.set(cell!.textLabel!.text!, forKey: "ChestUUID")
                }
                else if (UserDefaults.standard.value(forKey: "AbdomenUUID") == nil)
                {
                    print("Abdomen available")
                    UserDefaults.standard.set(cell!.textLabel!.text!, forKey: "AbdomenUUID")
                }
                UserDefaults.standard.synchronize()
            }
        }
    }
    

    @IBAction func buttonScan(_ sender: AnyObject) {
        print("buttonScan()")
        stretchsenseObject.removeAll();
        stretchsenseObject.startScanning()
        tblView.reloadData()
    }

    @IBAction func buttonDisconnectAllSensors(_ sender: AnyObject) {
        print("buttonDisconnectAllSensors()")
        if stretchsenseObject.getNumberOfPeripheralAvailable() != 0 {
            stretchsenseObject.disconnectAllPeripheral()
            stretchsenseObject = StretchSenseAPI()
            stretchsenseObject.startBluetooth()
        }
    }
}
