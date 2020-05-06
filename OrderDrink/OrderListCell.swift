//
//  OrderDetailCell.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/30.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderDrink: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderTemp: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var orderSugar: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
