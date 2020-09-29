//
//  DetailsViewController.swift
//  ImageUploads
//
//  Created by Poonam More on 29/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    fileprivate var presenter: DetailPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func configure(_with presenter: DetailPresenter) {
        self.presenter = presenter
    }

    func setupView(){
        if self.presenter != nil{
            if FileManager.default.fileExists(atPath: presenter.imagePath!) {
               if let newImage = UIImage(contentsOfFile: presenter.imagePath!) {
                    self.imgView.image  = newImage
                }

            }
        }
    }
    

}
