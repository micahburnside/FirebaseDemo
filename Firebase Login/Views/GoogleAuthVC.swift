//
//  GoogleAuthVC.swift
//  Firebase Login
//
//  Created by Micah Burnside on 4/12/21.
//

import UIKit
import GoogleSignIn
import Firebase

class GoogleAuthVC: UIViewController {
    // Connects Storyboard View to GoogleAuthVC.swift and creates Google sign in button //
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func signOutPressed(_ sender: UIButton) {
       // Sign Out User //
       // Check if user exists //
      /// Check for a current Firebase session.
        let user = Firebase.Auth.auth().currentUser
        if user != nil {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("signed out successfully")
            self.alertUserSignedOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var googleSignInTableViewCell: UITableViewCell!
    // Text Constant for "Sign Out" Table View Cell //
    let data = ["Sign Out"]
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Google Sign In View Controller //
        // Presents the Google sign in View Controller. //
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Checks Firebase for existing sign in sessions. //
        //Restores sign in sessin if previous sign in session exists. //
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Loads and handles Table Views
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        // removes tableview cell lines //
        tableView.tableFooterView = UIView()
    }
}
// Sign out User using Table Views //
extension GoogleAuthVC: UITableViewDelegate, UITableViewDataSource {
    // Action Sheet that alerts the user they are signed in //
    func alertUserSuccessfullySignedIn() {
        let alert = UIAlertController(title: "Signed In", message: "Successfully signed in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    // Action Sheet that alerts the user they are signed out //
    func alertUserSignedOut() {
        let alert = UIAlertController(title: "Signed Out", message: "Successfully signed out", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            guard self != nil else {
                return
            }
            // Sign Out //
            if Firebase.Auth.auth().currentUser != nil {
            do {
                try FirebaseAuth.Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                print("Signed out successfully")
                self?.alertUserSignedOut()
            }
            catch {
                print("Failed to log out")
            }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Present ction Sheet - Sign Out //
        present(actionSheet, animated: true)
    }
}






