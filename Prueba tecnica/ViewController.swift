//
//  ViewController.swift
//  Prueba tecnica
//
//  Created by César MS on 28/06/21.
//

import UIKit

class ItemsViewCell: UITableViewCell{
    
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var titleItem: UILabel!
    @IBOutlet weak var subtitleItem: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listItems: UITableView!
    
    var items = [Item?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        listItems.backgroundColor = .black
        listItems.delegate = self
        listItems.dataSource = self
        
        getItems()
    }
    
    func getItems(){
        
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, respone, error) in
            guard let data = data else { return }
            
            do {
                self.items = try JSONDecoder().decode([Item].self, from: data)
            } catch{
                print("ERROR", error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                print(self.items.count)
                self.listItems.reloadData()
            }
        }.resume()
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsViewCell
        let row = indexPath.row
        
        
        cell.titleItem.text = ("Breed: " + items[row]!.name)
        cell.subtitleItem.text = ("Origin: " + items[row]!.origin)
        
        cell.imageItem?.contentMode = .scaleToFill
        cell.backImage.contentMode = .scaleAspectFit
        cell.imageItem.clipsToBounds = true
        cell.imageItem.layer.cornerRadius = cell.imageItem.bounds.size.height / 2
        cell.backgroundColor = .black
        
        if (items[row]?.image?.url) != nil {
            let url = URL(string: (items[row]?.image?.url)!)!
            cell.backImage.downloaded(from: url)
            cell.imageItem.downloaded(from: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let senders = (items[row])
        self.performSegue(withIdentifier: "toItemsShow", sender: senders)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showItemsController = segue.destination as! ShowItemsController
        if let senders = sender as? (Item){
            showItemsController.item = senders
        }
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
