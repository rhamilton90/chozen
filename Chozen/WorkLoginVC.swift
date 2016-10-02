//
//  RegisterVC.swift
//  AppX
//
//  Created by HamiltonMac on 6/29/16.
//  Copyright © 2016 HamiltonMac. All rights reserved.
//

import UIKit

class WorkLoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: CustomTextField!
    
    @IBOutlet weak var passwordTF: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.delegate = self
        passwordTF.delegate = self
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            
            self.passwordTF.becomeFirstResponder()
            
        } else if textField == passwordTF {
            
            passwordTF.resignFirstResponder()
        }
        //self.view.endEditing(true)
        return false
    }

}
