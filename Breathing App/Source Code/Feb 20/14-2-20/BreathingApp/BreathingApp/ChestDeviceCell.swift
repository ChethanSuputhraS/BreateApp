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

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
      {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
           // Initialization code
        
        lblAddres.frame = CGRect(x: 5, y: 0, width: GlobalVariables.Device_Width-10, height: 45)
        lblAddres.textColor = UIColor.white
        lblAddres.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(lblAddres)
        
        lblName.frame = CGRect(x: 5, y: 35, width: GlobalVariables.Device_Width-10, height: 20)
        lblName.textColor = UIColor.gray
        lblName.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(lblName)
        
        lblPair.frame = CGRect(x: self.contentView.frame.width-40, y: 0, width: 50, height: 60)
        lblPair.textColor = UIColor.init(red: 0/255.0, green: 219.0/255.0, blue: 67/255.0, alpha: 1)
        lblPair.font = UIFont.boldSystemFont(ofSize: 15)
        lblPair.text = "PAIR"
        self.contentView.addSubview(lblPair)

        let lblBGLine = UILabel()
        lblBGLine.frame = CGRect(x: 0, y: 54.5, width: GlobalVariables.Device_Width-40, height: 0.5)
        lblBGLine.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(lblBGLine)

    }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
