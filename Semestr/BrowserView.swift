
// Developer: Warren Seto
//      File: BrowserView.swift
//   Purpose: Displays a browser that can inject javascript to get semester data

import UIKit
import WebKit

final class BrowserView: UIViewController, WKNavigationDelegate
{
    
    var parseSite:String!
    
    var webView: WKWebView!
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        navigationItem.title = parseSite
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://paws.tcnj.edu/psp/paws/?cmd=login&languageCd=ENG")!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView()
    {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
      var tField: UITextField!
    
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

            print("-------------------------")
            
            for count in 0..<pawsData[0].count
            {
                for count2 in 0..<pawsData.count
                {
                    print(pawsData[count2][count])
                }
                print("-------------")
            }
            
            print("-------------------------")
            
            
            
            
            
            
            
            
            
            
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
    

    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

