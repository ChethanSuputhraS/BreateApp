//
//  PairChestVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/1/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import CoreBluetooth

class PairChestVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    let bodyBackView = UIView()
    let imgTick = UIImageView()
    let imgBodyView = UIImageView()
    let btnPairing = UIButton()
    var lblHintPair = UILabel()
    var backTblView = UIView()
    var lblNoDevices = UILabel()
    
    var tblBleDevices = UITableView()
    var arrayChestDevice : Array<Any> = []

    
    let btnBack = UIButton()
    let btnNext = UIButton()
    var isTblCliked = false
    
    override func viewDidLoad()
    {
        stretchsenseObject.startScanning()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 13.0/255, green: 42.0/255, blue: 67.0/255, alpha: 1)
        
        bodyBackView.frame = CGRect(x: 0, y: 0, width: GlobalVariables.Device_Width, height: GlobalVariables.Device_Height)
        self.view.addSubview(bodyBackView)
        
        btnBack.frame = CGRect(x: 0, y: 10, width: 50, height: 65)
        btnBack.setTitleColor(.white, for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        bodyBackView.addSubview(btnBack)
        
        let bodyView = UIView()
        bodyView.frame = CGRect(x: 28 * alSz, y: 70, width: self.view.frame.width-(28*alSz)*2, height: 300*alSz)
        bodyView.backgroundColor = UIColor.init(red: 25.0/255, green: 78.0/255, blue: 107.0/255, alpha: 1)
        bodyView.layer.cornerRadius = 10
        bodyView.layer.masksToBounds = false
        bodyView.layer.shadowColor = UIColor.init(red: 11.0/255, green: 34.0/255, blue: 52.0/255, alpha: 1).cgColor
        bodyView.layer.shadowOffset = CGSize(width: -1, height: 1)
        bodyView.layer.shadowOpacity = 0.5
        bodyView.layer.shadowPath = UIBezierPath(rect: bodyView.bounds).cgPath
        bodyBackView.addSubview(bodyView)

        lblHintPair.frame = CGRect(x: 0, y: 0, width: GlobalVariables.Device_Width-50, height: 50)
        lblHintPair.text = "Place Chest strap arround \n  chest at tip of sternum"
        lblHintPair.textAlignment = .center
        lblHintPair.textColor = UIColor.white
        lblHintPair.numberOfLines = 0
        lblHintPair.font = UIFont.systemFont(ofSize: 15)
        bodyView.addSubview(lblHintPair)

        imgBodyView.frame = CGRect(x: 40*alSz, y: (bodyView.frame.height-(180*alSz))/2, width: bodyView.frame.width-(40*alSz)*2, height: 180*alSz)
        imgBodyView.image = UIImage.init(named: "PairChest.png")
        bodyView.addSubview(imgBodyView)
        
        let lblChestPullStrap = UILabel()
        lblChestPullStrap.frame = CGRect(x: 0, y:bodyView.frame.height-40, width: GlobalVariables.Device_Width-50, height: 40)
        lblChestPullStrap.text = "Exhale and pull strap snug"
        lblChestPullStrap.textAlignment = .center
        lblChestPullStrap.textColor = UIColor.white
        lblChestPullStrap.numberOfLines = 0
        lblChestPullStrap.font = UIFont.systemFont(ofSize: 15)
        bodyView.addSubview(lblChestPullStrap)
        
        btnPairing.frame = CGRect(x: 50, y: GlobalVariables.Device_Height-150, width: GlobalVariables.Device_Width-100, height: 50)
        btnPairing.setTitle("Pair Chest Strap", for: .normal)
        btnPairing.setTitleColor(.white, for: .normal)
        btnPairing.addTarget(self, action: #selector(btnPairingClick), for: .touchUpInside)
        btnPairing.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btnPairing.layer.cornerRadius = 26
        btnPairing.backgroundColor = UIColor.init(red: 68.0/255, green: 97.0/255, blue: 114.0/255, alpha: 1)
        btnPairing.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bodyBackView.addSubview(btnPairing)
        
        btnPairing.layer.shadowColor = UIColor.init(red: 11.0/255, green: 34.0/255, blue: 52.0/255, alpha: 1).cgColor
        btnPairing.layer.shadowOffset = CGSize(width: -1, height: 1)
        btnPairing.layer.shadowOpacity = 0.3
        btnPairing.layer.shadowPath = UIBezierPath(rect: btnPairing.bounds).cgPath
        btnPairing.layer.masksToBounds = false
        
        btnNext.frame = CGRect(x: 20, y: GlobalVariables.Device_Height-50, width: GlobalVariables.Device_Width-40, height: 50)
        btnNext.setTitle("Next ->", for: .normal)
        btnNext.setTitleColor(.white, for: .normal)
        btnNext.addTarget(self, action: #selector(btnNextClick), for: .touchUpInside)
        btnNext.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        btnNext.isHidden = true
        bodyBackView.addSubview(btnNext)
        
        backTblView.frame = CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        backTblView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        backTblView.isHidden = true
        self.view.addSubview(backTblView)
        
        lblNoDevices.frame = CGRect (x: 20, y: (self.view.frame.height-100)/2, width: GlobalVariables.Device_Width-40, height: 100)
        lblNoDevices.text = "Searching for devices..."
        lblNoDevices.textColor = UIColor.white
        lblNoDevices.font = UIFont.boldSystemFont(ofSize: 20)
        lblNoDevices.isHidden = false
        lblNoDevices.textAlignment = .center
        lblNoDevices.layer.masksToBounds = true
        lblNoDevices.layer.cornerRadius = 10
        lblNoDevices.backgroundColor = UIColor.init(red: 13.0/255, green: 42.0/255, blue: 67.0/255, alpha: 0.8)
        backTblView.addSubview(lblNoDevices)

        tblBleDevices = UITableView(frame: CGRect(x: 5, y: 70, width: GlobalVariables.Device_Width-10, height: GlobalVariables.Device_Height-140), style: .plain)
        tblBleDevices.delegate = self
        tblBleDevices.dataSource = self
        tblBleDevices.backgroundColor = UIColor.clear
        tblBleDevices.register(ChestDeviceCell.self, forCellReuseIdentifier: "CellChestDevice")
        tblBleDevices.layer.masksToBounds = true
        tblBleDevices.layer.cornerRadius = 3
        tblBleDevices.isHidden = true
        backTblView.addSubview(tblBleDevices)
        
        let btnCancel : UIButton = UIButton()
        btnCancel.frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        btnCancel.setTitleColor(.white, for: .normal)
        btnCancel.addTarget(self, action: #selector(btnCancelClick), for: .touchUpInside)
        btnCancel.setImage(UIImage.init(named: "cancel.png"), for: .normal)
        backTblView.addSubview(btnCancel)

        let btnRefresh : UIButton = UIButton()
        btnRefresh.frame = CGRect(x: self.view.frame.width-65, y: 0, width: 65, height: 70)
        btnRefresh.setTitleColor(.white, for: .normal)
        btnRefresh.addTarget(self, action: #selector(btnRefrshClick), for: .touchUpInside)
        btnRefresh.setImage(UIImage.init(named: "refresh_white.png"), for: .normal)
        backTblView.addSubview(btnRefresh)
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: false)

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func newInfoDetected()
    {
        print("newInfoDetected()")
        print(stretchsenseObject.getLastInformation())
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update), userInfo: nil, repeats: false)
        let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        if listPeripheralsAvailable.count == 0
        {
            tblBleDevices.isHidden = true
            lblNoDevices.isHidden = false
        }
        else
        {
            tblBleDevices.isHidden = false
            lblNoDevices.isHidden = true
            tblBleDevices.reloadData()
        }
    }
    
    @objc func update()
    {
        tblBleDevices.reloadData()
    }

    @objc func btnPairingClick()
    {
        imgTick.isHidden = false
        btnBack.isHidden = true
        UIView.animate(withDuration: Double(0.5), animations:
            {
                self.backTblView.isHidden = false
//                self.tblBleDevices.frame = CGRect(x: 5, y: 50, width: GlobalVariables.Device_Width-10, height: GlobalVariables.Device_Height-110)
            })
    }
    @objc func btnBackClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnRefrshClick()
    {
        print("buttonScan()")
        stretchsenseObject.removeAll();
        stretchsenseObject.startScanning()
        tblBleDevices.reloadData()
    }
    @objc func btnCancelClick()
    {
        backTblView.isHidden = true
        btnBack.isHidden = false
        tblBleDevices.isHidden = false
    }
    @objc func btnNextClick()
    {
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView : UIView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        headerView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
//        headerView.backgroundColor = UIColor.white
        
        let lbltitle : UILabel = UILabel()
        lbltitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        lbltitle.text = "  Tap on Pair to connect device"
//        lbltitle.font = UIFont.systemFont(ofSize: 18)
        lbltitle.textColor = UIColor.black
        headerView.addSubview(lbltitle)
        let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        if listPeripheralsAvailable.count == 0
        {
            lbltitle.text = "  Searching for devices"
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblBleDevices
        {
            return 70
        }
        return 0
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
        if tableView == tblBleDevices
        {
            return stretchsenseObject.getNumberOfPeripheralAvailable()
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellChestDevice", for: indexPath) as! ChestDeviceCell
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        if listPeripheralsAvailable.count != 0
        {
            if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.connected
            {
                cell.lblPair.textColor = UIColor.init(red: 0/255.0, green: 219.0/255.0, blue: 67/255.0, alpha: 1)
            }
        }
        else if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.disconnected
        {
            cell.lblPair.textColor = UIColor.init(red: 255.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 1)
        }
        let strUUID : NSString = (listPeripheralsAvailable[(indexPath as NSIndexPath).row]!.identifier.uuidString as NSString)
        cell.lblAddres.text = "\(listPeripheralsAvailable[(indexPath as NSIndexPath).row]!.identifier.uuidString)"
        
        let strChestUUID: NSString = UserDefaults.standard.value(forKey: "ChestUUID") as? NSString ?? "NA"
        let strAbdUUID: NSString = UserDefaults.standard.value(forKey: "AbdomenUUID") as? NSString ?? "NA"

        cell.lblName.text = listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.name
        if strChestUUID == strUUID
        {
            cell.lblName.text = "Chest device"
        }
        else if strAbdUUID == strUUID
        {
            cell.lblName.text = "Abdomen device"
        }
        print("UUID Chest", strUUID, strChestUUID)
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblBleDevices
        {
            if indexPath.row == 0
            {
                if isTblCliked == false
                {
                    self.isTblCliked = true
                    tblBleDevices.frame = CGRect(x: 20, y: GlobalVariables.Device_Height, width: GlobalVariables.Device_Width-40, height: GlobalVariables.Device_Height)
                    self.PairChest()
//                    self.animationButtonChest()
                    btnNext.isHidden = false
                }
                else if isTblCliked == true
                {
                    self.isTblCliked = false
                    tblBleDevices.frame = CGRect(x: 20, y: GlobalVariables.Device_Height, width: GlobalVariables.Device_Width-40, height: GlobalVariables.Device_Height)
//                    self.PairAbdomen()
//                    self.animationAbdomen()
                }
            }
        }
    }
    
 func PairChest()
{
    btnPairing.isHidden = true
    btnBack.isHidden = true
    
   let btnBackAbdemen = UIButton()
    btnBackAbdemen.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
    btnBackAbdemen.setTitle("Back", for: .normal)
    btnBackAbdemen.addTarget(self, action: #selector(btnAbdemnBackClick), for: .touchUpInside)
    btnBackAbdemen.setTitleColor(.white, for: .normal)
    bodyBackView.addSubview(btnBackAbdemen)
   

    imgTick.frame = CGRect(x: GlobalVariables.Device_Width-140, y: GlobalVariables.Device_Height-150, width: 50, height: 50)
    imgTick.image = UIImage.init(named: "FinalTick.png")
    bodyBackView.addSubview(imgTick)
    
    }

    
//    func animationButtonChest()
//    {
//        animBtnView.frame = CGRect(x: 40, y: GlobalVariables.Device_Height-150, width: GlobalVariables.Device_Width-130, height: 50)
//            animBtnView.backgroundColor = UIColor.init(red: 85.0/255, green: 116.0/255, blue: 132.0/255, alpha: 1)
//            animBtnView.layer.cornerRadius = 26
//            bodyBackView.addSubview(animBtnView)
//
//            lblHintChest.frame = CGRect(x: 50, y: GlobalVariables.Device_Height-150, width: GlobalVariables.Device_Width-100, height: 50)
//            lblHintChest.textColor = UIColor.white
//            lblHintChest.text = "Pairing Chest Strap"
//        lblHintChest.font = UIFont.boldSystemFont(ofSize: 20)
//            bodyBackView.addSubview(lblHintChest)
//
//
//            animBtnView.transform = CGAffineTransform(translationX: 0, y: 0)
//                   UIView.animate(withDuration: Double(1.5), animations: {
//                       self.animBtnView.alpha = 0.0
//                       self.view.layoutIfNeeded()
//                   })
//
//
//    }
    
//    func animationAbdomen()
//    {
//        animBtnViewAbdomen.frame = CGRect(x: 40, y: GlobalVariables.Device_Height-150, width: GlobalVariables.Device_Width-130, height: 50)
//            animBtnViewAbdomen.backgroundColor = UIColor.init(red: 85.0/255, green: 116.0/255, blue: 132.0/255, alpha: 1)
//            animBtnViewAbdomen.layer.cornerRadius = 26
//            abdomenPairView.addSubview(animBtnViewAbdomen)
//
//            lblHintAbdomen.frame = CGRect(x: 50, y: GlobalVariables.Device_Height-150, width: GlobalVariables.Device_Width, height: 50)
//            lblHintAbdomen.textColor = UIColor.white
//            lblHintAbdomen.text = "Pairing Abdomen Strap"
//            lblHintAbdomen.font = UIFont.boldSystemFont(ofSize: 20)
//            abdomenPairView.addSubview(lblHintAbdomen)
//
//            animBtnViewAbdomen.transform = CGAffineTransform(translationX: 0, y: 0)
//                   UIView.animate(withDuration: Double(1.5), animations: {
//                       self.animBtnViewAbdomen.alpha = 0.0
//                       self.view.layoutIfNeeded()
//                   })
//
//
//    }
  //MARK: - Buttons in Abdemn view
    @objc func btnAbdemnBackClick()
    {
        btnPairing.isHidden = false
        imgTick.isHidden = true
    }
    
//    @objc func btnAbdomenBackClick()
//    {
//        bodyBackView.isHidden = false
//        abdomenPairView.isHidden = true
//        lblHintAbdomen.isHidden = true
//    }
//    @objc func btnPairingClick()
//    {
//        btnPairing.isHidden = true
//            tblBleDevices.frame = CGRect(x: 20, y: GlobalVariables.Device_Height-200, width: GlobalVariables.Device_Width-40, height: GlobalVariables.Device_Height)
//        abdomenPairView.addSubview(tblBleDevices)
//    }
}
