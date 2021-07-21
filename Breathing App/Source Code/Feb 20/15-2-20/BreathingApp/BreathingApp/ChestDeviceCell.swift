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

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
      {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
           // Initialization code
        
        let cellwidth = GlobalVariables.Device_Width - 10
        
        lblBack.frame = CGRect(x: 0, y: 5, width: cellwidth, height: 60)
        lblBack.backgroundColor = UIColor.init(red: 38.0/255, green: 92.0/255, blue: 127.0/255, alpha: 1)
        lblBack.alpha = 0.6
        self.contentView.addSubview(lblBack)
        
        lblName.frame = CGRect(x: 5, y: 0, width: GlobalVariables.Device_Width-10, height: 45)
        lblName.textColor = UIColor.white
        lblName.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(lblName)
        
        lblAddres.frame = CGRect(x: 5, y: 35, width: GlobalVariables.Device_Width-10, height: 25)
        lblAddres.textColor = UIColor.gray
        lblAddres.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(lblAddres)
        
        lblPair.frame = CGRect(x: GlobalVariables.Device_Width-70, y: 0, width: 65, height: 60)
        lblPair.textColor = UIColor.init(red: 0/255.0, green: 219.0/255.0, blue: 67/255.0, alpha: 1)
        lblPair.font = UIFont.boldSystemFont(ofSize: 15)
        lblPair.text = "UNPAIR"
        self.contentView.addSubview(lblPair)

//        let lblBGLine = UILabel()
//        lblBGLine.frame = CGRect(x: 4, y: 59.5, width: GlobalVariables.Device_Width-13, height: 0.5)
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
