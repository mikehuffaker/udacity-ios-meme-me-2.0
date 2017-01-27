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

    override func viewDidLoad()
    {
        print( "MemeCollectionViewController::viewDidLoad()" )
        
        super.viewDidLoad()
        
        // Get reference to Memes Array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
        
        // Setup Collection View flow layout
        let spacing = CGFloat( 4.0 )
        let dimension = ( view.frame.size.width - ( 2 * spacing ) ) / 3.0
        print( "Dimension for collection: ", dimension )
        
        let iDimension = Int(dimension)
        print( "Dimension for collection rounded: ", iDimension )
        
        MemeCollectionFlowLayout.minimumInteritemSpacing = spacing
        MemeCollectionFlowLayout.minimumLineSpacing = spacing
        MemeCollectionFlowLayout.itemSize = CGSize( width: iDimension, height: iDimension )
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeCollectionViewController::viewWillAppear()" )
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        // Noticed sometimes when exiting the Meme Edit view, even though the MEME was saved to the app delegate,
        // the collection didn't load the new image and refresh, so this is a fix for that
        
        // Get reference to Memes Array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
        
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print( "MemeCollectionViewController::numberOfItemsInSection()" )
        print( "Rows are: ", memes.count )
        
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
