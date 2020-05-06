//
//  Drink.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/29.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation
//讀取木衛二與迷克夏的txt
struct DrinksList{
    var name: String
    var price: Int
}

struct Drink:Codable{
    var name: String?
    var drink: String?
    var price: Int?
    var quantity: Int?
    var sugar: String?
    var temp: String?
    var size: String?
    var total: Int?
    init?(dic: [String: Any]){
        name = dic["name"] as? String
        drink = dic["drink"] as? String
        price = dic["price"] as? Int
        quantity = dic["quantity"] as? Int
        sugar = dic["sugar"] as? String
        temp = dic["temp"] as? String
        size = dic["size"] as? String
        total = dic["total"] as? Int
    }
    
    
}

struct DrinkData:Codable{
    var data: Drink
}
