//
//  UploadPresenter.swift
//  ImageUploads
//
//  Created by Poonam More on 29/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import Foundation
import UIKit
class UploadPresenter {
    var path:String?
    var progress:Int?
    
    init(image:String, progress: Int) {
        self.path = image
        self.progress = progress
    }
}
