//
//  FavoriteViewController.swift
//  Finn
//
//  Created by Lucky on 3/1/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController{
//  Similar to SecondView, this controller sets up a view of the selected favorites
    @IBOutlet weak var deleteAll: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    private var favoriteItem:[CoreItem]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteItem = getCoreData()

    }

    func getCoreData() -> [CoreItem] {
        return CoreDataHandler.fetchObject()!
    }
    
    func reloadedData() {
        favoriteItem = getCoreData()
        tableView.reloadData()
    }
    
    @IBAction func tapDeleteAll(_ sender: UIBarButtonItem) {
        if CoreDataHandler.cleanDelete() {
            reloadedData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
//  Because there are presented in a TableView, similar to the principal view, I use the cellForRoaAt and numberOfRows function, and for a more coherent code the cell is setup in the FavoriteCell.}}
//  Every data of the favorite view comes from the CoreData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favoriteItem?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favorite = favoriteItem![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteCell
        
        cell.setFavorite(favorite: favorite)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FavoriteViewController: FavoriteCellDelegate {
//  Because the user need to delete any element from the Favorite List, I added a button and that functionality
    func didTapDelete(core: CoreItem) {
        if CoreDataHandler.deleteObject(coreItem: core) {
            DispatchQueue.main.async {
                self.reloadedData()
            }
        }
    }
}
