//
//  CarsCollectionViewCell.swift
//  Used Cars
//
//  Created by Rohan Chopra on 7/9/21.
//

import UIKit

class CarsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carDetails: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var mileage: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dealerNumber: UIButton!
    @IBOutlet weak var dealerNumberForText: UIButton!
    
    override func prepareForReuse() {
        // To make sure collection view cells can be reused
        carImageView.image = #imageLiteral(resourceName: "imageNotFound")
        carDetails.text = ""
        carPrice.text = ""
        mileage.text = ""
        location.text = ""
        super.prepareForReuse()
    }
}
