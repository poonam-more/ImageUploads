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
    var customProgressView: CustomProgressView?
    var dummyView: UIView?

    var images=[UIImage]()
    var currentImagePath: String?
    fileprivate var presenter: ImagePresenter!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        floatingButton()
        
        presenter = ImagePresenter()

        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.progressChanged(notification:)), name: Constants.progressChangedNotification, object: nil)
       
        setupViews()
    }
    
    func setupViews() {
        self.title = "Image Viewer"
        floatingButton()
    

    }

    //MARK: Floating button initialization
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
    func addDummyView(items:[UIImage]) {
        if items.count == 0{
            let screenRect = UIScreen.main.bounds

            dummyView = UIView()
            dummyView!.frame = CGRect(x:0 , y: 0, width: screenRect.size.width, height: screenRect.size.height-200)
            dummyView!.backgroundColor = UIColor.init(red: 49.0/255.0, green: 49.0/255.0, blue: 49.0/255.0, alpha: 1.0)

            
            let label = UILabel()
            label.frame = CGRect(x:50 , y: 150, width: screenRect.size.width/2, height: 40)
            label.text = "Tap on + button to upload images"
            
            dummyView!.addSubview(label)
            
            self.view.addSubview(dummyView!)
        }
    }
    
    //MARK: CustomProgressView initialization
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
    
    //MARK: Button Action
    @IBAction func buttonTapped(_ sender: Any)
      {
        print("button tapped")
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: Notification Observer
    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let progress = notification.userInfo?["progress"] as? Progress

        if (progress != nil) {
            
            if self.customProgressView != nil{
                customProgressView?.uploadProgressBar.progress = Float(progress!.fractionCompleted)
                
                print(Int(progress!.fractionCompleted)*100)
                customProgressView!.uploadProgressLabel.text = "Uploading.. " + "\(Int(progress!.fractionCompleted)*100)" + "%"
            }
            if progress!.fractionCompleted == 1{
                self.customProgressView!.isHidden = true
                showAlert(message:"Image uploaded successfully")

            }
            
        }

    }
    

    
    @IBAction func detailButtonTapped(_ sender: Any)
      {
        
         
        let presenter = UploadPresenter(image:self.currentImagePath!,progress: 0)
        print("detail button tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newVC.configure(_with: presenter)
        self.present(newVC, animated: true, completion: nil)
        
    }
   
    func showAlert(message:String){
        let alert = UIAlertController(title: "Image Uploads", message: message, preferredStyle: UIAlertControllerStyle.alert)
               
               // add an action (button)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
               
               // show the alert
               self.present(alert, animated: true, completion: nil)
    }
}


extension ImageViewController{

    
    //MARK: UICollectionView Datasource
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presenter = DetailPresenter(path:self.currentImagePath!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        newVC.configure(_with: presenter)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    //MARK: Image picker Delegates
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
           let imageUrl = info[UIImagePickerControllerReferenceURL] as! URL
           let imgName = imageUrl.lastPathComponent
           let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
           let localPath = documentDirectory?.appending(imgName)
           self.currentImagePath = localPath

           let image = info[UIImagePickerControllerOriginalImage] as! UIImage
           let image1 = image.resized(withPercentage: 0.1)
           let data = UIImagePNGRepresentation(image1!)! as NSData
           data.write(toFile: localPath!, atomically: true)
           let photoURL = URL.init(fileURLWithPath: localPath!)
           print(photoURL)

           if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
       
           dismiss(animated: true)

           images.insert(image, at: 0)
           presenter.uploadImages(imageURL: photoURL)
           showProgressView(image: image)
            

           }
           collectionView?.reloadData()
           
       }
       
}



