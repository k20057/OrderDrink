//
//  OrderDetailVC.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/30.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {

    var order:Drink?
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var result: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let order = order{
            result.text = "訂購者:\(order.name!)\n\n飲料名稱：\(order.drink!)\n\n冰塊:\(order.temp!)\n\n甜度:\(order.sugar!)\n\n大小:\(order.size!)\n\n售價：\(order.price!)元\n\n訂購杯數:\(order.quantity!)杯"
            label.text = "總金額:\(order.price!*order.quantity!)元"
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
