//
//  ViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 11/30/16.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    // Top toolbar and buttons
    @IBOutlet weak var tbSocial: UIToolbar!
    @IBOutlet weak var btnSocial: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    // Text fields and image
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtBottom: UITextField!
    
    // Bottom toolbar and buttons
    @IBOutlet weak var tbImage: UIToolbar!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    
    // Constraints for adjusting at runtime
    @IBOutlet weak var topTxtConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTxtConstraint: NSLayoutConstraint!
    
    var memeTxtAttributes:[String:Any] = [:]

    let topTxtDelegate = MemeTxtDelegate()
    let bottomTxtDelegate = MemeTxtDelegate()
    
    var theMeme: MemeImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print( "MemeEditorViewController::viewDidLoad()" )
        
        if let tabBarController = tabBarController
        {
            tabBarController.tabBar.isHidden = true
        }
        
        // Hide the navigation controller bars for this screen
        if let navigationController = navigationController
        {
            navigationController.isToolbarHidden = true
            navigationController.isNavigationBarHidden = true
        }
        
        // initially disable top toolbar share button, until the user picks an image for a meme
        btnSocial.isEnabled = false

        // Initial value for text attibutes, can be changed from the Font Selector View
        memeTxtAttributes =
        [
                NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont( name: "HelveticaNeue-CondensedBlack", size: 40 )!,
                NSStrokeWidthAttributeName: NSNumber( value: -5.0 )
        ]
        
        // Setup top meme text field
        initializeTextField( textField: txtTop, initialText: "TOP", delegate: topTxtDelegate )
        
        // Setup bottom meme text field
        initializeTextField( textField: txtBottom, initialText: "BOTTOM", delegate: bottomTxtDelegate )
        
        // Setting Aspect Fit so image expands and fits the screen
        imgView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear( animated )
        
        print( "MemeEditorViewController::viewDidAppear()" )
        
        // Test if device has camera or not and enable/disable button accordingly
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )

        print( "MemeEditorViewController::viewWillAppear()" )
        
        subscribeToKeyboardNotifications()
        subscribeToDeviceRotationNotifications()
        
        // Adjust constraints based on current orientation portrait/landscape
        refreshTextFieldConstraints()
        
        // Reset fonts
        refreshTextFieldFont( textField: txtTop )
        refreshTextFieldFont( textField: txtBottom )
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear( animated )

        print( "MemeEditorViewController::viewWillDisappear()" )
        
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromDeviceRotationNotifications()
    }
    
    // Initialization code

    // Method to init text fields
    func initializeTextField ( textField: UITextField, initialText: String, delegate: UITextFieldDelegate )
    {
        print( "MemeEditorViewController::initializeTextFields()" )
        
        textField.defaultTextAttributes = memeTxtAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = initialText
        textField.borderStyle = UITextBorderStyle.none
        textField.delegate = delegate
    }
    
    // Method to refresh the font text fields
    func refreshTextFieldFont ( textField: UITextField )
    {
        print( "MemeEditorViewController::refreshTextFieldFont" )
        
        textField.defaultTextAttributes = memeTxtAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.borderStyle = UITextBorderStyle.none
    }
    
    // Methods to adjust contraints for device orientation
    func subscribeToDeviceRotationNotifications()
    {
        NotificationCenter.default.addObserver( self, selector: #selector(deviceWasRotated(_:)), name: .UIDeviceOrientationDidChange, object: nil )
    }
    
    func unsubscribeFromDeviceRotationNotifications()
    {
        NotificationCenter.default.removeObserver( self, name: .UIDeviceOrientationDidChange, object: nil )
    }
    
    func deviceWasRotated(_ notification:Notification)
    {
        refreshTextFieldConstraints()
    }
    
    func refreshTextFieldConstraints()
    {
    
        let orientation = UIDevice.current.orientation
    
        switch orientation
        {
        case .landscapeRight, .landscapeLeft:
            print ( "LandscapeRight" )
            topTxtConstraint.constant = 15
            bottomTxtConstraint.constant = 15
        default:
            print ( "Default" )
            topTxtConstraint.constant = 35
            bottomTxtConstraint.constant = 35
        }
    }

    // Keyboard shifting code
    func subscribeToKeyboardNotifications()
    {
        print( "MemeEditorViewController::subscribeToKeyboardNotifications()" )

        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil )
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        print( "MemeEditorViewController::unsubscribeFromKeyboardNotifications()" )

        NotificationCenter.default.removeObserver( self, name: .UIKeyboardWillShow, object: nil )
        NotificationCenter.default.removeObserver( self, name: .UIKeyboardWillHide, object: nil )
    }
    
    func keyboardWillShow(_ notification:Notification)
    {
        print( "MemeEditorViewController::keyboardWillShow()" )

        if txtBottom.isFirstResponder
        {
            // Updated to use * -1 per code review and post on Udacity forums.
            view.frame.origin.y = getKeyboardHeight( notification ) * -1
        }
    }
    
    func keyboardWillHide(_ notification:Notification)
    {
        print( "MemeEditorViewController::keyboardWillHide()" )

        if txtBottom.isFirstResponder
        {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        print( "MemeEditorViewController::getKeyboardHeight()" )

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Image picker code section
    
    // User cancelled instead of picking an image
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController )
    {
        print( "MemeEditorViewController::imagePickerControllerDidCancel()" )

        dismiss( animated: true, completion: nil )
    }

    // User actually picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print( "MemeEditorViewController::imagePickerController() - picked image Delegate" )

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgView.contentMode = .scaleAspectFit
            imgView.image = image
            btnSocial.isEnabled = true
            btnCancel.isEnabled = true
        }
        else
        {
            print( "MemeEditorViewController::imagePickerController: error passing picked image to view controller image." )
        }
        
        dismiss( animated: true, completion: nil )
    }

    @IBAction func pickImageFromCamera(_ sender: AnyObject)
    {
        print( "MemeEditorViewController::pickImageFromCamera()" )

        pickImageProcessing( sourceType: UIImagePickerControllerSourceType.camera )
    }
    
    @IBAction func pickImageFromAlbum(_ sender: AnyObject)
    {
        print( "MemeEditorViewController::pickImageFromAlbum()" )

        pickImageProcessing( sourceType: UIImagePickerControllerSourceType.photoLibrary )
    }
    
    func pickImageProcessing ( sourceType: UIImagePickerControllerSourceType )
    {
        print( "MemeEditorViewController::pickImageProcessing()" )
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        present( pickerController, animated: true, completion: nil )
    }
    
    // Font button pressed, open Meme Font selection view
    @IBAction func selectFont(_ sender: Any)
    {
        print( "MemeEditorViewController::selectFont" )
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "MemeFontSelectorVC") as! MemeFontSelectorViewController
        
        controller.memeTxtAttributes = memeTxtAttributes
            
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // User pressed cancel, reset application
    @IBAction func cancelMeme(_ sender: AnyObject)
    {
        print( "MemeEditorViewController::cancelMeme()" )

        btnSocial.isEnabled = false
        txtTop.text = "TOP"
        txtBottom.text = "BOTTOM"
        imgView.image = nil
        
        // per Apple docs, I think this is ok, it will set the structures reference to nil
        // and via ARC functionallity, memory will be freed up automatically, similar to Java
        // garbage collection.
        theMeme = nil
        
        if let tabBarController = tabBarController
        {
            tabBarController.tabBar.isHidden = false
        }
        
        // Pop back to Collection OR Table View
        if let navigationController = navigationController
        {
            // Un-Hide the navigation controller bars for this screen, and "pop" back
            navigationController.isNavigationBarHidden = false
            navigationController.popToRootViewController(animated: true )
        }
    }
    
    // Meme sharing/processing code
    
    // generate and then share the meme by launching the activity view
    @IBAction func shareMeme(_ sender: AnyObject)
    {
        print( "MemeEditorViewController::shareMeme()" )
        
        let memedImage = generateMemedImage()
        let socialController = UIActivityViewController( activityItems: [memedImage], applicationActivities: nil )

        socialController.completionWithItemsHandler =
        {
            activityType, completion, items, error in
            
            if completion
            {
                print ( "User performed activity:" + activityType!.rawValue )
                // Save meme
                self.saveMemedImage( memedImage: memedImage )
            }
            else
            {
                print ( "User cancelled or other error" )
            }
            
            // Once user shares or cancels, then return back to previous view - Table or Collection
            // and restore the navigation bar to the screen
            if let navigationController = self.navigationController
            {
                print ( "Returning to previous view via navigation" )
                navigationController.isNavigationBarHidden = false
                navigationController.popToRootViewController( animated: true )
            }
        }
        
        present( socialController, animated: true, completion: nil )
    }
    
    // generate a new Memed image
    func generateMemedImage() -> UIImage
    {
        print( "MemeEditorViewController::generateMemedImage()" )
        
        tbSocial.isHidden = true
        tbImage.isHidden = true
        
        UIGraphicsBeginImageContext( view.frame.size )
        view.drawHierarchy( in: view.frame, afterScreenUpdates: true )
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        tbSocial.isHidden = false
        tbImage.isHidden = false

        return memedImage
    }
    
    // Note - slight variation on lesson example - memed image is local to calling function,
    // But other values are already objects in the view controller class, so I think
    // its better to pass in the memedImage as it is not a class variable at this point.
    func saveMemedImage( memedImage: UIImage )
    {
        print( "MemeEditorViewController::saveMemedImage()" )
        
        theMeme = MemeImage.init( topText: txtTop.text!, bottomText: txtBottom.text!, origImage: imgView.image!, memedImage: memedImage )
        
        print( "Adding Meme to appDelegate memesArray" )
        ( UIApplication.shared.delegate as! AppDelegate ).memesArray.append( theMeme )
    }
}

