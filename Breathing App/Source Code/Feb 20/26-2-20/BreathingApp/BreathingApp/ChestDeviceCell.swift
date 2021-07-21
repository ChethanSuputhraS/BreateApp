//
//  ChestDeviceCell.swift
//  BreathingApp
//
//  Created by Ashwin on 2/3/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class ChestDeviceCell: UITableViewCell
{
    let lblAddres = UILabel()
    let lblName = UILabel()
    let lblPair = UILabel()
    let lblBack = UILabel()
    let btnChest = UIButton()
    let btnAbdomen = UIButton()
    var lblBorder = UILabel()
    var lblBorderAbdomen = UILabel()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
      {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
           // Initialization code
        
        let cellwidth = constants.widths - 10
        
        lblBack.frame = CGRect(x: 0, y: 5, width: cellwidth, height: 70)
        lblBack.backgroundColor = UIColor.init(red: 38.0/255, green: 92.0/255, blue: 127.0/255, alpha: 1)
        lblBack.alpha = 0.6
        self.contentView.addSubview(lblBack)
        
        lblName.frame = CGRect(x: 5, y: 10, width: constants.widths-10, height: 45)
        lblName.textColor = UIColor.white
        lblName.font = UIFont.systemFont(ofSize: 18)
        self.contentView.addSubview(lblName)
        
        lblAddres.frame = CGRect(x: 5, y: 50, width: constants.widths-10, height: 20)
        lblAddres.textColor = UIColor.gray
        lblAddres.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(lblAddres)
        
        lblPair.frame = CGRect(x: constants.widths-70, y: 0, width: 65, height: 60)
        lblPair.textColor = UIColor.init(red: 0/255.0, green: 219.0/255.0, blue: 67/255.0, alpha: 1)
        lblPair.font = UIFont.boldSystemFont(ofSize: 15)
        lblPair.text = "UNPAIR"
//        self.contentView.addSubview(lblPair)
        
        btnChest.frame = CGRect(x: constants.widths-180, y: 6, width: 60, height: 50)
        btnChest.backgroundColor = .clear
//        btnChest.addTarget(self, action: #selector(btnChestClick), for: .touchUpInside)
        btnChest.setTitle("Chest", for: .normal)
        btnChest.setTitleColor(.white, for: .normal)
  
        
        lblBorder = UILabel()
        lblBorder.frame = CGRect(x:  constants.widths-180, y: 15, width: 60, height: 33)
        lblBorder.layer.cornerRadius = 8
        lblBorder.layer.borderWidth = 1
        lblBorder.layer.borderColor = UIColor.init(red: 106.0/255, green: 227.0/255, blue: 255.0/255, alpha: 1).cgColor
        lblBorder.layer.masksToBounds = true
        self.contentView.addSubview(lblBorder)

        self.contentView.addSubview(btnChest)

        
        btnAbdomen.frame = CGRect(x: constants.widths-110, y: 6, width: 90, height: 50)
        btnAbdomen.backgroundColor = .clear
        btnAbdomen.setTitle("Abdomen", for: .normal)
        btnAbdomen.setTitleColor(.white, for: .normal)
//         btnAbdomen.addTarget(self, action: #selector(btnAbdomenClick), for: .touchUpInside)
        
        lblBorderAbdomen = UILabel()
        lblBorderAbdomen.frame = CGRect(x:  constants.widths-110, y: 15, width: 90, height: 33)
        lblBorderAbdomen.layer.cornerRadius = 8
        lblBorderAbdomen.layer.borderWidth = 1
        lblBorderAbdomen.layer.borderColor = UIColor.yellow.cgColor
        lblBorderAbdomen.layer.masksToBounds = true
        self.contentView.addSubview(lblBorderAbdomen)
    

        self.contentView.addSubview(btnAbdomen)
        
        
        

//        let lblBGLine = UILabel()
//        lblBGLine.frame = CGRect(x: 4, y: 59.5, width: constants.widths-13, height: 0.5)
//        lblBGLine.backgroundColor = UIColor.lightGray
//        self.contentView.addSubview(lblBGLine)
        
        
        
        
        
        print(self.contentView.frame.width)

    }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
   
}
