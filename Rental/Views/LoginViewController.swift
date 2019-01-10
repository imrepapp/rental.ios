//
//  LoginViewController.swift
//  PreEMRLite_01
//
//  Created by Krisztián KORPA on 2018. 12. 13..
//  Copyright © 2018. Krisztián KORPA. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.orange.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


class LoginViewController : UIViewController {
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LoginToConfigSelectorShow") {
            (segue.destination as! ConfigSelectorViewController).configs = [:]
        }
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: IBAction
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login button pressed")
        print("username \(emailTextField!)")
        print("password \(passwordTextField!)")
        performSegue(withIdentifier: "LoginToConfigSelectorShow", sender: self)
        //performSegue(withIdentifier: "LoginToMenuShow", sender: self)
    }
    
    
}

