//
//  MemeCollectionViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/16/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController
{
    @IBOutlet weak var MemeCollectionFlowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Properties
    
    // TODO: Add outlet to flowLayout here.
    
    var memes: [MemeImage] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad()
    {
        print( "MemeCollectionViewController::viewDidLoad()" )
        
        super.viewDidLoad()
        
        // Get reference to Memes Array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
        
        // Insert right "Add" button to navigation bar for editing Memes
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonPushed) )
        
        // Setup Collection View flow layout
        let spacing = CGFloat( 3.0 )
        let dimension = ( view.frame.size.width - ( 2 * spacing ) ) / 3.0
        
        MemeCollectionFlowLayout.minimumInteritemSpacing = spacing
        MemeCollectionFlowLayout.minimumLineSpacing = spacing
        MemeCollectionFlowLayout.itemSize = CGSize( width: dimension, height: dimension )
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print( "MemeCollectionViewController::numberOfItemsInSection()" )

        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print( "MemeCollectionViewController::cellForItemAt()" )
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let theMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.imgMeme?.image = theMeme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        print( "MemeCollectionViewController::didSelectItemAt()" )
        
        //let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
        //detailController.villain = self.allVillains[(indexPath as NSIndexPath).row]
        //self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func addButtonPushed()
    {
        if let navigationController = navigationController
        {
            // Get a StoryNodeController from the Storyboard
            let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC")as! MemeEditorViewController

            navigationController.pushViewController( memeEditorVC, animated: true )
        }
    }
}
