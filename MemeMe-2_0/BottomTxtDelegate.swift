//
//  TxtBottomDelegate.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 12/2/16.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import Foundation
import UIKit

class BottomTxtDelegate : NSObject, UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print( "BottomTxtFieldDelegate::textFieldDidBeginEditing()")
        
        // Only if the text field has is initial value, then null
        // out when the user starts editing
        if textField.text == "BOTTOM"
        {
            textField.text = ""
        }
        
        print( "Exiting textFieldDidBeginEditing")
        
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print( "BottomTxtFieldDelegate::textFieldShouldReturn()")
        
        textField.resignFirstResponder()
        
        return true;
    }
}
