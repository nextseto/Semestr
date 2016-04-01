// Developer: Warren Seto
//      File: SettingView.swift
//   Purpose: Displays a page to configure settings for the application

import UIKit

final class SettingView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    /* ---- Variables ---- */
    
    let headerText:[String] = ["Schedule", "Feedback", ""],
        mainText:[[String]] = [["All Semester", "Add Semester"], ["Send Feedback", "Please Rate Semestr"], ["About"]],
        footerText:[String] = ["", "Semestr will never interrupt you for ratings.", ""]
    
    /* ---- ViewController Code ---- */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func closeViewController(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /* ---- UITableView Code ---- */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch (indexPath.section)
        {
            case 0:
                if (indexPath.row == 0)
                {
                    navigationController?.pushViewController(storyboard.instantiateViewControllerWithIdentifier("SemesterView"), animated: true)
                }
                else
                {
                    print("Add Semester")
                    
                    CoreData.app.addNewSemester("Spring 201\(arc4random_uniform(9) + 0)")
                    
                }
            case 1:
                if (indexPath.row == 0)
                {
                    print("Send Feedback")
                }
                else
                {
                    print("Please Rate Semestr")
                }
            case 2:
                print("About")

            default: break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("nameCell")!
        
        cell.textLabel?.text = mainText[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return headerText[section]}
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? { return footerText[section] }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return mainText.count }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return mainText[section].count }
}

