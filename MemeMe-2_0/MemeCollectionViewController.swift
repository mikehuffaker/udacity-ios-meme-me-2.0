//
//  MemeCollectionViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/16/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController
{
    @IBOutlet weak var MemeCollectionFlowLayout: UICollectionViewFlowLayout!
    
    var memes: [MemeImage]!
    
    var portraitDimension: Int!
    var landscapeDimension: Int!
    var heightDimension: Int!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        print( "MemeCollectionViewController::viewDidLoad()" )
        
        // Setup Collection View flow layout
        let spacing = CGFloat( 4.0 )
        let dim1 = ( view.frame.size.width - ( 2 * spacing ) ) / 3.0
        let dim2 = ( view.frame.size.height - ( 2 * spacing ) ) / 3.0

        if dim1 < dim2
        {
            portraitDimension = Int(dim1)
            landscapeDimension = Int(dim2)
        }
        else
        {
            portraitDimension = Int(dim2)
            landscapeDimension = Int(dim1)
        }
        
        // Set to current size of cell, plus spacing.  In a future version
        // I might try to calculate this at runtime from the storyboard
        // collection cell height and spacing.
        heightDimension = 122 + Int(spacing)
        
        print( "Dimensions for collection portrait: ", portraitDimension )
        print( "Dimensions for collection portrait: ", landscapeDimension )
        
        // Set spacing once, dimensions will be set dynamically based on device
        // orientation later.
        MemeCollectionFlowLayout.minimumInteritemSpacing = spacing
        MemeCollectionFlowLayout.minimumLineSpacing = spacing
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )

        print( "MemeCollectionViewController::viewWillAppear()" )
        
        tabBarController?.tabBar.isHidden = false
        
        subscribeToDeviceRotationNotifications()
        
        // Get reference to Memes Array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
        
        refreshCollectionFlowLayout()
        
        collectionView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear( animated )
        
        print( "MemeCollectionViewController::viewWillDisappear()" )
        
        unsubscribeFromDeviceRotationNotifications()
    }
    
    // Refresh the flow layout as the view width will change with device rotation and sometimes
    // it won't look correct - for example collection view first loaded in landscape and then 
    // cells are too large to fit > 1 on a row in portrait when device is rotated.
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
        refreshCollectionFlowLayout()
    }
    
    func refreshCollectionFlowLayout()
    {
        let orientation = UIDevice.current.orientation
        
        switch orientation
        {
        case .landscapeRight, .landscapeLeft:
            print ( "Landscape" )
            MemeCollectionFlowLayout.itemSize = CGSize( width: landscapeDimension, height: heightDimension )
        default:
            print ( "Default" )
            MemeCollectionFlowLayout.itemSize = CGSize( width: portraitDimension, height: heightDimension )
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print( "MemeCollectionViewController::numberOfItemsInSection()" )
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print( "MemeCollectionViewController::cellForItemAt()" )
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        let theMeme = memes[(indexPath as NSIndexPath).row]
        cell.imgMeme?.image = theMeme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print( "MemeCollectionViewController::didSelectItemAt()" )
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC" ) as! MemeDetailViewController
        
        controller.theMeme = memes[(indexPath as NSIndexPath).row]
        
        if let navigationController = navigationController
        {
            navigationController.pushViewController( controller, animated: true )
        }
    }

    @IBAction func addButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController( withIdentifier: "MemeEditorVC" ) as! MemeEditorViewController
        
        if let navigationController = navigationController
        {
            navigationController.pushViewController( controller, animated: true ) 
        }
    }
}
