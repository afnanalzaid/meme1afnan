//
//  ViewController.swift
//  project#2afnanalzaid
//
//  Created by afnan abdullah on 09/03/1440 AH.
//  Copyright © 1440 afnan abdullah. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var cancelButtom: UIBarButtonItem!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickImageFromLibraryButtom: UIBarButtonItem!
    @IBOutlet weak var shareImageButtom: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var pickImageFromCameraButtom: UIBarButtonItem!
    
    //let keyboardMoveListener = KeyboardMoveListener()
    let ImagePickerController = UIImagePickerController()
    let TextTopDelegate = MeMeTextDelegate()
    let TextBottomDelegate = MeMeTextDelegate()
    var Meme = MeMe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.delegate = self
        bottomText.delegate = self
        // Call this property so the image is added to  view
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        //By defaule hide shareand cancel button
        shareImageButtom.isEnabled = false
        cancelButtom.isEnabled = false
        //By defulet enable camera and album butttom
        pickImageFromLibraryButtom.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        pickImageFromCameraButtom.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //Initialize top text
        InitializeTextField(element: topText, text: Meme.TextTop, delegate: TextTopDelegate)
        InitializeTextField(element: bottomText, text: Meme.TextBottom, delegate: TextBottomDelegate)
        
        if let Image = Meme.ImageOriginal {
            loadViewImage(image: Image)
            (topText.delegate as! MeMeTextDelegate).DefaultText = false
            (bottomText.delegate as! MeMeTextDelegate).DefaultText = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if (bottomText.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    //close the keyboard when pressed somewhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topText {
            textField.resignFirstResponder()
            bottomText.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
  
    
    
    //Initialize top and bottom text
    func InitializeTextField(element: UITextField, text: String, delegate: UITextFieldDelegate) {
        let attributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0,
            ] as [NSAttributedString.Key : Any]
        
        element.text = text
        element.delegate = self;
        element.defaultTextAttributes = attributes
        element.textAlignment = NSTextAlignment.center
        element.isHidden = true
    }
   
    
    //Set image to view and display it to edit text
    func loadViewImage(image: UIImage) {
        ImageView.image = image
        bottomText.isHidden = false
        topText.isHidden = false
        shareImageButtom.isEnabled = true
        cancelButtom.isEnabled = true
    }
    // Picke an image buttom according to specific source type camera or albom
    func PickAnImageButton(sourceType: UIImagePickerController.SourceType) {
        
        ImagePickerController.delegate = self
        ImagePickerController.sourceType = sourceType
        ImagePickerController.isEditing = true
        present(ImagePickerController, animated: true, completion: nil)
    }
    
    //Pick an image from library
    @IBAction func PickImageFromLibrary(_ sender: Any) {
        PickAnImageButton(sourceType: .photoLibrary)
    }
    
    //Pick an imager from camera buttom
    @IBAction func PickImageFromCamera(_ sender: Any) {
        PickAnImageButton(sourceType: .camera)
    }
    
    // Handle image from camera or album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            loadViewImage(image: image)
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    //when the user didn't choose image
    
    
    //Make memed image from selcted image View
    func generateMemedImage() -> UIImage
    {
        var image = UIImage() ;
        
        for view in self.view.subviews {
            if view.restorationIdentifier == "Meme" {
                UIGraphicsBeginImageContext(view.frame.size)
                
                let statusBarHeight = (view.window!.convert(UIApplication.shared.statusBarFrame, from: view)).height
                
                let toolbarHeight = topBar.frame.height
                let context = UIGraphicsGetCurrentContext()
                context?.translateBy(x: 0, y: -(statusBarHeight + toolbarHeight))
                
                
                // Take "screenshot" of MemeView
                UIGraphicsBeginImageContext(self.view.frame.size)
                view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
                image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        return image}
    
    //Save Meme model in AppDelegate
    func Save(image: UIImage) {
        Meme.TextTop = topText.text!
        Meme.TextBottom = bottomText.text!
        Meme.ImageOriginal = ImageView.image!
        Meme.ImageMemed = image
        (UIApplication.shared.delegate as! AppDelegate).MeMes.append(Meme)
    }
    
    @IBAction func SharedButtom(_ sender: Any) {
        let image = generateMemedImage() ;
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.Save(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func CancelButtom(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to cancel editing?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            self.topText.text = "TOP"
            self.bottomText.text = "BOTTOM"
            self.dismiss(animated: true, completion: nil)
            
            }
            
        )
        
        alert.addAction(UIAlertAction(title: "Keep editing", style: .default) { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            }
        )
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

