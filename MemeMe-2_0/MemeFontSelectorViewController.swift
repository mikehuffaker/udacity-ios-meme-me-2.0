//
//  MemeEditorFontSelectorViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/26/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import UIKit

class MemeFontSelectorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate
{
    @IBOutlet weak var pickerFont: UIPickerView!
    @IBOutlet weak var txtFontExample: UITextField!
    
    var fontList: [String] = [String]()
    
    var memeTxtAttributes:[String:Any] = [:]
    
    override func viewDidLoad()
    {
        print( "MemeFontSelectorViewController::viewDidLoad()" )
        
        super.viewDidLoad()
        
        // Redisplay the navigation controller so the user can go back to the Editor view.
        if let navigationController = navigationController
        {
            navigationController.isToolbarHidden = true
            navigationController.isNavigationBarHidden = false
        }
        
        let fontFamilyList = UIFont.familyNames
        
        for fontFamily in fontFamilyList
        {
            let fontNames = UIFont.fontNames( forFamilyName: fontFamily )
            
            for fontName in fontNames
            {
                print ( "Loading font list with font: ", fontName )
                fontList.append( fontName )
            }
        }
        
        fontList.sort()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewDidAppear()" )
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewWillAppear()" )
        
        // Font selector reappearing - reset font example to the current font name used in the Meme Editor
        var currentFont: UIFont
        currentFont = memeTxtAttributes[NSFontAttributeName] as! UIFont
        
        txtFontExample.text = currentFont.fontName
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewWillDisappear()" )
        
        super.viewWillDisappear( animated )
    }
    
    func numberOfComponents( in pickerView: UIPickerView ) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return fontList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return fontList[row]
    }
    
    // Show the user what the new font will look like
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print( "MemeFontSelectorViewController::didSelectRow - selected:", fontList[row] )
        
        let newMemeTxtAttributes:[String:Any] =
        [
                NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont( name: fontList[row], size: 40 )!,
                NSStrokeWidthAttributeName: NSNumber( value: -5.0 )
        ]
        
        txtFontExample.defaultTextAttributes = newMemeTxtAttributes
        txtFontExample.textAlignment = NSTextAlignment.center
        txtFontExample.text = fontList[row]       
    }
}

