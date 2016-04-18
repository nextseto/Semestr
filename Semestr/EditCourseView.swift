
// Developer: Warren Seto
//      File: EditCourseView.swift
//   Purpose: Displays a various controls to change properties of each course

import UIKit

final class EditCourseView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCourse:Course!
    
    let headerText:[String] = ["Name", "Location", "Room", "Day", "Start Time", "End Time", "Image"]
    
    
    /* ---- ViewController Code ---- */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func save(sender: AnyObject)
    {
        var newData:[String?] = []
        
        // Parse all table cells and put them into newData
        
        print(newData)
        
        // Do the validation here before saving
        
        CoreData.app.save()
        
        // Only if information CAN be saved
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func exitView(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* ---- UITableView Code ---- */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("editCell") as! EditCell
        
        cell.textfield.delegate = self
        
        switch (indexPath.section)
        {
        case 0:
            cell.textfield.text = selectedCourse.name
            
        case 1:
            cell.textfield.text = selectedCourse.location
            
        case 2:
            cell.textfield.text = selectedCourse.room
            
        case 3:
            cell.textfield.text = selectedCourse.day
            
        case 4:
            cell.textfield.text = selectedCourse.startTime
        
        case 5:
            cell.textfield.text = selectedCourse.endTime
            
        case 5:
            cell.textfield.text = selectedCourse.imageName
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return headerText[section] }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return headerText.count }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

class EditCell : UITableViewCell
{
    @IBOutlet weak var textfield: UITextField!
}









