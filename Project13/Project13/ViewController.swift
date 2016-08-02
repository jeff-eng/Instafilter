//
//  ViewController.swift
//  Project13
//
//  Created by Jeffrey Eng on 8/1/16.
//  Copyright © 2016 Jeffrey Eng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    @IBAction func changeFilter(sender: AnyObject) {
        let filterChoices = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]
        
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .ActionSheet)
        
        for filter in filterChoices {
            ac.addAction(UIAlertAction(title: filter, style: .Default, handler: setFilter))
        }
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
    }
    
    @IBAction func intensityChanged(sender: AnyObject) {
        applyProcessing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the title at the top
        title = "Instafilter"
        // Creates a '+' bar button item at the top and calls the importPicture method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(importPicture))
       
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    // This method is for selection of the picture from the Image Picker Controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        currentImage = newImage
        
        // Create a CIImage object with the current image and passed as input image for filter
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    // This method closes the Image Picker Controller when user presses cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyProcessing() {
        // Sets intensity slider value as the value for the key kCIInputImageKey
        currentFilter.setValue(intensity.value, forKey: kCIInputImageKey)
        // Creates data type called CGImage
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        // Creates a UIImage from the CGImage
        let processedImage = UIImage(CGImage: cgimg)
        // Assigns UIImage to the image view
        imageView.image = processedImage
    }
}

