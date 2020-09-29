//
//  ViewController.swift
//  ImageUploads
//
//  Created by Poonam More on 28/09/20.
//  Copyright © 2020 Poonam More. All rights reserved.
//

import UIKit

class ImageViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var btn = UIButton(type: .custom)
    var images = [UIImage]()

    var customProgressView: CustomProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        floatingButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.progressChanged(notification:)), name: Constants.progressChangedNotification, object: nil)
    }

    func floatingButton(){
        let screenRect = UIScreen.main.bounds

        btn.frame = CGRect(x:screenRect.size.width-100 , y: screenRect.size.height-180, width: 70, height: 70)
        btn.titleLabel?.font = .systemFont(ofSize: 36)
        btn.setTitle("+", for: .normal)
        btn.backgroundColor = UIColor.black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 35
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 1.0
        btn.addTarget(self,action: #selector(ImageViewController.buttonTapped), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    @IBAction func buttonTapped(_ sender: Any)
      {
        print("button tapped")
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let progress = notification.userInfo?["progress"] as? Progress

        if (progress != nil) {
            
            if self.customProgressView != nil{
                customProgressView?.uploadProgressBar.progress = Float(progress!.fractionCompleted)
            }
            //progressMap[name!] = progress!
        }

        // refresh views
        //collectionView.reloadData()
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageUrl = info[UIImagePickerControllerReferenceURL] as! URL
        let imgName = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let localPath = documentDirectory?.appending(imgName)

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image1 = image.resized(withPercentage: 0.1)
        let data = UIImagePNGRepresentation(image1!)! as NSData
        data.write(toFile: localPath!, atomically: true)
        //let imageData = NSData(contentsOfFile: localPath!)!
        let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
        print(photoURL)
            // upload to cloudinary

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
    
        dismiss(animated: true)

        images.insert(image, at: 0)
            uploadImages(imageURL: photoURL)
            showProgressView(image: image)

        }
        collectionView?.reloadData()
        
        // 1
    }
    
    func showProgressView(image:UIImage){
        let screenRect = UIScreen.main.bounds

        let allViewsInXibArray = Bundle.main.loadNibNamed("CustomProgressView", owner: self, options: nil)

        customProgressView = allViewsInXibArray?
            .first as! CustomProgressView
        customProgressView!.selectedImage.image = image
        customProgressView!.frame = CGRect(x:screenRect.size.width/2-169 , y: screenRect.size.height-100, width: 338, height: 78)
        customProgressView!.detailButton.addTarget(self,action: #selector(ImageViewController.detailButtonTapped), for: .touchUpInside)
        //Add the view
        self.view.addSubview(customProgressView!)
    }
    
    @IBAction func detailButtonTapped(_ sender: Any)
      {
        print("detail button tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                                   
        self.present(newVC, animated: true, completion: nil)
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }
}


extension ImageViewController{
    
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
                       // PersistenceHelper.resourceUploaded(localPath: name!, publicId: (response?.publicId)!)
                        // cleanup - once a file is uploaded we don't use the local copy
                        //try? FileManager.default.removeItem(at: url)
                    } else if (error != nil) {
                        print("error==\(error)")
                      //  PersistenceHelper.resourceError(localPath: name!, code: (error?.code) != nil ? (error?.code)! : -1, description: (error?.userInfo["message"] as? String))
                    }
                })
        }
    
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
