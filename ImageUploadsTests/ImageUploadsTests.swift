//
//  ImageUploadsTests.swift
//  ImageUploadsTests
//
//  Created by Poonam More on 28/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//
import Cloudinary
import XCTest
@testable import ImageUploads

class ImageUploadsTests: XCTestCase {
    var cloudinary: CLDCloudinary?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config = CLDConfiguration(cloudName: Constants.cloudinary_name, apiKey: Constants.api_key)
        cloudinary = CLDCloudinary(configuration: config)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCloudinaryConfigurations(){
        XCTAssertNotNil(cloudinary!.config, " Set up onfigurations for cloudinary is mandatory")
        
    }
    
    func testUploadImage(){
        
       // let expectation = self.expectation(description: "Upload image file from defined path")
        let dummyImage = "file:///Users/poonammore/Library/Developer/CoreSimulator/Devices/82922756-A6F5-4756-AB49-5FE471513718/data/Containers/Data/Application/1040A8F8-E9F8-4C42-A003-E912CC1A0F9C/Documentsasset.JPG"
        let dummyImagePath = URL(fileURLWithPath: dummyImage)
        XCTAssertNotNil(dummyImagePath, "Image path and image data should not be nil")

        
        let imagePresenter = ImagePresenter()
        imagePresenter.uploadImages(imageURL: dummyImagePath)
        
    }
    
}
