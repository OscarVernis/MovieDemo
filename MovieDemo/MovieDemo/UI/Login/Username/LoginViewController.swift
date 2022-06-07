//
//  LoginViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

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
    var didFinishLoginProcess: (() -> Void)? = nil
    
    var loginViewModel = LoginViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        subscribeToPublishers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    fileprivate func setup() {
        closeButton.isHidden = !showsCloseButton
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
    
//MARK: - View Model
extension LoginViewController {
    fileprivate func subscribeToPublishers() {
        loginViewModel.$loggedIn
            .sink { [weak self] loggedIn in
                if loggedIn {
                    self?.didFinishLoginProcess?()
                }
            }
            .store(in: &cancellables)
        
        loginViewModel.$isLoading
            .sink { [weak self] isLoading in
                self?.updateUI(isLoading)
            }
            .store(in: &cancellables)
        
        loginViewModel.$errorString
            .sink { [weak self] errorString in
                self?.handleError(errorString)
            }
            .store(in: &cancellables)
        
        loginViewModel.$validInput
            .assign(to: \.isEnabled, on: loginButton!)
            .store(in: &cancellables)
    }
    
    fileprivate func updateUI(_ isLoading: Bool) {
        if isLoading {
            loginButton.isEnabled = false
            loginButton.titleLabel?.alpha = 0
            activityIndicator.isHidden = false
        } else {
            self.loginButton.titleLabel?.alpha = 1
            self.activityIndicator.isHidden = true
        }
    }
    
    fileprivate func handleError(_ errorString: String?) {
        if errorString != nil {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            userTextField.text = ""
            passwordTextField.text = ""
        }
        
        errorLabel.text = errorString
        errorLabel.isHidden = (errorString == nil)
    }
    
    fileprivate func validateInput() {
        loginViewModel.validateInput(username: userTextField.text, password: passwordTextField.text)
    }
    
    fileprivate func handlelogin() {
        guard loginViewModel.validInput else { return }
        
        loginViewModel.login(username: userTextField.text!, password: passwordTextField.text!)
    }
    
}

//MARK: - Actions
extension LoginViewController {
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        handlelogin()
    }
    
    @IBAction func textFieldUpdated(_ sender: Any) {
        loginViewModel.resetError()
        validateInput()
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
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Return in userTextField moves to passwordTextField
        if textField === userTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        //Return in passwordTextField logins
        if textField === passwordTextField {
            handlelogin()
        }
        
        return true
    }
    
}

//MARK: - Keyboard animation
extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { keyboardSize in
            let padding: CGFloat = 12
            self.bottomConstraint.constant = keyboardSize.height + padding
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
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            self.view?.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
}
