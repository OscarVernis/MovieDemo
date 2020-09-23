//
//  LoginViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private let bottomConstraintDefault: CGFloat = 200

    var showsCloseButton: Bool = true
    var didFinishLoginProcess: ((Bool) -> Void)? = nil
    
    var isLoading = false {
        didSet {
            updateUI()
        }
    }
    
    //MARK:- Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setup() {
        closeButton.isHidden = !showsCloseButton
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func updateUI() {
        if isLoading {
            loginButton.isEnabled = false
            loginButton.titleLabel?.alpha = 0
            activityIndicator.isHidden = false
        } else {
            self.loginButton.titleLabel?.alpha = 1
            self.activityIndicator.isHidden = true
        }
    }
    
    fileprivate func handlelogin() {
        isLoading = true
        
        SessionManager.shared.login(withUsername: userTextField.text!, password: passwordTextField.text!) { [weak self] error  in
            guard let self = self else { return }
            
            self.isLoading = false

            if error == nil {
                self.didFinishLoginProcess?(true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                
                self.userTextField.text = ""
                self.passwordTextField.text = ""

                self.errorLabel.isHidden = false
                if let error = error?.asAFError, error.responseCode == 401 {
                    self.errorLabel.text = "Invalid username and/or password."
                } else {
                    self.errorLabel.text = "Login error. Please try again."
                }
            }
        }
        
    }

    //MARK:- Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        handlelogin()
    }
    
    @IBAction func textFieldUpdated(_ sender: Any) {
        let valid =  !(userTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true)
        loginButton.isEnabled = valid
        errorLabel.isHidden = true
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let url = URL(string: "https://www.themoviedb.org/signup")!
        UIApplication.shared.open(url)
    }
    
    //MARK:- Keyboard animation
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { keyboardSize in
            self.bottomConstraint.constant = keyboardSize.height + 12
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { keyboardSize in
            self.bottomConstraint.constant = self.bottomConstraintDefault
        }
    }
    
    func animateWithKeyboard(notification: NSNotification, animations: ((_ keyboardFrame: CGRect) -> Void)?) {
           // Extract the duration of the keyboard animation
           let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
           let duration = notification.userInfo![durationKey] as! Double
           
           // Extract the final frame of the keyboard
           let frameKey = UIResponder.keyboardFrameEndUserInfoKey
           let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
           
           // Extract the curve of the iOS keyboard animation
           let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
           let curveValue = notification.userInfo![curveKey] as! Int
           let curve = UIView.AnimationCurve(rawValue: curveValue)!

           // Create a property animator to manage the animation
           let animator = UIViewPropertyAnimator(
               duration: duration,
               curve: curve
           ) {
               // Perform the necessary animation layout updates
               animations?(keyboardFrameValue.cgRectValue)
               
               // Required to trigger NSLayoutConstraint changes
               // to animate
               self.view?.layoutIfNeeded()
           }
           
           // Start the animation
           animator.startAnimation()
       }
   }
    
