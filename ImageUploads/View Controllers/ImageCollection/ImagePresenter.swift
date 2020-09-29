//
//  ImagePresenter.swift
//  ImageUploads
//
//  Created by Poonam More on 29/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import Foundation
import Cloudinary
import UIKit

class ImagePresenter {
    func uploadImages(imageURL: URL){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        NetworkHandler.upload(cloudinary: appDelegate.cloudinary!, url: imageURL)
            .progress({ progress in
                NotificationCenter.default.post(name: Constants.progressChangedNotification, object: nil, userInfo: ["progress": progress])
            }).response({ response, error in
                if (response != nil) {
                    print("response=\(response)")
                   
                } else if (error != nil) {
                    print("error==\(error)")
                  
                }
            })
    }
}
