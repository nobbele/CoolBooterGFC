import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var LogText: NSTextField!
    @IBOutlet weak var iOSVersion: NSTextField!
    @IBOutlet weak var IPAddress: NSTextField!
    var CommandToBeRun: String = String()
    @IBAction func BootMe(_ sender: Any) {
        if(dialogOKCancel(question:"Boot?", text: "This is gonna boot up your secondary OS, it may take a while")) {
            if (IPAddress.stringValue != "") {
                LogText.stringValue = "Booting second OS!"
                dialog(text: "!!Important!!\nWait 10 seconds after pressing OK before locking device! then wait another 10 seconds before unlocking\nApp may appear frozen after you press OK, but don't worry, wait until your iDevice has booted and then force quit this application")
                print("Booting second OS!")
                
                CommandToBeRun = "coolbootercli -b"
                print("Connecting to", IPAddress.stringValue)
                // SSH stuff
                print(self.CommandToBeRun.RunOnSSH(ip: self.IPAddress.stringValue, user: "root"))
                LogText.stringValue = "Finished"
            } else {
                dialog(text: "Please input a value in IP Address text field")
            }
        }
    }
    @IBAction func InstallMe(_ sender: Any) {
        if (dialogOKCancel(question: "Install?", text: "This will install " + iOSVersion.stringValue)) {
            if (IPAddress.stringValue != "" && iOSVersion.stringValue != "") {
                LogText.stringValue = "Installing " + iOSVersion.stringValue
                dialog(text: "App may appear frozen after you press OK, but don't worry, wait until you iDevice has rebooted")
                print("Installing", iOSVersion.stringValue)
                
                CommandToBeRun = "coolbootercli " + iOSVersion.stringValue
                print("Connecting to", IPAddress.stringValue)
                // SSH stuff
                print(self.CommandToBeRun.RunOnSSH(ip: self.IPAddress.stringValue, user: "root"))
                LogText.stringValue = "Finished"
            } else {
                dialog(text: "Please input a value in both IP Address and iOS version text field")
            }
        }
    }
    @IBAction func UninstallMe(_ sender: Any) {
        if (dialogOKCancel(question: "Install?", text: "This will uninstall your secondary OS")) {
            if (IPAddress.stringValue != "") {
                LogText.stringValue = "Uninstalling secondary OS"
                dialog(text: "App may appear frozen after you press OK, but don't worry it's not, wait until it unfreezes before quitting")
                print("Uninstalling secondary OS")
                
                CommandToBeRun = "coolbootercli -u"
                print("Connecting to", IPAddress.stringValue)
                // SSH stuff
                print(self.CommandToBeRun.RunOnSSH(ip: self.IPAddress.stringValue, user: "root"))
                LogText.stringValue = "Finished"
            } else {
                dialog(text: "Please input a value in IP Address textfield")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == NSAlertFirstButtonReturn
    }
    func dialog(text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
}

extension String {
    /*func RunAsCommand() -> String {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        }
        else {
            return "--- Error running command - Unable to initialize string from file data ---"
        }
    }*/
    func RunOnSSH(ip: String, user: String) -> String{
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"ssh %@@%@ \"%@\"", user, ip, self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        task.waitUntilExit()
        /*if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        }*/
        guard let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) else {
            return "--- Error running command - Unable to initialize string from file data ---"
        }
        return result as String
    }
}

