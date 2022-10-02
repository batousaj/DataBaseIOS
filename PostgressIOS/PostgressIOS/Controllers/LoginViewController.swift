//
//  LoginViewController.swift
//  PostgressIOS
//
//  Created by Thien Vu on 02/10/2022.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFaceBookLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = AccessToken.current,
                !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            self.switchToMainView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupFaceBookLogin() {
        let loginFacebook = FBLoginButton()
        loginFacebook.permissions = ["email","public_profile"]
        loginFacebook.center = self.view.center
        loginFacebook.delegate = self
        self.view.addSubview(loginFacebook)
    }
    
}

extension LoginViewController : FBSDKLoginKit.LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Login with facebook successed with profile")
        
        DispatchQueue.main.async {
            self.switchToMainView()
        }
        
        let token = result?.token?.tokenString
        let authen_token = result?.authenticationToken?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "name, email"], tokenString: token, httpMethod: "GET", flags: .disableErrorRecovery)
        
        request.start { connecting, results, error in
            if let error = error {
                print("Get info in profile failed with \(error.localizedDescription)")
                return
            }
            
            print("results \(String(describing: results as? [String : Any]))")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        print("LoginButtonDidLogOut")
    }
    
}

extension LoginViewController {
    
    func switchToMainView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "com.softfoundry.PostgressIOS.PostgressIOS"))
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        let navigator = UINavigationController(rootViewController: vc)
        self.view.window?.rootViewController = navigator
        self.view.window?.makeKeyAndVisible()
    }
}
