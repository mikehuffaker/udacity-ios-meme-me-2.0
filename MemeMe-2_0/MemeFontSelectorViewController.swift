//
//  MemeFontSelectorViewController.swift
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
        super.viewDidLoad()

        print( "MemeFontSelectorViewController::viewDidLoad()" )
        
        // Redisplay the navigation controller so the user can go back to the Editor view.
        if let navigationController = navigationController
        {
            navigationController.isNavigationBarHidden = false
        }
        
        // Load font list array with all the bold fonts.  Fonts that are not bold
        // don't seem to look as good on the Meme and don't always work with the
        // stroke width setting.
        let fontFamilyList = UIFont.familyNames
        
        for fontFamily in fontFamilyList
        {
            let fontNames = UIFont.fontNames( forFamilyName: fontFamily )
            
            for fontName in fontNames
            {
                print ( "Loading font list with font: ", fontName )
                
                if fontName.contains( "Bold" )
                {
                    fontList.append( fontName )
                }
            }
        }
        
        // Put fonts in alphabetic order
        fontList.sort()
    }
    
    // Font selector view  reappearing - reset font example field to the current
    // font name used in the Meme Editor and also pre-select the picker
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        print( "MemeFontSelectorViewController::viewWillAppear()" )
        
        var currentFont: UIFont
        currentFont = memeTxtAttributes[NSFontAttributeName] as! UIFont
        
        txtFontExample.text = currentFont.fontName
        
        for ( inx, font ) in fontList.enumerated()
        {
            if font == currentFont.fontName
            {
                pickerFont.selectRow( inx, inComponent: 0, animated: false )
            }
        }
    }

    // When view is going to disappear, set the edit meme view txt attributes to the 
    // value selected in the picker and re-hide the navigation bar
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear( animated )

        print( "MemeFontSelectorViewController::viewWillDisappear()" )
        
        if let navigationController = navigationController
        {
            navigationController.isNavigationBarHidden = true

            let viewControllers = navigationController.viewControllers
            let viewIdx = (viewControllers.count) - 1
            let editMemeController = viewControllers[viewIdx] as! MemeEditorViewController
            
            editMemeController.memeTxtAttributes = memeTxtAttributes
        }
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
    
    // New Font was picked, so update text attributes dictionary and also update
    // text field to show an example of how it will appear
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print( "MemeFontSelectorViewController::didSelectRow - selected:", fontList[row] )
        
        memeTxtAttributes =
        [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont( name: fontList[row], size: 40 )!,
            NSStrokeWidthAttributeName: NSNumber( value: -5.0 )
        ]
        
        txtFontExample.defaultTextAttributes = memeTxtAttributes
        txtFontExample.textAlignment = NSTextAlignment.center
        txtFontExample.text = fontList[row]
    }
}
