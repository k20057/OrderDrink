//
//  DrinkOrderTVC.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/29.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit
import Firebase

class OrderDrinkTVC: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDrink: UITextField!
    @IBOutlet weak var segmentSweet: UISegmentedControl!
    @IBOutlet weak var segmentTmp: UISegmentedControl!
    @IBOutlet weak var segmentSize: UISegmentedControl!
    @IBOutlet weak var lbQuantity: UILabel!
    @IBOutlet weak var LbTotal: UILabel!
    @IBOutlet weak var LbDetail: UILabel!
    
    var isEdit = false
    let drinkPicker = UIPickerView()
    var drinksData : [DrinksList] = []
    var drink:String?
    var order: Drink?
    var price:Int?
    var quantity = 0
    var sugar = "無糖"
    var temp = "正常"
    var size = "大杯"
    var iQun = 0
    var documentID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getDrink()
        if isEdit{
            getEditDrink()
        }
       
    }
    
    func getDrink(){
        //設定pickerView的toolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneBtn = UIBarButtonItem(title: "確認", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.done))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancel))
        let randomBtn = UIBarButtonItem(title: "隨機", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.random))
        toolBar.setItems([cancelBtn,space,randomBtn,space,doneBtn], animated: false)
        tfDrink.inputView = drinkPicker
        tfDrink.inputAccessoryView = toolBar
        drinkPicker.delegate = self
        drinkPicker.dataSource = self
        if let asset = NSDataAsset(name: "飲料"), let content = String(data: asset.data,encoding: .utf8){
            let Array = content.components(separatedBy: "\n")
            for number in 0 ..< Array.count {
                if number % 2 == 0 {
                    let name = Array[number]
                    if let price = Int(Array[number + 1]){
                        drinksData.append(DrinksList(name: name, price: price))
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinksData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinksData[row].name + " \(drinksData[row].price)元"
        //顯示文字在Picker上，titleForRow為現在要顯示的文字是在Picker上的第幾個，如果剛剛的numberOfComponents()有設定超過1的話，這邊的第三個參數component就可以用來判斷每個component要顯示的文字。
    }
    @objc func random(){
        let randomNum = Int.random(in: 0..<drinksData.count)
        tfDrink.text = drinksData[randomNum].name + " \(drinksData[randomNum].price)元"
        price = drinksData[randomNum].price
        drink = drinksData[randomNum].name
        sugarDetail()
        view.endEditing(true)
        show()
    }
    @objc func done(){
        let i = drinkPicker.selectedRow(inComponent: 0)
        price = drinksData[i].price
        drink = drinksData[i].name
        if size.elementsEqual("中杯") {
            price! -= 5
        }
        tfDrink.text = drinksData[i].name + " \(drinksData[i].price)元"
        sugarDetail()
        view.endEditing(true)
        show()
    }
    @objc func cancel(){
        view.endEditing(true)
    }
    
    @IBAction func btConfirm(_ sender: Any) {
        if isEdit{
            getEditOrder()
        }else{
            guard  let name = tfName.text, name.count > 0, let order = drink, order.count > 0, let total = LbTotal.text, total.count > 0
                else {
                    return showAlertMessage(title: "輸入錯誤", message: "未填寫完整")
            }
            let db = Firestore.firestore()
            let data: [String: Any] = ["name": name, "drink": order, "price": price!, "quantity": quantity, "size": size, "sugar": sugar, "temp": temp, "total": price!*quantity]
            db.collection("drinks").addDocument(data: data)
            let orderlist = self.storyboard?.instantiateViewController(identifier: "orderlistTVC") as! OrderListTVC
            self.navigationController?.pushViewController(orderlist, animated: true)
        }
    }
    
    @IBAction func segmentSweet(_ sender: UISegmentedControl) {
        sugarDetail()
        switch segmentSweet.selectedSegmentIndex{
        case 0:
            sugar = "半糖"
        case 1:
            sugar = "微糖"
        case 2:
            sugar = "少糖"
        case 3:
            sugar = "無糖"
        default:
            sugar = ""
        }
        show()
    }
    
    @IBAction func segmentTmp(_ sender: UISegmentedControl) {
        switch segmentTmp.selectedSegmentIndex{
        case 0:
            temp = "正常"
        case 1:
            temp = "少冰"
        case 2:
            temp = "微冰"
        case 3:
            temp = "去冰"
        default:
            temp = ""
        }
        show()
    }
    
    @IBAction func segmentSize(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            if size.elementsEqual("中杯") {
                price! += 5
            }
            size = "大杯"
        case 1:
            if size.elementsEqual("大杯") {
                price! -= 5
            }
            size = "中杯"
        default:
            size = ""
        }
        show()
    }
    
    @IBAction func lbQuantity(_ sender: UIStepper) {
        let num = Double(order?.quantity ?? 0)
        var correctionValue = 0.0
        if iQun == 0{
            if sender.value ==  2.0 {
                correctionValue = 1
            }
            if sender.value ==  0.0 {
                correctionValue = -1
            }
            sender.value = num + correctionValue
            iQun += 1
        }
        //        以上correctionValue修正值,是為了處理要修改飲料時,做stepper數量變更時,價格跟數量標示要一起動
        //        此時stepper最小值必須調到小於0,才能讓使用者一開始點減少就能成功,但後續要做檢查
        
        quantity = Int(sender.value)
        lbQuantity.text = "\(Int(sender.value))杯"
        show()
    }
    
    func sugarDetail(){
        if drink != nil{
            if drink!.contains("無糖"){
                sugar = "無糖"
                segmentSweet.selectedSegmentIndex = 3
                segmentSweet.setEnabled(false, forSegmentAt: 0)
                segmentSweet.setEnabled(false, forSegmentAt: 1)
                segmentSweet.setEnabled(false, forSegmentAt: 2)
                return
            }else{
                segmentSweet.setEnabled(true, forSegmentAt: 0)
                segmentSweet.setEnabled(true, forSegmentAt: 1)
                segmentSweet.setEnabled(true, forSegmentAt: 2)
                segmentSweet.setEnabled(true, forSegmentAt: 3)
            }
        }
    }
    
    func getEditDrink(){
        drink = order?.drink
        price = order?.price
        size = order!.size!
        sugar = order!.sugar!
        temp = order!.temp!
        title = "訂單修改"
        tfName.text = order?.name
        tfName.isUserInteractionEnabled = false
        tfName.textColor = UIColor.white
        tfName.backgroundColor = UIColor.gray
        var pricefix = price!
        if (size.contains("中杯")){
            pricefix += 5
        }
        tfDrink.text = order!.drink! + "\(pricefix)元"
        lbQuantity.text = "\(order!.quantity!)杯"
        quantity = order!.quantity!
        
        switch order?.sugar{
        case "半糖":
            segmentSweet.selectedSegmentIndex = 0
        case "微糖":
            segmentSweet.selectedSegmentIndex = 1
        case "少糖":
            segmentSweet.selectedSegmentIndex = 2
        case "無糖":
            segmentSweet.selectedSegmentIndex = 3
        default:
            print("甜度錯誤")
        }
        
        switch order?.temp{
        case "正常":
            segmentTmp.selectedSegmentIndex = 0
        case "少冰":
            segmentTmp.selectedSegmentIndex = 1
        case "微冰":
            segmentTmp.selectedSegmentIndex = 2
        case "去冰":
            segmentTmp.selectedSegmentIndex = 3
        default:
            print("溫度錯誤")
        }
        
        switch  order?.size {
        case "大杯":
            segmentSize.selectedSegmentIndex = 0
        case "中杯":
            segmentSize.selectedSegmentIndex = 1
        default:
            print("型號錯誤")
        }
        if (drink?.contains("無糖"))!{
            segmentSweet.selectedSegmentIndex = 3
            segmentSweet.setEnabled(false, forSegmentAt: 0)
            segmentSweet.setEnabled(false, forSegmentAt: 1)
            segmentSweet.setEnabled(false, forSegmentAt: 2)
        }
        show()
    }
    
    func getEditOrder(){
        let db = Firestore.firestore()
        let data: [String: Any] = ["name": tfName.text!, "drink": drink!, "price": price!, "quantity": quantity, "size": size, "sugar": sugar, "temp": temp, "total": price!*quantity]
        
        db.collection("drinks").document(documentID!).updateData(data)
        let orderlist = self.storyboard?.instantiateViewController(identifier: "orderlistTVC") as! OrderListTVC
        
        self.navigationController?.pushViewController(orderlist, animated: true)
    }
    
    func show(){
        if tfName.text != "" && tfDrink.text != nil && price != nil && quantity > 0 {
            LbTotal.text = "\(price! * quantity)元"
            LbDetail.text = "\(tfName.text!) 訂購 \(quantity)杯 \(size)\(drink!)\n甜度\(sugar) 冰塊\(temp)"
            
        }else{
            LbTotal.text = ""
            LbDetail.text = ""
        }
    }
    
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
}
