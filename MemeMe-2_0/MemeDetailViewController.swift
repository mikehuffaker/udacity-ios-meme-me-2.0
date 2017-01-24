//
//  MemeDetailViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/19/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController
{
    @IBOutlet weak var imgView: UIImageView!
    
    var theMeme: MemeImage!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.imgView!.image = theMeme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
