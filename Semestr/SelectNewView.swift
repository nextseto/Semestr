
// Developer: Warren Seto
//      File: SelectNewView.swift
//   Purpose: Displays a selection of options to input new semester data

import UIKit

final class SelectNewView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    let pictureArray:[String] = ["PAWS"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("picCell") as! PictureCell

        cell.picture.image = UIImage(named: pictureArray[indexPath.row])
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return pictureArray.count }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

class PictureCell : UITableViewCell
{
    @IBOutlet weak var picture: UIImageView!
}