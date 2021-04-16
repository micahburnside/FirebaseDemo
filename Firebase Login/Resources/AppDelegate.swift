//
//  AppDelegate.swift
//  Firebase Login
//
//  Created by Micah Burnside on 4/12/21.
//

import UIKit
import GoogleSignIn
import Firebase

@UIApplicationMain
// Google Sign In Delegate is subclassed as "GIDSignInDelegate//
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs //
        FirebaseApp.configure()
        // Grabs the App's client ID //
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // Sets Google Sign In Delegate
        GIDSignIn.sharedInstance().delegate = self
        // Checks if user exists and if previous sign in session exists
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        return true
    }
    
    // Google Sign In with Google user account //
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Firebase Authentication //
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Authenticate with Firebase using the credential object //
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                print("\(authResult)")
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}


