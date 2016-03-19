
// Developer: Warren Seto
//      File: SemesterView.swift
//   Purpose: Displays a list of all semesters

import UIKit
import CoreData

class SemesterView: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableArray:[Semester] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableArray = CoreData.app.getAllSemesters()
        
        
        
    }
    
    
    
    
    
    @IBAction func createObject(sender: AnyObject)
    {
        CoreData.app.addNewSemester("Spring 2016")
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let view = storyboard!.instantiateViewControllerWithIdentifier("EditSemesterView") as! EditSemesterView
        view.selectedSemester = tableArray[indexPath.row]
        navigationController?.pushViewController(view, animated: true)
        
        print(tableArray[indexPath.row].name)
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SemesterCell")!
        
        tablecell.textLabel?.text = tableArray[indexPath.row].name
        
        return tablecell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableArray.count }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

