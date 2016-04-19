
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: BrowserView.swift
// Description: Displays a browser that can inject javascript to get semester data
// Last modified on: April 19, 2016

import UIKit
import WebKit

final class BrowserView: UIViewController, WKNavigationDelegate
{
    /* ---- Variables ---- */
    
    var tField: UITextField!
    var parseSite:String!
    var webView: WKWebView! // The WebKit Browser Instance
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    let loginPage = ["https://paws.tcnj.edu/psp/paws/?cmd=login&languageCd=ENG"]
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidLoad()
    //
    //    Parameters: None
    //
    //    Pre-condition: WKNavigationDelegate must be added to the View Controller
    //    Post-condition: This ViewController is initialized with a default URL or the PAWS login page
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = parseSite
        
        if (parseSite == "PAWS")
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: loginPage[0])!))
        }
        
        else
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://google.com")!))
        }
        
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: loadView()
    //
    //    Parameters: None
    //
    //    Pre-condition: WKNavigationDelegate must be added to the View Controller
    //    Post-condition: This initializes the iOS webkit browser with the View Controller
    //-----------------------------------------------------------------------------------------
    
    override func loadView()
    {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    //-----------------------------------------------------------------------------------------
    //
    //  Function: configurationTextField()
    //
    //    Parameters: 
    //    textField UITextField; An instance of a UITextField Object
    //
    //    Pre-condition: A textfield view object should be used in this View
    //    Post-condition: This initializes the text field for a popup with the View Controller
    //-----------------------------------------------------------------------------------------
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: save()
    //
    //    Parameters:
    //    sender AnyObject; An instance of a generic object that called the function
    //
    //    Pre-condition: WKNavigationDelegate must be added to the View Controller
    //    Post-condition: Parses PAWS, makes a new semester object and course objects into the database
    //-----------------------------------------------------------------------------------------
    
    @IBAction func save(sender: AnyObject)
    {
        webView.evaluateJavaScript("document.getElementById('ptifrmtgtframe').contentWindow.document.body.innerHTML")
        {
            (result, error) in
            
            let rawHTML = (result as! String).componentsSeparatedByString("\n")
            
            var pawsData:[[String]] =
                [
                    rawHTML.filter({ nil != $0.rangeOfString("PAGROUPDIVIDER") }).map({ line in line.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)}),
                    rawHTML.filter({ nil != $0.rangeOfString("win0divMTG_LOC") }).map({ line in line.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)}),
                    rawHTML.filter({ nil != $0.rangeOfString("win0divMTG_SCHED") }).map({ line in line.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)})
            ]

            let alert = UIAlertController(title: "Enter a name for this semster:", message: "", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:
            {
                (UIAlertAction) in

                CoreData.app.addNewSemester(self.tField.text!)
                
                let selectedSemester = CoreData.app.getSemester(self.tField.text!)
                
                for count in 0..<pawsData[0].count
                {
                    CoreData.app.addNewCourse(semester: selectedSemester, pawsData[0][count], pawsData[1][count], "", pawsData[0][count], pawsData[2][count], "", self.days[Int(arc4random_uniform(5))])
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
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

