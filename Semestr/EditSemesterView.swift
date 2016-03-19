
// Developer: Warren Seto
//      File: EditSemesterView.swift
//   Purpose: Displays a list of classes from collected semester data

import UIKit

class EditSemesterView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var selectedSemester:Semester!
    var tableArray:[Day] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = selectedSemester.name
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        
        
        
        //tableArray = selectedSemester.days?.allObjects as! [Day]
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print(tableArray[indexPath.row].name)
        
        
        
        
        
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("DayCell")!
        
        
        return tablecell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableArray.count }
}
