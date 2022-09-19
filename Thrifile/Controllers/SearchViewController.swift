//
//  SearchViewController.swift
//  Thrifile
//
//  Created by Asad Hussain on 11/08/2022.
//

import UIKit

protocol didAddTextForSearch {
    func textForSearchAdded(text : String)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var txtField : UITextField!
    var delegate : didAddTextForSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAcionDismiss(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidEndEditing(_ textField : UITextField) {
        if !textField.text!.isEmpty {
            delegate?.textForSearchAdded(text: textField.text!)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
