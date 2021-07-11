//
//  CarsCollectionViewController.swift
//  Used Cars
//
//  Created by Rohan Chopra on 7/9/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class CarsCollectionViewController: UICollectionViewController {
    
    var cars:[cars] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCellSize()
        makeAPICall(UrlString: urlString, completionHandler: {
            (cars) in
            if !cars.isEmpty{
                self.cars = cars
                while(imageDownloadCounter < self.cars.count){
                    
                    downloadImages(UrlString: self.cars[imageDownloadCounter].carImageURl, completionHandler: {
                        (data) in
                        if let data = data{
                            self.cars[imageDownloadCounter].carImage = data
                            
                        }
                        imageDownloadCounter += 1
                        print(imageDownloadCounter)
                        if imageDownloadCounter % 10 == 0 && imageDownloadCounter != 0{
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    })
                  
                    if imageDownloadCounter % 10 == 0 && imageDownloadCounter != 0{
                        break
                    }
                    
                    
                }
            }
        })
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cars.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CarsCollectionViewCell
        
        cell.carImageView.image = UIImage(data: cars[indexPath.row].carImage ?? Data())
        cell.carName.text = cars[indexPath.row].Model
        // Configure the cell
        
     
    
        return cell
    }
    
    func setCellSize(){
        let cellSize = CGSize(width:(self.collectionView.frame.width) - 2, height:238)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
    
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
