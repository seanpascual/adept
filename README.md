# DEP-Enrolment
DEP Enrolment Setup Screen

### Description & Overview  

**A Setup / Splash screen for DEP and user initiated Jamf Pro enrollments. Designed to run post enrollmnet. This is a template and will most likley need customisation to suit your requirements and enviroment.** 

**This project was created at Trams Ltd to aid our customers with zero touch deployment and is made available below for the benefit of the wider Mac admin community**

**We welcome feedback and feature requests from the community, these should be sent to oss@tramscloud.co.uk**

**If you would like to discuss our instalation/deployment/customisation/support services for this tool please email sales@tramscloud.co.uk**

#### A Quick Walkthough of how it Works  

1. Full screen splash is displayed allowing the user to enter there name, asset tag, choose a department and then begin the process (will not start if the text fields are left empty). This will scale to fit the screen size, will sit above all other windows and cannot be moved. By default cmd + q will quit the application but that can be changed and described later in this doument.  
2. Once the process has begun the user details will be submited to the Jamf server and a plist containing the details will be wirten to the "/Library/Application Support/JAMF" folder. The view will also update (note the plist and user details submition happen as asynchronous background processes).  
3. Once the new view has appeared a "jamf policy" will run with a custom event trigger (again this is a background process). The user will see some progress indicators that that update with ticks once completed. There is also a status label that shows the last entry in the jamf.log (The method used for the status label is from [Jason Tratta](https://github.com/jason-tratta))
4. Once the entire process has completed the view will update to indicate that the process has completed and a finish button is displayed.  
5. Clicking the finish button will close the current window and open a smaller one (not full screen and movable) whdih can display web content or pages. The below image shows the views and windows:  

![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/Overview.png?at=refs%2Fheads%2Fmaster)

### Requirements
---
Created with Xcode 9 and swift 4, Xcode 9 or higher required. While this tool may be uasble with other MDM's it was created for use with Jamf Pro, and we recomend running on the latest version or at least within the last 3 releases of Jamf Pro.

Tested and Supported Clients:

10.11 (El Capitan)  
10.12 (Sierra)  
10.13 (High Sierra)  

In the below documentation there will be refrences to line numbers within Xcode. By default line numbers are not shown in Xcode. To show them open Xcode Preferencs and click on the Text Editing tab, within that tab click Editing and then tick the Show Line Numbers check box.

### App Structure  
---
![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/structure.png?at=refs%2Fheads%2Fmaster)  

### Editing in Xcode
---
**Below are some of the basic changes that can be made, to list everything would take a lot of documentation!**  

Download and open the project in Xcode. The navigation pane on the left will list various files:

![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/xcodeStructure.png?at=refs%2Fheads%2Fmaster)  

The main files/ folders you will be working with are:

*HTML* - Folder: contains web pages  
*MainWindowController* - Swift Class  
*SourceViewController* - Swift Class  
*SecondViewController* - Swift Class  
*WebViewController* - Swift Class   
*info.plist* - plist  

#### HTML  

Pretty simple just remove the exiting content in the HTML Folder and drag & drop your own. In the import wizard make sure that Copy Items is checked.  

This is the contect that gets displayed in the WebView. It can also display hosted HTML content such a web pages, instead of using local content.  

#### MainViewController  

Subclass of NSWindowContoller. Used by MainWindow in the storyboard to set window size, level and apperance.  

To Change Window Size: (Note this have been designed to run using the full size of the main screen)  
Edit ```let percent: CGFloat = 1.0``` on line 40 of MainViewController.swift, where 1.0 = 100%, 0.5 = 50%  

To Change background colour:  
Edit ```window?.backgroundColor = NSColor.white``` on line 35 of MainViewController.swift, where white = colour (Black, Blue, Red, etc)  

#### SourceViewController  

Subclass of NSViewController & NSTextFieldDelegate. Used by the SourceView.  

Add/ remove departments:  

Edit ```department = ["Accounts", "Design", "Marketing", "Operations", "Sales", "Service"]``` on line 48 of SourceViewController.swift, change remove the department names within the quotes. You can add more entries just make sure to comma seperate them.  
**Note that the departments must exist within departments in your Jamf server**  

Modify Text Field constraints:  
These restrict the characters that can be typed in the text fields.  

Edit ```let characterSet: CharacterSet = CharacterSet(charactersIn:     "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-_").inverted``` and ```let alphaCharSet: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.").inverted```  on lines 59 & 60  
Characters listed are allowed, anything not listed is restricted. CharaterSet applies to the Asset Tag Field and alphaCharSet applies to the Username field.  

Empty Text Fields:  
If either text field is empty the app will not continue and an error message will be displayed, this will change the message in the error.  

Edit ```alert.messageText = "Missing Text Field Values"``` and/or ```alert.informativeText = "All Text Fields Must be Populated"```  
Change the text within the quotes.  

#### SecondViewController  

subclass of NSViewController. Used by the SecondView  

Custom Policy Trigger:  

Edit ```let appleScriptPolicy = NSAppleScript(source: "do shell script \"/usr/local/jamf/bin/jamf policy -event DEP \" with administrator " + "privileges")!.executeAndReturnError(nil)``` on line 86 change DEP after 'jamf policy -event' with your custom policy trigger name.  

Check Policy Receipt Time:  
How often policy receipts are checked, default is 8 seconds.  

Edit ```let timerInt = TimeInterval(8.0)``` on line 212 change 8.0 to amount os seconds reqiured.  

#### WebViewController  

subclass of NSViewController. Used by the WebView  

By default this is loading HTML content within the app. This can be changed to instead display a web page.  
To change this first comment out ```let htmlPage = Bundle.main.url(forResource: "index", withExtension: "html")``` and ```webView.mainFrame.load(URLRequest(url: htmlPage!))``` on lines 36 & 37 by placing // infront of them.  

You now need to remove the // from ```let url = NSURL (string: "https://tramscloud.co.uk")``` and  ```webView.mainFrame.load(URLRequest(url: url as! URL))``` on lines 40 & 41  

Now just change the URL in ```let url = NSURL (string: "https://tramscloud.co.uk")``` on line 40  


#### Stop cmd + q from quting the App   

We can use info.plist to make the application run as an agent. This stops is displaying in the dock or have a menu bar, which makes it very hard to close the app until its finished.  

Select info.plist and look for the 'Application is agent (UIElement)' property, change the value from NO to YES (is handy to have this set to NO while testing and debuging).  

#### Compile the App  

To Compile an app:  
1. With in Xcode click on the product menu and then click archive.  
2. The archive window will show you a list of builds and highlight your current build.  
3. On the right side of the window click the export button.  
4. Select Export as a macOS App and click next then choose a location to save and click export.  

### Usage with Jamf Pro  
---
Once you have customized and compiled the app it will need to packaged as a native Apple .pkg and uploaded to your Jamf distribution point(s).

We reccomend including the contents of the PKG Resources folder within your package. Included in this folder are a launcher script which checks if DEP-Enrolment apps has run previously and if it competed sucessfully, and a luanch agent used to run the app after package instalation and a postflight script to launch the screens after instalation.

Below is a example of the internal layout of the package  
![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/PackageLayout.png?at=refs%2Fheads%2Fmaster)  

##### Create Policy to Deploy DEP-Enrolment app  

1. Create a policy with the 'Enrolment Complete' trigger  
2. Add the DEP app package  
3. Scope to all computers or relivent smart group   

This will download and run the the DEP- app as root POST Enrollment, you should see something similar to the below:  

![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/View%201.png?at=refs%2Fheads%2Fmaster)  

##### Create Policy to check if DEP-Enrolment app completed (optional)
1. Create a policy with the 'Login' trigger
2. Run the script below
3. Scope to the same group at the DEP-Enrolment app policy above

```
#!/bin/bash -x
/Library/Application\ Support/JAMF/DEP-EnrolmentLauncher.sh
exit 0
```  

##### Create Policy(s) to Install and Configure  

This can done using just a single policy or spread accorss multipule, its down to preferance and amount/ conplexitly of software & configuration. In this example im going to use a single policy to keep things simple.  

1. Create a policy with the 'Custom' trigger. You can use any event name you like but by default the app will look for 'DEP'.  
2. Scope to all or a relivent smart group.  
3. We need to up date the installation progress screen during the installation, we do this using receipts. These receipts can be generated using scripts/ commands or delivered using packages. This example will use both.  
4. I have broken down the installation progess into 4 sections (these of course can all re-labled, if you just wanted to monitor apps you could change the labels to app names or developer names e.g. Adobe Applications):  
  * Applications  
  * UI Settings  
  * System Settings  
  * Security Settings  
5. Add packages & receipts to the policy. They need to be order correctly, this can easly be done but putting numbers or letters at the start of the package name e.g. 1-,2- or A-,B-.  Similar to the below example:  
  * A-InstallOffice2016.pkg  
  * B-InstallSlack.pkg  
  * C-InstallInDesign.pkg  
  * D-Applications.receipt.pkg (delivers the applications receipt, which will cause the installation progress to update)  
  * E-InstallWallpaper.pkg  
  * F-UISettings.receipt.pkg (delivers the uisettings receipt, which will cause the installation progress to update)  
  * G-InstallFonts.pkg  
  * H-SystemSettings.receipt.pkg (delivers the systemsettings receipt, which will cause the installation progress to update)  
  * I-InstallSophos.pkg  
  * J-OSXSecurityUpdate.pkg  
  * L-SecuritySettings.receipt.pkg (delivers the securitysettings receipt, which will cause the installation progress to update) 
 6. Add a script with priorty 'After' as below, this triggers with Finish button to be displayed 

 ```
#!/bin/bash
sudo touch "/Library/Application Support/JAMF/DEPSetupComplete.receipt"
exit 0
 ```   

Note: The receipts get cleaned once the finish button is pressed.  

![alt tag](https://git.tramscloud.co.uk/projects/XCOD/repos/dep-enrolment/raw/Screenshots/InstallProgress.png?at=refs%2Fheads%2Fmaster)  

  
