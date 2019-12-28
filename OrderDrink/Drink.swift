//
//  Drink.swift
//  OrderDrink
//
//  Created by  明智 on 2019/12/29.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation
//讀取木衛二與迷克夏的txt
struct DrinkList{
    var name: String
    var price: Int
}

struct Drink:Codable{
    var name: String?
    var drink: String?
    var price: String?
    var quantity: String?
    var percentSugar: String?
    var temp: String
    var size: String
}

struct DrinkData:Codable{
    var data: Drink
}
