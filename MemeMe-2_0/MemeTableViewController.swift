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
    var memes: [MemeImage] = []
    
    override func viewDidLoad()
    {
        print( "MemeTableViewController::viewDidLoad()")
        super.viewDidLoad()
        
        // Per a tutorial on this web page: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
        // this is supposed to help tell Auto Layout to resize the table cells as needed.  It does in fact work.
        // If I comment this code out, the lblDtl field will not resize to hold 2 lines of text when I test the
        // app on a smaller screen, such as the iPhone 5 screen.
        //historyTable.rowHeight = UITableViewAutomaticDimension
        //historyTable.estimatedRowHeight = 100
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memesArray
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print( "MemeTableViewController::tableView::numberOfRowsInSection" )
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print( "MemeTableViewController::tableView::cellForRowAt" )
        
        let cellID = "MemeTableCell"
        
        let cell:MemeTableCell = tableView.dequeueReusableCell( withIdentifier: cellID, for: indexPath ) as! MemeTableCell
        
        let theMeme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set table view cell values after parsing out from match class object
        //let img = UIImage( named: match.imageName )
        cell.imgMeme!.image = theMeme.memedImage
        
        cell.lblTop.text = theMeme.topText
        cell.lblBottom.text = theMeme.bottomText
        
        return cell
    }
}

