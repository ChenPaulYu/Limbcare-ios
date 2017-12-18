//
//  MenuTableViewCell.swift
//  LimbCare
//
//  Created by Bernie on 2017/6/28.
//  Copyright © 2017年 PaulChen. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!

    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
