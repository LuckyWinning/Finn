//
//  ViewController.swift
//  Finn
//
//  Created by Lucky on 2/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var optionButtons: [UIButton]!
    
    final let url = URL(string: "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json")
    private var finns = [Item]()
    private var originalFinns = [Item]()
    private var coreItem:[CoreItem]? = nil
//   the last variable is for the core data, the rest of the variables are essential for the download. finns is the array that the majority of the functions will use, originalFinns is the original copy of the data needed for the filters and sorts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        tableView.tableFooterView = UIView()
    }

    func download() {
        guard let downloadUrl = url else { return }
        
        URLSession.shared.dataTask(with: downloadUrl) { (data, resp, err) in
            guard let data = data, err == nil, resp != nil else {
                print("Somenthing is wrong")
                return }
            guard let dataAsString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "ad-type", with: "adtype") else {
                print("Somenthing is wrong in dataString")
                return }
            guard let dataAsData = dataAsString.data(using: String.Encoding.utf8) else {
                print("Somenthing is wrong in dataAsData")
                return }
//  I had problems with the "-" in ad-type, so I converted the data in string so a could change add-type for ad type and then I put all the information back into data so the JSONDecoder could convert in a class Item
            do
            {
                let decoder = JSONDecoder()
                let dowloadedItems = try decoder.decode(Items.self, from: dataAsData)
                self.finns = dowloadedItems.items
                self.originalFinns = self.finns
                self.finns.sort(by: { ($0.score ?? "z") > ($1.score ?? "z") })
//  When I saw "score" I thought that was a parameter that evaluates how good an ad is, so I decided to order the ads in that manner
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonErr {
                print("Something wrong after download", jsonErr)
            }
        }.resume()
    }
// all this oncoming code is for the arrange of buttons that function like a menu
    @IBAction func handleSelection(_ sender: UIButton) {
        animation()
    }
    @IBAction func favView(_ sender: UIButton) {
        animation()
    }
    
    enum Options: String {
        case realestate = "Filter by Realestate"
        case job = "Filter by Job"
        case car = "Filter by Car"
        case book = "Filter by Books"
        case priceUp = "Sort by price -"
        case priceDown = "Sort by price +"
        case home = "Home"
    }
//  this enum is used so the convection of name is persistent in the switch case
    func animation() {
        optionButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
// I created this animation for a more smooth menu transition
    
    @IBAction func optionTap(_ sender: UIButton) {
        guard let title = sender.currentTitle, let option = Options(rawValue: title) else {
            return
        }
        
        switch option {
        case .home:
            self.finns = self.originalFinns.sorted(by: { ($0.score ?? "z") > ($1.score ?? "z") })
        case .priceUp:
            self.finns = self.originalFinns.sorted(by: { ($0.price?.value ?? 0) < ($1.price?.value ?? 0) })
        case .priceDown:
            self.finns = self.originalFinns.sorted(by: { ($0.price?.value ?? 0) > ($1.price?.value ?? 0) })
        case .book:
            self.finns = self.originalFinns.filter { $0.adtype == "BAP"}
        case .realestate:
            self.finns = self.originalFinns.filter { $0.adtype == "REALESTATE"}
        case .car:
            self.finns = self.originalFinns.filter { $0.adtype == "CAR"}
        case .job:
            self.finns = self.originalFinns.filter { $0.adtype == "JOB"}
        }
// the majority of the options in the menu are for a soothing view, I thought this feature is a normal situation in commercial applications
        
        tableView.reloadData()
        animation()
    }
    func verifyColor() {
        coreItem = CoreDataHandler.fetchObject()
        var itIsTrue: [String] = []
        for i in coreItem! {
            itIsTrue.append(i.coreId!)
        }
        if !itIsTrue.isEmpty {
            for j in finns {
                if itIsTrue.contains(j.id) {
                    j.color = true
                } else {
                    j.color = false
                }
            }
        } else {
            for j in finns {
                j.color = false
            }
        }
    }
//  this function verifies the correct color of the favorite button, invokes the core data in order to show the correct status of ad "the ad is save or no?," I decided to go core data for the performance
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
//  As you can see I went with a TableView with the cells you could click for more information, even though the second view of the ad do not have more details, I imagine there are more parameters in a real ad that could better presented in a separate view. I also decided to configure the class Item in the FinnnCell.swift for a more comprehensible view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        verifyColor()
        let finn = finns[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinnCell") as? FinnCell else { return UITableViewCell() }
        
        cell.setFinn(finnsItem: finn, rowItem: indexPath.row)
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SecondViewController{
            destination.itemTwo = finns[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

extension ViewController: ItemCellDelegate {
//  this function invokes the core data function for saving data of every element that the user decided to favorite 
    func didTapFav(item: Item, row: Int) {
        let name, price, location: String
        let imgData:NSData
        let urlImgCont: String = urlImg+item.image!.url!
        
        if cache.object(forKey: urlImgCont as NSString) != nil {
            imgData = UIImagePNGRepresentation(cache.object(forKey: urlImgCont as NSString)!)! as NSData
        } else {
            imgData = UIImagePNGRepresentation(UIImage(named: "Error.png")!)! as NSData
        }
        if item.description != nil {
            name = item.description!
        } else {
            name = "Det er ingen beskrivelse"
        }
        if item.price?.value != nil {
            price = "kr " + String(describing: item.price!.value!)
        } else {
            price = "Ikke spesifisert"
        }
        if item.location != nil {
            location = item.location!
        } else {
            location = "Det er ikke lagt til plassering"
        }
        
        coreItem = CoreDataHandler.fetchObject()
        var message: String = " "
        var flag = 0
        var j = 0
        for i in coreItem! {
            if i.coreId! == item.id {
                if CoreDataHandler.deleteObject(coreItem: coreItem![j]) {
                    tableView.reloadData()
                    flag = 1
                    message = "Earase from favorite"
                }
            }
            j = j+1
        }
        
        if flag == 0 {
            if CoreDataHandler.saveObject(coreName: name, coreLocation: location, corePrice: price, coreImg: imgData, coreId: item.id) {
                tableView.reloadData()
                message = "Added to favorite"
            }
        }
        
        let alertTitle = "Favorite"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
//      I added this message so the client could know when a ad was been save and when deleted
    }
}


