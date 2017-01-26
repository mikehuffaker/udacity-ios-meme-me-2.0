//
//  MemeEditorFontSelectorViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/26/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import UIKit

class MemeFontSelectorViewController: UIViewController, UINavigationControllerDelegate
{
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
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewDidAppear()" )
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewWillAppear()" )
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        print( "MemeFontSelectorViewController::viewWillDisappear()" )
        
        super.viewWillDisappear( animated )
    }
    
}

