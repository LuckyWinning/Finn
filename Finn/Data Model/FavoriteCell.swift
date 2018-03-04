//
//  FavoriteCell.swift
//  Finn
//
//  Created by Lucky on 3/1/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate {
    func didTapDelete(core: CoreItem)
}

//  This is the set up file for the cells on the TableView on the FavoriteView, I only define the cells with the Image, name, prrice and location of the ad
class FavoriteCell: UITableViewCell {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoritePriceLabel: UILabel!
    @IBOutlet weak var favoriteLocationLabel: UILabel!
    
    var favoriteItem: CoreItem!
    var delegate: FavoriteCellDelegate?

    func setFavorite(favorite: CoreItem) {
        
        favoriteItem = favorite
        if favoriteItem.coreName != nil {
            favoriteNameLabel.text = favoriteItem.coreName
        } else {
            favoriteNameLabel.text = "Det er ingen beskrivelse"
        }
        if favoriteItem.corePrice != nil {
            favoritePriceLabel.text = String(describing: favoriteItem.corePrice!)
        } else {
            favoritePriceLabel.text = "Ikke spesifisert"
        }
        if favoriteItem.coreLocation != nil {
            favoriteLocationLabel.text = favoriteItem.coreLocation
        } else {
            favoriteLocationLabel.text = "Det er ikke lagt til plassering"
        }
        if favoriteItem.coreImg != nil {
            favoriteImage.image = UIImage(data:(favoriteItem.coreImg! as NSData) as Data)
        } else {
            favoriteImage.image = UIImage(named: "Error.png")
        }
    }
    @IBAction func tapFavoriteDelete(_ sender: UIButton) {
//  Because I decided to give the ability to delete one or all the favorites in the list, I needed to add the button and the function
        delegate?.didTapDelete(core: favoriteItem)
    }
    
}
