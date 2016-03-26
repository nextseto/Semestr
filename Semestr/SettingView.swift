// Developer: Warren Seto
//      File: SettingView.swift
//   Purpose: Displays a page to configure settings for the application

import UIKit

class SettingView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (section == 0)
        {
            return "Schedule"
        }
        
        else if (section == 1)
        {
            return "Feedback"
        }
            return ""
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if (section == 1)
        {
            return "Semestr will never interrupt you for ratings."
        }
            return ""
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 3 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0, 1:
                return 2
            case 2:
                return 1
            default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell")! as UITableViewCell
        
        switch (indexPath.section)
        {
            case 0:
                if (indexPath.row == 0)
                {
                    cell.textLabel?.text = "All Semesters"
                }
                else
                {
                    cell.textLabel?.text = "Add Semesters"
                }
            case 1:
                if (indexPath.row == 0)
                {
                    cell.textLabel?.text = "Send Feedback"
                }
                else
                {
                    cell.textLabel?.text = "Please Rate Semestr"
                }
            case 2:
                cell.textLabel?.text = "About"
            
            default: break
        }

        
        return cell
    }
    
    @IBAction func closeViewController(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

