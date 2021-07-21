//
//  LogInVC.swift
//  BreathingApp
//
//  Created by Ashwin on 1/30/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import Alamofire



struct constants
{
    static let widths = UIScreen .main.bounds.size.width
    static let heighs = UIScreen .main.bounds.size.height
}

class LogInVC: UIViewController,UITextFieldDelegate
{
    var arryUserData = [[String:String]]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var strToken : NSString = NSString()
    let signUpView = UIView()
    let LoginView = UIView()
    let lblLoginTitle = UILabel()
    let txtLogInUserName = UITextField()
    let txtLogInPassword = UITextField()
    let btnForgotPassWord = UIButton()
    let btnSignIn = UIButton()
    let btnSignUp = UIButton()
    let txtUserName = UITextField()
    let txtEmailSignUp = UITextField()
    let txtPasswordSignUp = UITextField()
    let txtConfirmPassword = UITextField()
    let lblSignUp = UILabel()
    let btnSubmit = UIButton()
    let btnHaveAccount = UIButton()
    var isRememberClick = false
    var isTAndCClicked = false
     let btnRemeberMe = UIButton()
    let btnTermsAdnCondition = UIButton()
    let lblIsActive = UILabel()
    let lblServerID = UILabel()
    
    
    override func viewDidLoad()
    {
        arryUserData = DataBaseController.shared.getTableUserDataFromDB()
          print(arryUserData)
        
        
          self.navigationController?.isNavigationBarHidden = true
        
        
        LoginView.frame = CGRect(x: 0, y: 0, width: constants.widths, height: constants.heighs)
        LoginView.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        self.view.addSubview(LoginView)
                
        lblLoginTitle.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
        lblLoginTitle.text = "Login"
        lblLoginTitle.textColor = UIColor.cyan
        lblLoginTitle.font = UIFont(name: "Helvetica Neue", size: 30)
        lblLoginTitle.textAlignment = .center
        LoginView.addSubview(lblLoginTitle)
        
        let lblBreathe = UILabel()
        lblBreathe.text = "Breathe \n  beta app"
        lblBreathe.textColor = UIColor.cyan
        lblBreathe.frame = CGRect(x: 0, y: constants.heighs-550, width: constants.widths, height: 100)
        lblBreathe.numberOfLines = 0
        lblBreathe.textAlignment = .center
        LoginView.addSubview(lblBreathe)
        
        
   
        setUpTextField(txtField: txtLogInUserName, placeHolderText: "Name", yAxis: Int(constants.heighs-450), boardType: .emailAddress, capitalization: .none, imgeName: "User2x.png")
       LoginView.addSubview(txtLogInUserName)
        
        setUpTextField(txtField: txtLogInPassword, placeHolderText: "Password", yAxis: Int(constants.heighs-380), boardType: .emailAddress, capitalization: .none, imgeName: "password.png")
        txtLogInPassword.isSecureTextEntry = true
        txtLogInPassword.returnKeyType = .done
        LoginView.addSubview(txtLogInPassword)
        
       
        btnRemeberMe.frame = CGRect(x: constants.widths-340, y: constants.heighs-320, width: 200, height: 50)
        btnRemeberMe.setTitle(" Remember me?", for: .normal)
        btnRemeberMe.setTitleColor(.white, for: .normal)
        btnRemeberMe.backgroundColor = UIColor.clear
        btnRemeberMe.setImage(UIImage.init(named: "boxuntik.png"), for: .normal)
        btnRemeberMe.addTarget(self, action: #selector(btnRemeberMeClicked), for: .touchUpInside)
        btnRemeberMe.contentHorizontalAlignment = .left
        LoginView.addSubview(btnRemeberMe)
        

        SetupButtons(btnAll: btnForgotPassWord, Yaxies: Int(constants.heighs-270), btnTitle: "Forgot Password ?")
        btnForgotPassWord.setTitleColor(UIColor.white, for: .normal)
                  btnForgotPassWord.addTarget(self, action: #selector(btnForGotPassClick), for: .touchUpInside)
        btnForgotPassWord.backgroundColor = UIColor.clear
        LoginView.addSubview(btnForgotPassWord)
        
        
        
        SetupButtons(btnAll: btnSignIn, Yaxies: Int(constants.heighs-200), btnTitle: "Sing In")
        btnSignIn.addTarget(self, action: #selector(btnSignInClick), for: .touchUpInside)
        LoginView.addSubview(btnSignIn)
        
        
        
        let lblDontHaveAccount = UILabel()
        lblDontHaveAccount.frame = CGRect(x: 0, y: constants.heighs-125, width: constants.widths, height: 50)
        lblDontHaveAccount.text = "Don't Have Account ?"
        lblDontHaveAccount.textColor = UIColor.white
        lblDontHaveAccount.textAlignment = .center
        LoginView.addSubview(lblDontHaveAccount)
        
        
        SetupButtons(btnAll: btnSignUp, Yaxies: Int(constants.heighs-80), btnTitle: "Sign up")
          btnSignUp.addTarget(self, action: #selector(btnSignUpClick), for: .touchUpInside)
        LoginView.addSubview(btnSignUp)
        
  //MARK: - Sign up View
        
        signUpView.frame = CGRect(x: 0, y: 0, width: constants.widths, height: constants.heighs)
        signUpView.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        signUpView.isHidden = true;
        self.view.addSubview(signUpView)
        
        lblSignUp.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
        lblSignUp.text = "Sign Up"
        lblSignUp.textColor = UIColor.cyan
        lblSignUp.font = UIFont(name: "Helvetica Neue", size: 30)
        lblSignUp.textAlignment = .center
        signUpView.addSubview(lblSignUp)
        
        
        
         setUpTextField(txtField: txtUserName, placeHolderText: "Name", yAxis: Int(constants.heighs-550), boardType: .emailAddress, capitalization: .none, imgeName: "User2x.png")
        txtUserName.returnKeyType = .next
        signUpView.addSubview(txtUserName)
        
         setUpTextField(txtField: txtEmailSignUp, placeHolderText: "E mail", yAxis: Int(constants.heighs-490), boardType: .emailAddress, capitalization: .none, imgeName: "User2x.png")
        txtEmailSignUp.returnKeyType = .next
        signUpView.addSubview(txtEmailSignUp)
        
         
         setUpTextField(txtField: txtPasswordSignUp, placeHolderText: "Password", yAxis: Int(constants.heighs-430), boardType: .emailAddress, capitalization: .none, imgeName: "password.png")
         txtPasswordSignUp.isSecureTextEntry = true
         txtPasswordSignUp.returnKeyType = .next
         signUpView.addSubview(txtPasswordSignUp)
        
        setUpTextField(txtField: txtConfirmPassword, placeHolderText: "Confirm Password", yAxis: Int(constants.heighs-370), boardType: .emailAddress, capitalization: .none, imgeName: "password.png")
        txtConfirmPassword.isSecureTextEntry = true
        txtConfirmPassword.returnKeyType = .done
        signUpView.addSubview(txtConfirmPassword)
        
        
        btnTermsAdnCondition.frame = CGRect(x: constants.widths-340, y: constants.heighs-320, width: constants.widths, height: 50)
        btnTermsAdnCondition.backgroundColor = UIColor.clear
        btnTermsAdnCondition.setTitleColor(.white, for: .normal)
        btnTermsAdnCondition.addTarget(self, action: #selector(btnTandCClick), for: .touchUpInside)
        btnTermsAdnCondition.setTitle(" I accespt Terms and Conditions", for: .normal)
        btnTermsAdnCondition.setImage(UIImage.init(named: "boxuntik.png"), for: .normal)
        btnTermsAdnCondition.contentHorizontalAlignment = .left
        signUpView.addSubview(btnTermsAdnCondition)
        
        
        
        
        SetupButtons(btnAll: btnSubmit, Yaxies: Int(constants.heighs-200), btnTitle: "Submit")
                       btnSubmit.addTarget(self, action: #selector(btnSubmitClick), for: .touchUpInside)
        signUpView.addSubview(btnSubmit)
        
        SetupButtons(btnAll: btnHaveAccount, Yaxies: Int(constants.heighs-100), btnTitle: "Have account? Sign in")
        btnHaveAccount.addTarget(self, action: #selector(btnHaveAccntClick), for: .touchUpInside)
        btnHaveAccount.setTitleColor(UIColor.white, for: .normal)
        btnHaveAccount.backgroundColor = UIColor.clear
        signUpView.addSubview(btnHaveAccount)
        
        
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     //    MARK: E mail validation
      func isValidEmail(enteredEmail:String) -> Bool
      {
    
          let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
          return emailPredicate.evaluate(with: enteredEmail)
      }
    
// MARK: - TextFiledMethod
    
    @objc func setUpTextField(txtField : UITextField , placeHolderText : String , yAxis : Int , boardType : UIKeyboardType , capitalization : UITextAutocapitalizationType ,imgeName : String)
    {
        txtField.frame = CGRect(x: 20, y: yAxis, width: Int((constants.widths)-40), height: 50)
        
        txtField.placeholder = placeHolderText
        txtField.textColor = UIColor.black
        txtField.font = UIFont(name: "Helvetica Neue", size: 18)
        txtField.keyboardType = boardType
        txtField.returnKeyType = .next
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = capitalization
        txtField.delegate = self
        txtField.textColor = UIColor.white
        txtField.textAlignment = .left
        txtField.layer.cornerRadius = 26;
        txtField.backgroundColor = UIColor.init(red: 10.0/255, green: 100.0/255, blue: 133.0/255, alpha: 1)
        txtField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.view.addSubview(txtField)
        
        let tmpView = UIView()
        tmpView.frame = CGRect(x: 0, y: 0, width: 50, height: 45)
        tmpView.backgroundColor = UIColor.clear
        txtField.leftView = tmpView
        txtField.leftViewMode = .always
        
        let imgIcons = UIImageView()
        imgIcons.frame = CGRect(x: 20, y: 13, width: 15, height: 15)
        imgIcons.image = UIImage.init(named: imgeName)
        tmpView.addSubview(imgIcons)
        
    }
 //MARK:- TextFiled Delegate
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {
           if  textField == txtLogInUserName
           {
              txtLogInPassword.becomeFirstResponder()
           
           }
        else if textField == txtLogInPassword
        {
            txtLogInPassword.resignFirstResponder()
   
        }
        else if  textField == txtUserName
              {
                  txtEmailSignUp.becomeFirstResponder()
              }
        else if textField == txtEmailSignUp
        {
            txtPasswordSignUp.becomeFirstResponder()
         
        }
        else if textField == txtPasswordSignUp
               {
                   txtConfirmPassword.becomeFirstResponder()

                   
               }
            else if textField == txtConfirmPassword
            {
                txtConfirmPassword.resignFirstResponder()
            }
            return true
        }
    
    
    
    
    // MARK: - Buttons
    @objc func SetupButtons(btnAll : UIButton,Yaxies : Int,btnTitle : String )
    {
        btnAll.frame = CGRect(x: 20, y: Yaxies, width: Int(constants.widths-40), height: 50)
        btnAll.backgroundColor = UIColor.white
        btnAll.setTitle(btnTitle, for: .normal)
        btnAll.layer.cornerRadius = 26
        btnAll.setTitleColor((UIColor.init(red: 34.0/255, green: 152.0/255, blue: 193.0/255, alpha: 1)), for: .normal)
    
    }
 
   @objc func btnSignInClick()
   {
        if (appDelegate?.checkForValidString(String: txtLogInUserName.text! as NSString).isEqual(to: "NA"))!
        {
            let alert = UIAlertController(title: "Breathimg APP", message: "Enter user Name or  E mail", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                ACTION -> Void in
            })
            self.present(alert, animated: true, completion: nil)

        }
            else if !(isValidEmail(enteredEmail: txtLogInUserName.text!)) == true
        {
            let alert = UIAlertController(title: "Breathimg APP", message: "Please enter valid email.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                ACTION -> Void in
            })
            self.present(alert, animated: true, completion: nil)

        }
        else if (appDelegate?.checkForValidString(String: txtLogInPassword.text! as NSString).isEqual(to: "NA"))!
        {
            let alert = UIAlertController(title: "Breathimg APP", message: "Enter Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                ACTION -> Void in
            })
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtLogInPassword.text?.count)! < 6
        {
            let alert = UIAlertController(title: "Breathimg APP", message: "Password should consist atleast 6 characters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var strToken : NSString = NSString()
            
        if (!(appDelegate?.checkForValidString(String : (appDelegate?.globalDeviceToken)!).isEqual(to: "NA"))!)
            {
                strToken = (appDelegate?.globalDeviceToken)!
            }
            else
            {
                strToken = "1234"
            }
            
            UserDefaults.standard.synchronize()
            
            Alamofire.request("http://vithamastech.com/track/mobile/login", method: .post, parameters: ["email": txtLogInUserName.text!,"password": txtLogInPassword.text!,"is_social_login": 0, "social_type": 0, "social_id": 0,"device_token": strToken,"device_type":"2"], encoding: JSONEncoding.default, headers: nil).responseJSON
                {
                    response in

                    switch response.result
                    {
                    case .success(let success):
                        print(success)


                        if let result = response.result.value
                        {
                            let responseDict = result as! [String : Any]
                            let dataDict = responseDict["data"] as! [String : Any]
                            print(dataDict)

                             let strMsG = responseDict["message"] ?? ""
                            if (strMsG as AnyObject).isEqual(to: "Email not verified!!, Plase verify your email address.")
                            {
                                let alert = UIAlertController(title: "Kuurv", message: "Please check your Email account and \"verify\" to log in.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                {
                                    ACTION -> Void in
                                })
                                self.present(alert, animated: true, completion: nil)
                            }
                           else if (strMsG as AnyObject).isEqual(to: "Invalid Credentials.")
                            {
                                let alert = UIAlertController(title: "Kuurv", message: " Wrong Password...!", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                {
                                    ACTION -> Void in
                                })
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if (strMsG as AnyObject).isEqual(to: "You are logged in successfully.")
                            {
                                let strUserID =  dataDict["id"] ?? ""
                                                          let strToken = responseDict["auth_token"] ?? ""
                                                          let strName = dataDict["name"] ?? ""
                                                          let strEmail = dataDict["email"] ?? ""
                                                          let strPassword = self.txtLogInPassword.text
                                                          
                                                          UserDefaults.standard.set(strUserID, forKey: "CURRENT_USER_ID")
                                                          UserDefaults.standard.set(strToken, forKey: "CURRENT_USER_ACCESS_TOKEN")
                                                          UserDefaults.standard.set(strName, forKey: "CURRENT_USER_NAME")
                                                          UserDefaults.standard.set(strEmail, forKey: "CURRENT_USER_EMAIL")
                                                          UserDefaults.standard.set(strPassword, forKey: "CURRENT_USER_PASSWORD")
                                                          UserDefaults.standard.set(true, forKey: "IS_LOGGED_IN")
                                
                                 UserDefaults.standard.synchronize()
                                
                                let alert = UIAlertController(title: "BreathingAPP", message: "you are Logged in successfully", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                {
                                    ACTION -> Void in

                                    // home vc
                                
                            let homevc = HomeVC()
                           self.navigationController?.pushViewController(homevc, animated: true)
                                    
                                    
                                })
                                self.present(alert, animated: true, completion: nil)
                        }

                    }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    @objc func btnSignUpClick()
      {
       UIView .transition(with: self.view, duration: 0.5, options: .transitionFlipFromRight, animations:
                  {
                  self.signUpView.isHidden = false
                         self.LoginView.isHidden = true
                             
                     }, completion: {( finished: Bool ) -> () in
              })
      
      }
     @objc func btnForGotPassClick()
     {
        let forGotPassVC = ForgotPasswordVC()
        self.navigationController?.pushViewController(forGotPassVC, animated: true)
        
    }
       
    @objc func btnSubmitClick()
    {
        
                if (appDelegate?.checkForValidString(String: txtUserName.text! as NSString).isEqual(to: "NA"))!
                {
                    let alert = UIAlertController(title: "Breathing App", message: "Enter Name", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                else if (appDelegate?.checkForValidString(String: txtEmailSignUp.text! as NSString).isEqual(to: "NA"))!
                {
                    let alert = UIAlertController(title: "Breathing App", message: "Enter E mail", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                    else if !(isValidEmail(enteredEmail: txtEmailSignUp.text!)) == true
                        {
                            let alert = UIAlertController(title: "Breathimg APP", message: "Please enter valid email.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                            {
                                ACTION -> Void in
                            })
                            self.present(alert, animated: true, completion: nil)

                        }
                else if (appDelegate?.checkForValidString(String: txtPasswordSignUp.text! as NSString).isEqual(to: "NA"))!
                {
                    let alert = UIAlertController(title: "Breathing App", message: "Enter Password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if (txtPasswordSignUp.text?.count)! < 6
                    {
                        let alert = UIAlertController(title: "Breathing App", message: "Password Conatins Minimum 6 Charaters", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        {
                            ACTION -> Void in
                            
                        })
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                else if (appDelegate?.checkForValidString(String: txtConfirmPassword.text! as NSString).isEqual(to: "NA"))!
                {
                    let alert = UIAlertController(title: "Breathing App", message: "Enter Confirm Password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                else if (!txtPasswordSignUp.text!.elementsEqual(txtConfirmPassword.text!))
                {
                    let alert = UIAlertController(title: "Breathing App", message: "Password And Confirm Password Must Match", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if isTAndCClicked == false
                {
                  let alert = UIAlertController(title: "Breathing App", message: "Please accept to Terms and Conditions", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        ACTION -> Void in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
               else
                   {
                
                       if (!(appDelegate?.checkForValidString(String : (appDelegate?.globalDeviceToken)!).isEqual(to: "NA"))!)
                       {
                           strToken = (appDelegate?.globalDeviceToken)!
                       }
                       else
                       {
                           strToken = "1234"
                       }
                       
                       Alamofire.request("http://vithamastech.com/track/mobile/sigup", method:.post, parameters: ["name": txtUserName.text!,"email": txtEmailSignUp.text!,"password": txtPasswordSignUp.text!,"is_social_login":0,"social_type":0 ,"social_id":0 ,"device_token":strToken,"device_type":"2"], encoding: JSONEncoding.default, headers: nil).responseJSON
                           { response in
                               
                               switch response.result
                               {
                               case .success(let success):
                                   print(success)
                                   // now writting
                                   if let result = response.result.value
                                   {
                                       let responseDict = result as! [String : Any]
                                       let dataDict = responseDict["data"] as! [String : Any]
                                       print(dataDict)
                                       
                                       let strMSG = responseDict["message"] ?? ""
                                       if (strMSG as AnyObject).isEqual(to: "Thanks! You have successfully signed up, We have sent you mail please verify your account.")
                                       {
                                let alert = UIAlertController(title: "Breathing App", message: "Registration successfull.\n please check your e mail  and Click on \"verify\" link inside.", preferredStyle: UIAlertController.Style.alert)
                                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                           {
                                               ACTION  in
               //                        })
                                               switch ACTION.style
                                               {
                                               case .default:
                                                   UIView.transition(with: self.LoginView, duration: 0.5, options: .transitionFlipFromLeft, animations:
                                                       {
                                                      self.txtLogInUserName.text = self.txtEmailSignUp.text
                                                     self.txtLogInPassword.text = self.txtPasswordSignUp.text
                                                        
                                                       self.signUpView.isHidden = true
                                                       self.LoginView.isHidden = false
        //                                               self.isBtnClikdedtikRememberTCp = false
                                                        self.txtUserName.text = ""
                                                        self.txtEmailSignUp.text = ""
                                                        self.txtPasswordSignUp.text = ""
                                                        self.txtConfirmPassword.text = ""
                                                        
                                                   }, completion: {( finished: Bool) -> () in
                                                       
                                                   })
                                               case .cancel: break
                                               case .destructive: break
                                                   
                                               }})
                                           self.present(alert, animated: true, completion: nil)
                                       }
                                       else if (strMSG as AnyObject).isEqual(to: "Thanks! You have successfully signed up")
                                       {
                                        let strUserID =  dataDict["id"] ?? ""
                                        let strToken = responseDict["auth_token"] ?? ""
                                        let strName = dataDict["name"] ?? ""
                                        let strEmail = dataDict["email"] ?? ""
                                        let strPassword = ""
                                        
                                        UserDefaults.standard.set(strUserID, forKey: "CURRENT_USER_ID")
                                        UserDefaults.standard.set(strToken, forKey: "CURRENT_USER_ACCESS_TOKEN")
                                        UserDefaults.standard.set(strName, forKey: "CURRENT_USER_NAME")
                                        UserDefaults.standard.set(strEmail, forKey: "CURRENT_USER_EMAIL")
                                        UserDefaults.standard.set(strPassword, forKey: "CURRENT_USER_PASSWORD")
                                        UserDefaults.standard.set(true, forKey: "IS_LOGGED_IN")
                                        
                                          UserDefaults.standard.synchronize()
                                        
                                           let homevc = HomeVC()
                                           self.navigationController?.pushViewController(homevc, animated: true)
                                           
                                       }
                                       else if (strMSG as AnyObject).isEqual(to: "user already registered with this email adddres.") || (strMSG as AnyObject).isEqual(to: "This email address already registered with us")
                                       {
                                           let alert = UIAlertController(title: "Breathing App", message: "This Email has already been registered with us", preferredStyle: UIAlertController.Style.alert)
                                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                           {
                                               ACTION -> Void in
                                           })
                                          self.present(alert, animated: true, completion: nil)
                                       }
                                       else if (strMSG as AnyObject).isEqual(to: "Thanks! You have successfully signed up")
                                       {
                                           let alert = UIAlertController(title: "Breathing App", message: "WellCome To Kuurv", preferredStyle: UIAlertController.Style.alert)
                                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                           {
                                               ACTION -> Void in
                                           })
                                           self.present(alert, animated: true, completion: nil)
                                       }
                                       else
                                       {
                                        let alert = UIAlertController(title: "Breathing App", message: "", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                                           {
                                               ACTION -> Void in
                                           })
                                           
                                           self.present(alert, animated: true, completion: nil)
                                       }
                                       
                                   }
                            case .failure(let error):
                                   print(error)
                               }
                       }
                      
            self.view.endEditing(true)
                    lblIsActive.text = "1"
                    lblServerID.text = "1"
                    
                            DataBaseController.shared.insertIntoTableuserDataDB(name: txtUserName.text! as NSString, email: txtEmailSignUp.text! as NSString, password: txtPasswordSignUp.text! as NSString, isActive: lblIsActive.text! as NSString, serverID: lblServerID.text! as NSString)
                                                   
                            arryUserData = DataBaseController.shared.getTableUserDataFromDB()
                   
               
               }
    }
   @objc func btnHaveAccntClick()
   {
    UIView.transition(with: self.view, duration: 0.5, options: .transitionFlipFromLeft, animations:
         {
         self.signUpView.isHidden = true
         self.LoginView.isHidden = false
             
     }, completion: {( finished: Bool ) -> () in
         
     })
    }
    @objc func btnRemeberMeClicked()
    {
        if isRememberClick == false
        {
           
            isRememberClick = true
           btnRemeberMe.setImage(UIImage.init(named: "boxtik.png"), for: .normal)//
            UserDefaults.standard.set(true, forKey: "isRememberClick")
        }
        else
        {
            
            isRememberClick = false
            btnRemeberMe.setImage(UIImage.init(named: "boxuntik.png"), for: .normal)
            UserDefaults.standard.set(false, forKey: "isRememberClick")
        }
        UserDefaults.standard.synchronize()
    }
    @objc func btnTandCClick()
    {
        if isTAndCClicked == false
        {
            isTAndCClicked = true
            btnTermsAdnCondition.setImage(UIImage.init(named: "boxtik.png"), for: .normal)
            
        }
        else
        {
            isTAndCClicked = false
             btnTermsAdnCondition.setImage(UIImage.init(named: "boxuntik.png"), for: .normal)
        }
        
        
    }
    
    
override func viewWillAppear(_ animated: Bool)
    {
        
            if (UserDefaults.standard.bool(forKey: "isRememberClick")) == true
            {
                let strEmail = UserDefaults.standard.string(forKey: "CURRENT_USER_EMAIL") ?? ""
                if !(appDelegate?.checkForValidString(String: strEmail as NSString).isEqual(to: "NA"))!
                {
                    isRememberClick = true
                  btnRemeberMe.setImage(UIImage.init(named: "boxtik.png"), for: .normal)
                    txtLogInUserName.text = UserDefaults.standard.string(forKey: "CURRENT_USER_EMAIL") ?? ""
                    txtLogInPassword.text = UserDefaults.standard.string(forKey: "CURRENT_USER_PASSWORD") ?? ""
                }
            }
        }
        

}
