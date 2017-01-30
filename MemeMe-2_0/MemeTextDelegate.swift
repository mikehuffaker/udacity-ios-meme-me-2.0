//
//  MemeTxtDelegate.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/30/17.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import Foundation
import UIKit

class MemeTxtDelegate : NSObject, UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print( "MemeTxtFieldDelegate::textFieldDidBeginEditing()" )
        
        // Only if the text field has is initial value, then null
        // out when the user starts editing
        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
        }
        
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print( "MemeTxtFieldDelegate::textFieldShouldReturn()")
        
        textField.resignFirstResponder()
        
        return true;
    }
}
