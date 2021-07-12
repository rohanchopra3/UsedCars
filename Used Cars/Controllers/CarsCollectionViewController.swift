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
    var isDownloading = false
    let activityView = UIActivityIndicatorView(style: .large)
    let fadeView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellSize()
        makeInitialAPIFetch()
        setupAdditionalViews()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //garbageCollection and freeing up memory
        self.cars.removeAll()
    }
    
    func makeInitialAPIFetch(){
        makeAPICall(UrlString: urlString, completionHandler: {
            (cars) in
            if !cars.isEmpty{
                self.cars = cars
                calculatePaginationParametersfor(interval: interval, total_count: self.cars.count)
                self.downloadImagesAndImplementPagination()
            }
            
        })
    }
    
    func setupAdditionalViews(){
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.4
        self.view.addSubview(fadeView)
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
}



// This extension contains all collection view components and helper functions
extension CarsCollectionViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDownloadCounter
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CurrencyFormatter = NumberFormatter()
        CurrencyFormatter.numberStyle = .currency
        CurrencyFormatter.minimumFractionDigits = 0
        
        // Configure Cells UI Appearance
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CarsCollectionViewCell
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: cell.frame.size.height-1, width: cell.frame.size.width, height: 1);
        bottomBorder.backgroundColor = #colorLiteral(red: 0.6742801845, green: 0.6742801845, blue: 0.6742801845, alpha: 0.68)
        cell.layer.addSublayer(bottomBorder)
        cell.carImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        cell.carImageView.layer.masksToBounds = true
        cell.carImageView.layer.borderWidth = 1
        cell.carImageView.image = cars[indexPath.row].carImage
        
        // Configure the cell for Data
        cell.carDetails.text = String(cars[indexPath.row].Year) + " " + cars[indexPath.row].Make + " " + cars[indexPath.row].Model + " " + cars[indexPath.row].Trim
        cell.carPrice.text = CurrencyFormatter.string(for: cars[indexPath.row].Price)
        cell.location.text = cars[indexPath.row].Location
        cell.mileage.text = String(Int(cars[indexPath.row].Mileage)) + " Mi"
        
        cell.dealerNumber.setTitle(cars[indexPath.row].DealerNumber.toPhoneNumber(), for: .normal)
        cell.dealerNumberForText.setTitle(cars[indexPath.row].DealerNumber.toPhoneNumber(), for: .normal)
        cell.dealerNumber.addTarget(self, action: #selector(callDealer(sender:)), for: .touchUpInside)
        cell.dealerNumberForText.addTarget(self, action: #selector(messageDealer(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // check if middle cell is in view then is fetches more items
        if indexPath.row == Int(imageDownloadCounter/2) && isDownloading == false{
            isDownloading = true
            downloadImagesAndImplementPagination()
        }
    }
    
    func setCellSize(){
        // sets the layout for collection view cell
        // Dynamic layout setup to ensure all iphone sizes are compatible
        let cellSize = CGSize(width:(self.collectionView.frame.width - 20), height:300)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func downloadImagesAndImplementPagination(){
        // To implement pagination and download images at the same time
        let myGroup = DispatchGroup()
        for index in imageDownloadCounter..<endimageDownloadCounter{
            myGroup.enter()
            downloadImages(UrlString: self.cars[index].carImageURl, completionHandler: {
                (data) in
                if let data = data{
                    self.cars[index].carImage = UIImage(data: data)
                    myGroup.leave()
                }else{
                    self.cars[index].carImage = #imageLiteral(resourceName: "imageNotFound")
                }
            })
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            imageDownloadCounter = endimageDownloadCounter
            calculatePaginationParametersfor(interval: interval, total_count: self.cars.count)
            self.isDownloading = false
            self.fadeView.removeFromSuperview()
            self.activityView.stopAnimating()
            self.collectionView.reloadData()
            
        })
    }
    
    
    @objc func callDealer(sender: UIButton)
    {
        if let phonenumber = sender.currentTitle{
            guard let number = URL(string: "tel://" + phonenumber ) else { return }
            UIApplication.shared.open(number)
        }else{
            return
        }
        
    }
    
    @objc func messageDealer(sender: UIButton)
    {
        if let phonenumber = sender.currentTitle{
            guard let number = URL(string: "sms://" + phonenumber ) else { return }
            UIApplication.shared.open(number)
        }else{
            return
        }
        
    }
    
}
