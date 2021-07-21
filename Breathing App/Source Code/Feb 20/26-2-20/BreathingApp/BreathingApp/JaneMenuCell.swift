//
//  JaneMenuCell.swift
//  BreathingApp
//
//  Created by Ashwin on 2/1/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class JaneMenuCell: UITableViewCell
{
    let lblMenuLable = UILabel()
   let lblLine = UILabel()
    let imgViewArrow = UIImageView()
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         // Initialization code
    
        
        lblMenuLable.frame = CGRect(x: 10, y: 0, width: constants.widths, height: 50)
        lblMenuLable.textColor = UIColor.white
        self.contentView.addSubview(lblMenuLable)
        
        lblLine.frame = CGRect(x: 0, y: 51, width: constants.widths, height: 2)
        lblLine.backgroundColor =  UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        self.contentView.addSubview(lblLine)
        
        imgViewArrow.frame = CGRect(x: constants.widths-90, y: 5, width: 20, height: 27)
        imgViewArrow.backgroundColor = UIColor.clear
        self.contentView.addSubview(imgViewArrow)
        
        
    
    
    
        }
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
