# UsedCars
### Description

This project implements a robust methodology using a collection view to fetch and display data from an API, mainly for car selling applications. The data from the API is JSON and keys are strictly typed based on the API used. This uses a custom pagination logic to improve performance. This app is tested on all currently available simulators. 
Language used : Swift 5
External Libraries used : SwiftyJson (CocoaPods)

### Main Files
1. Cars.swift:- This is the model of the project, contains the main data object and all api call that directly edit it. It also implements pagination. 
2. CarsCollectionViewController.swift:- This is the controller file that implements a collection view.
3. CarsCollectionViewCell.swift:- A custom view file for the collection view cell.

### Usage

To run this project make sure you open 'Used Cars.xcworkspace' file and fix the certificate issues by logging in with your own apple id.
