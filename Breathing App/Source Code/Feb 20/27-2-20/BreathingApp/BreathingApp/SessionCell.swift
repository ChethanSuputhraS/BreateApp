//
//  SessionCell.swift
//  BreathingApp
//
//  Created by Ashwin on 1/31/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell
{
    let lblDate = UILabel()
    let lblTime = UILabel()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        lblDate.frame = CGRect(x: 10, y: 0, width: constants.widths, height: 50)
        lblDate.textColor = UIColor.white
        self.contentView.addSubview(lblDate)
        
        lblTime.frame = CGRect(x: constants.widths-100, y: 0, width: constants.widths-100, height: 50)
        lblTime.textColor = UIColor.white
        self.contentView.addSubview(lblTime)
        
        let lblBGLine = UILabel()
        lblBGLine.frame = CGRect(x: 0, y: 50, width: constants.widths-40, height: 10)
        lblBGLine.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
//        lblBGLine.backgroundColor = UIColor.clear
        lblBGLine.layer.cornerRadius = 26
        self.contentView.addSubview(lblBGLine)
        
        
        
        
        
        
        
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool)
      {
          super.setSelected(selected, animated: animated)
          
          // Configure the view for the selected state
      }
    
}
