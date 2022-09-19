//
//  ContactUsViewController.swift
//  Thrifile
//
//  Created by Asad Hussain on 08/08/2022.
//

import UIKit

class ContactUsViewController: UIViewController {

    
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var messageField : UITextView! {
        didSet {
            messageField.placeholder = "What can we help you with?"
        }
    }

    @IBAction func btnActionBack(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnActionSubmmit(_ sender : Any) {
        if validate() {
            self.contactUsMessage()
        }
    }
    
    
    func validate() -> Bool {
        
        if self.nameField.text!.isEmpty{
            self.nameField.shake()
            return false
        }
        
        if self.emailField.text!.isEmpty{
            self.emailField.shake()
            return false
        }
        

        return true
    }
    
    func contactUsMessage() {
        UserManager.shared.contactUS(name: nameField.text!, email: emailField.text!, message: messageField.text!) { (status) in
            if status {
                showSuccessMessage(message: "Your message has been sent!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
