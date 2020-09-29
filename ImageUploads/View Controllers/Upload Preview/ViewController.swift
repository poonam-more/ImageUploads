//
//  ViewController.swift
//  ImageUploads
//
//  Created by Poonam More on 28/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var btn = UIButton(type: .custom)

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var presenter: UploadPresenter!
    var progress: Progress?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.progressChanged(notification:)), name: Constants.progressChangedNotification, object: nil)
        
        
    }
   
    func configure(_with presenter: UploadPresenter) {
        self.presenter = presenter
    }
   
    func setupView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
      //  collectionView.register(UploadsCollectionViewCell.self, forCellWithReuseIdentifier: "UploadsCollectionViewCell")

        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let progress = notification.userInfo?["progress"] as? Progress

        if (progress != nil) {
            
            self.progress = progress
            
            print("\(Float(self.progress!.fractionCompleted))")

            if progress!.fractionCompleted == 1{
             //   self.dismiss(animated: true, completion: nil)

                

            }
            collectionView.reloadData()
        }

    }

    
    
    
}
extension ViewController{
    
    // MARK: UICollectionViewDataSource
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }

     func collectionView(_ collectionView: UICollectionView,
                         numberOfItemsInSection section: Int) -> Int {
         return 1
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCollection", for: indexPath) as! UploadsCollectionViewCell
        
        if self.progress != nil{
            cell.progressBarView.progress =  Float(self.progress!.fractionCompleted)
        }else{
            cell.progressBarView.isHidden = true
            cell.opaqueView.isHidden = true
        }
        //cell.testLabel.text = "test"
        if FileManager.default.fileExists(atPath: presenter.path!) {
            if let newImage = UIImage(contentsOfFile: presenter.path!) {
                 cell.imageSel.image  = newImage
             } 

         }
        return cell
     }
     
    

    
    
     // MARK: UICollectionViewDelegateFlowLayout
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        

         return CGSize(width: 160, height: 199)
         
     }

}
