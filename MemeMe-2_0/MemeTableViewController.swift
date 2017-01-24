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
        
        // Per a tutorial on this web page: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
        // this is supposed to help tell Auto Layout to resize the table cells as needed.  It does in fact work.
        // If I comment this code out, the lblDtl field will not resize to hold 2 lines of text when I test the
        // app on a smaller screen, such as the iPhone 5 screen.
        //memeTable.rowHeight = UITableViewAutomaticDimension
        //memeTable.estimatedRowHeight = 140
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeTableViewController::viewWillAppear()")
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        // Noticed sometimes when exiting the Meme Edit view, the table doesn't get updated and seems to still point
        // to a "Copy" of the original array from the AppDelegate, NOT a reference.
        print( "Refreshing Table" )
        memes = appDelegate.memesArray
        self.tableView.reloadData()
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
        
        let theMeme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imgMeme!.image = theMeme.memedImage
        
        cell.lblTop.text = theMeme.topText
        cell.lblBottom.text = theMeme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath )
    {
        print( "MemeTableViewController::didSelectItemAt()" )
        
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

