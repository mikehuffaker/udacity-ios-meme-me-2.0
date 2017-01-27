//
//  MemeTableViewController.swift
//  MemeMe-2_0
//
//  Created by Mike Huffaker on 1/17/17.
//  Copyright © 2017 Mike Huffaker. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController
{
    
    @IBOutlet var memeTable: UITableView!
    
    var appDelegate: AppDelegate!
    var memes: [MemeImage]!
    
    override func viewDidLoad()
    {
        print( "MemeTableViewController::viewDidLoad()")
        
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeTableViewController::viewWillAppear()")
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        // Noticed sometimes when exiting the Meme Edit view, even though the MEME was saved to the app delegate,
        // the collection didn't load the new image and refresh, so this is a fix for that
        
        print( "Refreshing Table" )
        memes = appDelegate.memesArray
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print( "MemeTableViewController::tableView::numberOfRowsInSection" )
        print( "Rows are: ", memes.count )
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print( "MemeTableViewController::tableView::cellForRowAt" )
        
        let cell:MemeTableCell = tableView.dequeueReusableCell( withIdentifier: "MemeTableCell", for: indexPath ) as! MemeTableCell
        
        let theMeme = memes[(indexPath as NSIndexPath).row]
        
        cell.imgMeme!.image = theMeme.memedImage
        
        cell.lblTop.text = theMeme.topText
        cell.lblBottom.text = theMeme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath )
    {
        print( "MemeTableViewController::didSelectItemAt()" )
        
        let controller = self.storyboard!.instantiateViewController( withIdentifier: "MemeDetailVC" ) as! MemeDetailViewController
        controller.theMeme = memes[(indexPath as NSIndexPath).row]
        
        if let navigationController = navigationController
        {
            navigationController.pushViewController( controller, animated: true )
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
        
        if let navigationController = navigationController
        {
            navigationController.pushViewController( controller, animated: true )
        }
    }
}

