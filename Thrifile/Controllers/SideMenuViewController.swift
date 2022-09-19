//
//  SideMenuViewController.swift
//  Thrifile
//
//  Created by Asad Hussain on 11/08/2022.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var signinView : UIView!
    @IBOutlet weak var signOutView : UIView!
    @IBOutlet weak var deleteUserView : UIView!
    @IBOutlet weak var adminMainView : UIView! {
        didSet {
            adminMainView.isHidden = true
        }
    }


    @IBOutlet weak var switchControl : UISwitch!

    @IBAction func btnActionBack(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchControl.isOn = !AppConstants.isListView
        switchControl.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)

        if let user = UserModel.currentUser() {
            signinView?.isHidden = true
            if user.isAdmin {
                adminMainView.isHidden = false
            }
        } else {
            signOutView?.isHidden = true
            deleteUserView?.isHidden = true
        }

    }
    
    

    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        if value {
            AppConstants.isListView = false
        } else {
            AppConstants.isListView = true
        }
    }

    @IBAction func btnActionSignOut(_ sender : Any) {
        logoutOption()
    }

    @IBAction func btnActionDeleteAccount(_ sender : Any) {
        deleteAccountOption()
    }
    
    
    func deleteAccountOption() {
        let refreshAlert = UIAlertController(title: "Delete Account", message: NSLocalizedString("All of your deals and data will be lost. Are you sure you want to continue?", comment: ""), preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            self.func_DeleteAccount()
        }))

        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func btnActionGotoUpdateLogo(_ sender : Any) {
        let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "SelectLogoViewController") as! SelectLogoViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    @IBAction func btnActionContactUs(_ sender : Any) {
        let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    @IBAction func btnActionLogin(_ sender : Any) {
        let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnActionPrivacyPolicy(_ sender : Any) {
        openUrl(urlString: "https://www.thrifle.com/privacy-policy")
    }
    
    @IBAction func btnActionTermsAndConditions(_ sender : Any) {
        openUrl(urlString: "https://www.thrifle.com/terms-conditions")

    }


    
    func logoutOption() {
        let refreshAlert = UIAlertController(title: "", message: NSLocalizedString("Are you sure?", comment: ""), preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            self.func_Logout()
        }))

        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func func_Logout(){
        if let user = UserModel.currentUser() {
            user.clear()
        }
        
        self.dismiss(animated: false, completion: {
            self.navigationController?.popToRootViewController(animated: true)
//            let vc = StoryboardRef.mainSB.instantiateViewController(identifier: "FirstNav") as! UINavigationController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            if let scene = UIApplication.shared.connectedScenes.first{
//                guard let windwosScene = (scene as? UIWindowScene) else {return}
//                let window: UIWindow = UIWindow(frame: windwosScene.coordinateSpace.bounds)
//                window.windowScene = windwosScene
//                window.rootViewController = vc
//                window.makeKeyAndVisible()
//                appDelegate.window = window
//            }
        })
    }
    
    func func_DeleteAccount(){
        UserManager.shared.deleteAccount { status in
            if status {
                if let user = UserModel.currentUser() {
                    user.clear()
                }
                
                self.dismiss(animated: false, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }

}
