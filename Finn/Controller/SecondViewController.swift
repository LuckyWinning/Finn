//
//  SecondViewController.swift
//  Finn
//
//  Created by Lucky on 2/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var bigImgView: UIImageView!
    @IBOutlet weak var secondPriceLabel: UILabel!
    
    var itemTwo: Item?
//    This is a the second view which set up a more individual ad view, with the potential to add more detail to the advertisement in the future, that is why it looks so empty
    override func viewDidLoad() {
        super.viewDidLoad()
        
//  I decided to check every information before unwrap them, because ad type and id are the only data that  could never be nil
        if itemTwo?.description != nil {
            secondNameLabel.text = itemTwo?.description
        } else {
            secondNameLabel.text = "Det er ingen beskrivelse"
        }
        if itemTwo?.price?.value != nil {
            secondPriceLabel.text = String(describing: itemTwo!.price!.value!) + ",-"
        } else {
            secondPriceLabel.text = "Ingen penger detaljert"
        }
//  This image is loaded from the Cache Object define in FinnCell, because is faster to load, that downloading the image everytime the user click the cell to access this view
        if cache.object(forKey: urlImg+itemTwo!.image!.url! as NSString) != nil {
            self.bigImgView.image = cache.object(forKey: urlImg+itemTwo!.image!.url! as NSString)!
        } else {
            self.bigImgView.image = UIImage(named: "Error.png")
        }
    }
}
