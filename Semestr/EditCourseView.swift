
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: EditCourseView.swift
// Description: Displays a various controls to change properties of each course
// Last modified on: April 19, 2016

import UIKit

final class EditCourseView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView! // The Table View instance for this View Controller
    
    var selectedCourse:Course! // A Course object instance
    let headerText:[String] = ["Name", "Location", "Room", "Day", "Start Time", "End Time", "Image"]
    
    /* ---- ViewController Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidLoad()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: This ViewController is initialized
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: textFieldShouldReturn()
    //
    //    Parameters:
    //    textField UITextField; An instance of a textfield object that called the function
    //
    //    Pre-condition: UITextFieldDelegate must be included as a part of this View Controller
    //    Post-condition: They software keyboard in iOS disappears
    //-----------------------------------------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: save()
    //
    //    Parameters:
    //    sender AnyObject; An instance of a generic object that called the function
    //
    //    Pre-condition: None
    //    Post-condition: Saves an edited Course object to the database
    //-----------------------------------------------------------------------------------------
    
    @IBAction func save(_ sender: AnyObject)
    {
        CoreData.app.save()
        
        // Only if information CAN be saved
        dismiss(animated: true, completion: nil)
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: exitView()
    //
    //    Parameters:
    //    sender AnyObject; An instance of a generic object that called the function
    //
    //    Pre-condition: None
    //    Post-condition: Closes and de-allocates the current view controller
    //-----------------------------------------------------------------------------------------
    
    @IBAction func exitView(_ sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    /* ---- UITableView Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: cellForRowAtIndexPath()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    indexPath NSIndexPath; A NSIndexPath object associated with the index of a tapped table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Adds a table cell into the table view with information for each cell
    //-----------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EditCell
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return headerText[section] }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: numberOfSectionsInTableView()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the number of sections of Courses from the database
    //-----------------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int { return headerText.count }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: numberOfRowsInSection()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    section Int; A tableview object associated with the view
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the number of rows to populate the tableview from the number of objects in an array
    //-----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: didReceiveMemoryWarning()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: This cleans up the ViewController when iOS gives 'low-memory' warning
    //-----------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

class EditCell : UITableViewCell
{
    @IBOutlet weak var textfield: UITextField!
}









