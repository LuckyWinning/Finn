//
//  Finn.swift
//  Finn
//
//  Created by Lucky on 2/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit

protocol ItemCellDelegate {
    func didTapFav(item: Item, row: Int)
}

let urlImg = "https://images.finncdn.no/dynamic/480x360c/"
let cache = NSCache<NSString, UIImage>()

//  This is the set up file for the cells on the TableView on the main View, I define the cells with an Image, name, prrice, location, adtype(important for the sort option) of the ad, and finally a button for addind an ad to the favorite list

class FinnCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var adtypeLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var finns: Item!
    var row: Int!
    var delegate: ItemCellDelegate?
    
    var imageUrlString:  String?
    func setFinn(finnsItem: Item, rowItem: Int) {
        
        row = rowItem
        finns = finnsItem
        
        if finnsItem.color == true {
            favoriteButton.backgroundColor = UIColor (red: 1.0, green: 0.15, blue: 0.0, alpha: 1.0)
        } else {
            favoriteButton.backgroundColor = UIColor (red: 0.0, green: 0.15, blue: 1.0, alpha: 1.0)
        }
        if finns.description != nil {
            nameLabel.text = finns.description!
        } else {
            nameLabel.text = "Det er ingen beskrivelse"
        }
        if finns.price?.value != nil {
            priceLabel.text = "kr " + String(describing: finns.price!.value!)
        } else {
            priceLabel.text = "Ikke spesifisert"
        }
        if finns.location != nil {
            locationLabel.text = finns.location!
        } else {
            locationLabel.text = "Det er ikke lagt til plassering"
        }
        adtypeLabel.text = finns.adtype
        
        if finns.image?.url != nil {
//  This function is can diferent, I verify if the image of the ad is downloaded and save. If it is alredy downloaded, I load that image from the NSCache Object, if not I decided to save the image in that previously mention NSCache.
// Every time I need to load that image for the SecondView, because this action always comes first, I look for the that image in the Cache Object. Not in favorite because the information is loaded from CoreData
//  This means that I only download the images one time, this is inorder to save internet data and also loading time
            let urlImgCont: String = urlImg+finns.image!.url!
            imageUrlString = urlImgCont
            imgView.image =  nil
            
            if let imageFromCache = cache.object(forKey: urlImgCont as NSString) {
                self.imgView.image = imageFromCache
                return
            }
            
            if let imageURL = URL(string: urlImgCont){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data{
                        let imageToCache =  UIImage(data :data)
                        if imageToCache !=  nil {
                            cache.setObject(imageToCache!, forKey: urlImgCont as NSString)
                        }
                        DispatchQueue.main.async {
                            if self.imageUrlString == urlImgCont {
                                self.imgView.image = imageToCache
                            }
                        }
                    }
                }
            }
        } else {
            self.imgView.image = UIImage(named: "Error.png")
        }
        cellView.backgroundColor = UIColor.init(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
    }
//  Because I needed the ability to save favorites in the list, I added the button and the function
    @IBAction func addFav(_ sender: UIButton) {
        delegate?.didTapFav(item: finns, row: row)
    }
}
