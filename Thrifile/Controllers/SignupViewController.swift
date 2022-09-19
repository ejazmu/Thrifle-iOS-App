//
//  SignupViewController.swift
//  Thrifile
//
//  Created by Asad Hussain on 11/07/2022.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var fld_UserName : UITextField!
    @IBOutlet weak var fld_Email : UITextField!
    @IBOutlet weak var fld_PhoneNumber : UITextField!
    @IBOutlet weak var fld_Password : UITextField!
    @IBOutlet weak var fld_ConfirmPassword : UITextField!



    @IBAction func btnActionBack(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionSignup(_ sender : Any) {
        if valid(){
            func_Perform_Signup()
        }
    }
    
    @IBAction func btnActionOpenTermsLink(_ sender : Any) {
        openUrl(urlString: "https://www.thrifle.com/terms-conditions")
    }

    func func_Perform_Signup(){
        UserManager.shared.signupManagerfunc(phone_number: "", email: self.fld_Email.text ?? "", password: self.fld_Password.text ?? "", username: self.fld_UserName.text ?? "") { (status, User) in
            if status {
                showSuccessMessage(message: NSLocalizedString("You have been registered", comment: ""))
                User.save()
                self.changeApplicationRoot()
            }
        }
    }

    func changeApplicationRoot(){
        self.navigationController?.popToRootViewController(animated: true)

//        let vc = StoryboardRef.mainSB.instantiateViewController(identifier: "MainSBNavigation") as! UINavigationController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let scene = UIApplication.shared.connectedScenes.first{
//            guard let windwosScene = (scene as? UIWindowScene) else {return}
//            let window: UIWindow = UIWindow(frame: windwosScene.coordinateSpace.bounds)
//            window.windowScene = windwosScene
//            window.rootViewController = vc
//            window.makeKeyAndVisible()
//            appDelegate.window = window
//        }
    }


    func valid() -> Bool{
        if self.fld_UserName.text!.isEmpty{
            self.fld_UserName.shake()
            return false
        }
        
        if self.fld_Email.text!.isEmpty{
            self.fld_Email.shake()
            return false
        }
        
        if self.fld_Password.text!.isEmpty{
            self.fld_Password.shake()
            return false
        }

        if self.fld_ConfirmPassword.text!.isEmpty{
            self.fld_ConfirmPassword.shake()
            return false
        }
        
        if self.fld_Password.text != self.fld_ConfirmPassword.text {
            self.fld_Password.shake()
            self.fld_ConfirmPassword.shake()
            return false
        }

        return true
    }

}
