//
//  NetworkHandler.swift
//  ImageUploads
//
//  Created by Poonam More on 29/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import Foundation
import Cloudinary
import UIKit

class NetworkHandler{
    
    //MARK: Upload Images to Cloudinary cloud
    static func upload(cloudinary: CLDCloudinary, url: URL) -> CLDUploadRequest {

        return cloudinary.createUploader().upload(url: url, uploadPreset: Constants.upload_preset)
        
    }
    
    
}
