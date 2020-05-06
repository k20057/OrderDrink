//
//  OrderSearchTVC.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/29.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit
import Firebase
class OrderListTVC: UITableViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var orders = [Drink]()
    var documentID = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAllDrink()
    }
    
    @objc func showAllDrink(){
        let db = Firestore.firestore()
        self.documentID.removeAll()
        self.orders.removeAll()
        db.collection("drinks").getDocuments{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents{
                    let drink = Drink(dic: document.data())
                    self.documentID.append(document.documentID)
                    self.orders.append(drink!)
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                    }
                }
                self.tableView.reloadData()
            }
            self.loading.stopAnimating()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var order: Drink
        order = orders[indexPath.row]
        let cellId = "orderlistcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderListCell
        cell.orderName.text = "訂購者:"+order.name!
        cell.orderTemp.text = "冰塊:"+order.temp!
        cell.orderDrink.text = "飲料名稱:"+order.drink!
        cell.orderSugar.text = "甜度:"+order.sugar!
        cell.orderQuantity.text = "數量:\(order.quantity!)"
        cell.orderTotal.text = "總金額:\(order.price!*order.quantity!)元"
        return cell
    }
    
    //左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath:IndexPath) -> UISwipeActionsConfiguration?{
        // 左滑時顯示Edit按鈕
        let edit = UIContextualAction(style: .normal, title: "修改", handler: { (action, view, bool) in
            let orderdrinkTVC = self.storyboard?.instantiateViewController(withIdentifier: "orderdrinkTVC") as! OrderDrinkTVC
            let order = self.orders[indexPath.row]
            orderdrinkTVC.order = order
            orderdrinkTVC.isEdit = true
            orderdrinkTVC.documentID = self.documentID[indexPath.row]
            self.navigationController?.pushViewController(orderdrinkTVC, animated: true)
        })
        edit.backgroundColor = .gray
        edit.image = UIImage(named: "edit")
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "刪除", handler: { (action, view, bool) in
            let db = Firestore.firestore()
            db.collection("drinks").document(self.documentID[indexPath.row]).delete()
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
          
        })
        delete.backgroundColor = .red
        delete.image = UIImage(named: "delete")
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetail"{
            let indexPath = self.tableView.indexPathForSelectedRow
            let order = orders[indexPath!.row]
            let detailVC = segue.destination as! OrderDetailVC
            detailVC.order = order
        }
    }
    
    
}
