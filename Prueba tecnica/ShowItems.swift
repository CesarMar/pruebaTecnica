//
//  ShowItems.swift
//  Prueba tecnica
//
//  Created by César MS on 28/06/21.
//

import UIKit

class AttributesCarousel: UICollectionViewCell {
    
    @IBOutlet weak var nameAttributes: UILabel!
    @IBOutlet weak var progressAtributtes: UIProgressView!
    @IBOutlet weak var widthLabel: NSLayoutConstraint!
    @IBOutlet weak var widthProgress: NSLayoutConstraint!
    
}

class ShowItemsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleItem: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var descriptionItem: UILabel!
    @IBOutlet weak var collectionAttributes: UICollectionView!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    
    var item: Item!
    
    var attributes = ["affectionLevel", "childFriendly", "dogFriendly", "energyLevel", "intelligence"]
    var valuesAttributes = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleItem.text = item.name
        self.descriptionItem.text = item.description
        valuesAttributes.append(Float(item.affectionLevel) * 0.2)
        valuesAttributes.append(Float(item.childFriendly) * 0.2)
        valuesAttributes.append(Float(item.dogFriendly) * 0.2)
        valuesAttributes.append(Float(item.energyLevel) * 0.2)
        valuesAttributes.append(Float(item.intelligence) * 0.2)
        self.temperamentLabel.text = "Temperament: " + item.temperament
        self.lifeLabel.text = "Life Span: " + item.lifeSpan
        
        UserDefaults.standard.setValue(item.cfaURL, forKey: "cfaURL")
        UserDefaults.standard.setValue(item.vetstreetURL, forKey: "vetstreetURL")
        UserDefaults.standard.setValue(item.vcahospitalsURL, forKey: "vcahospitalsURL")
        UserDefaults.standard.setValue(item.wikipediaURL, forKey: "wikipediaURL")
        
        if item.image?.url != nil {
            self.backgroundImage.downloaded(from: (item.image?.url)!)
            self.imageItem.downloaded(from: (item.image?.url)!)
        }
        
        collectionAttributes.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttributesCell", for: indexPath) as! AttributesCarousel
        
        let width = self.view.frame.width
        cell.widthLabel.constant = CGFloat(width * 0.25)
        cell.widthProgress.constant = CGFloat(width * 0.60)
        
        cell.nameAttributes.text = attributes[indexPath.item]
        let valAtrib = valuesAttributes[indexPath.item]
        if valAtrib < 0.6 {
            cell.progressAtributtes.tintColor = .red
        }
        if valAtrib < 0.7 {
            cell.progressAtributtes.tintColor = .orange
        }
        
        if valAtrib > 0.7 {
            cell.progressAtributtes.tintColor = .green
        }
        cell.progressAtributtes.progress = valAtrib
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func showAlert(openUrl: String){
        let alert = UIAlertController(title: "Do you want to continue?", message: "You want to open this page in the browser", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            if let url = URL(string: openUrl) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openCFA(_ sender: Any) {
        if let url = UserDefaults.standard.string(forKey: "cfaURL"){
            showAlert(openUrl: url)
        }
    }
    
    @IBAction func openStreet(_ sender: Any) {
        if let url = UserDefaults.standard.string(forKey: "vetstreetURL"){
            showAlert(openUrl: url)
        }
    }
    
    @IBAction func openHospitals(_ sender: Any) {
        if let url = UserDefaults.standard.string(forKey: "vcahospitalsURL"){
            showAlert(openUrl: url)
        }
    }
    
    @IBAction func openWikipedia(_ sender: Any) {
        if let url = UserDefaults.standard.string(forKey: "wikipediaURL"){
            showAlert(openUrl: url)
        }
    }
}
