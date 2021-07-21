//
//  ForgotPasswordVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/4/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate
{
     let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let lblForgotTitle = UILabel()
    let btnBack = UIButton()
    let btnSubmit = UIButton()
    let txtRegisterdEmail = UITextField()
    let txtRegisterPhnum = UITextField()

    override func viewDidLoad()
    {
        self.navigationController?.isNavigationBarHidden = true
          self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        
        lblForgotTitle.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: 40)
        lblForgotTitle.text = "Forgot Password"
        lblForgotTitle.textColor = UIColor.cyan
        lblForgotTitle.font = UIFont(name: "Helvetica Neue", size: 25)
        lblForgotTitle.textAlignment = .center
        self.view.addSubview(lblForgotTitle)
        
                btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
                let btnImgViewBack = UIImageView()
                btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 20, height: 30)
                btnImgViewBack.image = UIImage.init(named: "back.png")
                btnBack.addSubview(btnImgViewBack)
                
                btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
                btnBack.backgroundColor = UIColor.clear
        self.view.addSubview(btnBack)
        
         setUpTextField(txtField: txtRegisterdEmail, placeHolderText: "Registerd Email", yAxis: Int(constants.heighs-550), boardType: .emailAddress, capitalization: .none, imgeName: "User.png")
        self.view.addSubview(txtRegisterdEmail)
        
        setUpTextField(txtField: txtRegisterPhnum, placeHolderText: "Phone ( Optional )", yAxis: Int(constants.heighs-490), boardType: .emailAddress, capitalization: .none, imgeName: "User.png")
        txtRegisterPhnum.returnKeyType = .done
//        self.view.addSubview(txtRegisterPhnum)
        
        btnSubmit.frame = CGRect(x: 20, y: constants.heighs-300, width: constants.widths-40, height: 50)
        btnSubmit.setTitle("Submit", for: .normal)
        btnSubmit.setTitleColor(UIColor.init(red: 34.0/255, green: 152.0/255, blue: 193.0/255, alpha: 1), for: .normal)
        btnSubmit.layer.cornerRadius = 26
        btnSubmit.addTarget(self, action: #selector(btnSubmitClick), for: .touchUpInside)
        btnSubmit.backgroundColor = UIColor.white
        self.view.addSubview(btnSubmit)
        
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Button

    @objc func btnBackClicked()
    {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    @objc func btnSubmitClick()
    {
        if txtRegisterdEmail.text == ""
        {
            let alert = UIAlertController(title: "Breathing App", message: "Enter E mail", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                ACTION -> Void in
            })
            self.present(alert, animated: true, completion: nil)
            
        }
       else if (appDelegate?.checkForValidString(String: txtRegisterdEmail.text! as NSString).isEqual(to: "NA"))!
        {
            let alert = UIAlertController(title: "Breathing App", message: "Enter Valid E mail", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                ACTION -> Void in
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
  
    
    // MARK: - TextFiledMethod
    
    @objc func setUpTextField(txtField : UITextField , placeHolderText : String , yAxis : Int , boardType : UIKeyboardType , capitalization : UITextAutocapitalizationType ,imgeName : String)
    {
        txtField.frame = CGRect(x: 20, y: yAxis, width: Int((constants.widths)-40), height: 50)
        
        txtField.placeholder = placeHolderText
        txtField.textColor = UIColor.black
        txtField.font = UIFont(name: "Helvetica Neue", size: 15)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
         if  textField == txtRegisterdEmail
                   {
                      txtRegisterPhnum.becomeFirstResponder()
                   }
        else if textField == txtRegisterPhnum
         {
            txtRegisterPhnum.resignFirstResponder()
        }
        return true
    }
    
}
