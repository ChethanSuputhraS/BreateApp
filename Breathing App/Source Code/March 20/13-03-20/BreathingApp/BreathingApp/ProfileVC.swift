//
//  ProfileVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/7/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let profileView = UIView()
    let btnBack = UIButton()
    let tblMenu = UITableView()
    var arrayMenu :  Array<Any> = []
    let imgViewProfileDp = UIImageView()
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad()
    {
        
        self.navigationController?.isNavigationBarHidden = true
               self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        
            profileView.frame = CGRect(x: 0, y: 0, width: constants.widths, height: constants.heighs)
            profileView.backgroundColor = UIColor.clear
            self.view.addSubview(profileView)
        
        let btnPath = UIButton()
        btnPath.frame = CGRect(x: constants.widths-60, y: 25, width: 50, height: 50)
        btnPath.backgroundColor = UIColor.clear
        btnPath.addTarget(self, action: #selector(btnPathClick), for: .touchUpInside)
        let btnImgPath = UIImageView()
        btnImgPath.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        btnImgPath.image = UIImage.init(named: "Settings.png")
        btnPath.addSubview(btnImgPath)
        profileView.addSubview(btnPath)
        
        btnBack.frame = CGRect(x: 10, y: 25, width: 44, height: 50)
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        btnBack.backgroundColor = UIColor.clear
        self.view.addSubview(btnBack)
        
        var yMenu = CGFloat(261)
        if (constants.IS_IPHONE_X)
        {
            yMenu = yMenu + 10
        }
        
        tblMenu.frame = CGRect(x:20, y: yMenu, width: constants.widths-40, height: constants.heighs)
                  tblMenu.register(JaneMenuCell.self, forCellReuseIdentifier: "CellJane")
                  tblMenu.delegate = self
                  tblMenu.dataSource = self
                  tblMenu.separatorStyle = .none
                  tblMenu.isScrollEnabled = false
                  tblMenu.backgroundColor = UIColor.clear
                  profileView.addSubview(tblMenu)
        
        var hPr = CGFloat(80)
        if (constants.IS_IPHONE_X)
        {
            hPr = hPr + 10
        }
   
        imgViewProfileDp.frame = CGRect(x:120, y: hPr, width: constants.widths-250, height: constants.widths-250)
        imgViewProfileDp.backgroundColor = UIColor.clear
        imgViewProfileDp.image = UIImage.init(named: "userProPic.png")
        imgViewProfileDp.layer.cornerRadius = (constants.widths-250)/2
          imgViewProfileDp.clipsToBounds = true
        profileView.addSubview(imgViewProfileDp)
        
        var hPrBtn = CGFloat(80)
        if (constants.IS_IPHONE_X)
        {
            hPrBtn = hPrBtn + 10
        }
        
        
                let btnDp = UIButton()
                btnDp.frame = CGRect(x: 120, y: hPrBtn, width: constants.widths-250, height: constants.widths-250)
                btnDp.layer.cornerRadius = (constants.widths-250)/2
                btnDp.addTarget(self, action: #selector(btnDpClick), for: .touchUpInside)
                btnDp.backgroundColor = UIColor.clear
                profileView.addSubview(btnDp)
        

        
        
                arrayMenu = ["Account","Notifications","Apple Health","Support","Terms & Conditions","Privacy","Logout"]
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation
@objc func btnPathClick()
{
    
    }
    @objc func btnBackClicked()
    {
    
     UIView .transition(with: self.view, duration: 0.5, options: .transitionFlipFromRight, animations:
                {
                    self.navigationController?.popViewController(animated: true)
                    
                }, completion: {( finished: Bool ) -> () in
            })
    
    }
    
 @objc func btnDpClick()
    {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            //            self.getImage(fromSourcetype: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            //            self.getImage(fromSourcetype: .photoLibrary)
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
            {
                self.imagePickerController.delegate = self 
                self.imagePickerController.sourceType = .savedPhotosAlbum
                self.present(self.imagePickerController, animated: true, completion: nil)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
            {
                self.dismiss(animated: true, completion: ({
                    () -> Void in
                    self.imgViewProfileDp.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        
                }))
        
            }
       
//MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 59
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       if tableView == tblMenu
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellJane", for: indexPath) as! JaneMenuCell
           
            cell.lblMenuLable.text = (arrayMenu[indexPath.row]) as? String
            cell.backgroundColor = UIColor.init(red: 9.0/255, green: 100.0/255, blue: 133.0/255, alpha: 1)
            cell.imgViewArrow.image = UIImage.init(named: "arrow.png")
           
            
            
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        let tmpCell = UITableViewCell()
        return tmpCell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblMenu
        {
            if indexPath.row == 0
            {
                let AcVC = AccountVC()
                self.navigationController?.pushViewController(AcVC, animated: true)
                
            }
            if indexPath.row == 1
                      {
                        let NfVC = NotificationVC()
                       self.navigationController?.pushViewController(NfVC, animated: true)
                        
                          
                      }
            if indexPath.row == 2
                      {
                        let AppleHVC = NotificationVC()
                        self.navigationController?.pushViewController(AppleHVC, animated: true)
                          
                      }
            if indexPath.row == 3
                      {
                        let SuprtVC = SupportVC()
                        self.navigationController?.pushViewController(SuprtVC, animated: true)
                          
                      }
            if indexPath.row == 4
                      {
                        let tANDc = TermsANDConditionVC()
                        self.navigationController?.pushViewController(tANDc, animated: true)
                          
                      }
            if indexPath.row == 5
                      {
                        let privacyVC = PrivacyVC()
                        self.navigationController?.pushViewController(privacyVC, animated: true)
                          
                      }
            if indexPath.row == 6
            {
                let alert = UIAlertController(title: "Breathing App", message: "Are you Sure logout ?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler:
                    {
                      action in
                    switch action.style
                    {
                    case .default: break
                    case .cancel: break
                    case .destructive:
                    ACProgressHUD.shared.hideHUD()
                    let progressView = ACProgressHUD.shared
                    progressView.progressText = "Loading..."
                    progressView.showHUD()
                    var strToken : NSString = NSString()
                    if (!(self.self.appDelegate?.checkForValidString(String: (self.appDelegate?.globalDeviceToken)!).isEqual(to: "NA"))!)
                          {
                      strToken = (self.appDelegate?.globalDeviceToken)!
                     }
                     else
                  {
                   strToken = "1234"
                    }
                    let strUserID = UserDefaults.standard.string(forKey: "CURRENT_USER_ID") ?? "id"
                    let strCurrentToken = UserDefaults.standard.string(forKey: "CURRENT_USER_ACCESS_TOKEN")  ?? "auth_token"
                    let parameters : Parameters = ["user_id": strUserID,"token":strCurrentToken]
                    
                    Alamofire.request("http://vithamastech.com/track/mobile/logout",method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["token":String(format: "%@",strCurrentToken)]).responseJSON
                         {
                            response in
                            ACProgressHUD.shared.hideHUD()
                            switch response.result
                        {
                             case .success:
                        if let result = response.result.value
                                                    {
                        let responseDict = result as! [String : Any]
                        let dataDict1 = responseDict["data"] as! [String : Any]
                        print(dataDict1)
                        let strMsg   = responseDict["message"] ?? ""
                        print("messsssssssaggggee on weeeb seerrviceee is %@",strMsg)
                        if (strMsg as AnyObject).isEqual(to: "You are loged out successfully.")
                  {
                    UserDefaults.standard.set(false, forKey: "IS_LOGGED_IN")
                    UserDefaults.standard.removeObject(forKey: "CURRENT_USER_ID")
                    UserDefaults.standard.removeObject(forKey: "CURRENT_USER_ACCESS_TOKEN")
                    UserDefaults.standard.synchronize()
//                    log in Vc
                    
                    let view1 : LogInVC = LogInVC()
                    self.navigationController?.pushViewController(view1, animated: true)
                    }
                        else
                       {
                            let alert = UIAlertController(title: "Breathing App", message:strMsg as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                                }
                            }
                        case .failure(let error):
                        print(error)
                    let alert = UIAlertController(title: "Breathing App", message:error as? String, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                    }
                        }
                }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
  
            }
        }
     
    }
}
    

