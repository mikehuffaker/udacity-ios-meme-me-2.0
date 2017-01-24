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
        let spacing = CGFloat( 3.0 )
        let dimension = ( view.frame.size.width - ( 2 * spacing ) ) / 3.0
        
        MemeCollectionFlowLayout.minimumInteritemSpacing = spacing
        MemeCollectionFlowLayout.minimumLineSpacing = spacing
        MemeCollectionFlowLayout.itemSize = CGSize( width: dimension, height: dimension )
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeCollectionViewController::viewWillAppear()" )
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        
        let theMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.imgMeme?.image = theMeme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        print( "MemeCollectionViewController::didSelectItemAt()" )
        
        let detailController = self.storyboard!.instantiateViewController( withIdentifier: "MemeDetailVC" ) as! MemeDetailViewController
        detailController.theMeme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController( detailController, animated: true )
    }
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
