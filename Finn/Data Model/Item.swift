//
//  Finn.swift
//  Finn
//
//  Created by Lucky on 2/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import Foundation
import UIKit

//  This model is define so when downloading the information from Json everything is well structure, it is also necessary if I want to use JSONDecoder()
class Items: Codable {
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

class Item: Codable {
    let image: Image?
    let score: String?
    let adtype: String
    let price: Price?
    let description: String?
    let location: String?
    let id: String
    var color: Bool?
    
    init(image: Image, score: String, adtype: String, price:Price, description: String, location: String, id:String) {
        self.image = image
        self.score = score
        self.adtype = adtype
        self.price = price
        self.description = description
        self.location = location
        self.id = id
    }
}

class Image: Codable {
    let url: String?
    
    init(url: String) {
        self.url = url
    }
}

class Price: Codable {
    let value: Int?
    
    init(value: Int) {
        self.value = value
    }
}


