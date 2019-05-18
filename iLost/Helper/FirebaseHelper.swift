//
//  FirebaseHelper.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseSignInDelegate {
    func SignedIn()
}
protocol FirebaseCreateUserDelegate {
    func userCreated()
}

protocol FirebaseLoadedProfileDelegate {
    func userProfile(user: UserModel)
}

//Resource Firebase https://www.youtube.com/watch?v=76ANW9VJwCQ

class FirebaseHelper {

    var delegateSignIn: FirebaseSignInDelegate?
    var delegateCreatedUser: FirebaseCreateUserDelegate?
    var delegateLoadedProfile: FirebaseLoadedProfileDelegate?

    func createUser(user: UserModel, password: String) {
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("Failed to register: ", error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else { return }
            let values = user.getValues()
            Database.database().reference().root.child("users").child(uid).updateChildValues(values, withCompletionBlock: {
                (error, ref) in
                if let error = error {
                    print("Failed to update DB: ", error.localizedDescription)
                    return
                }
                print("success update DB")
                self.delegateCreatedUser?.userCreated()
            })
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to Login: ", error.localizedDescription)
                return
            }else{
                print("signed in")
                self.delegateSignIn?.SignedIn()
            }
        }
    }

    func loadUserProfile(){
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            let address = value?["address"] as? String ?? ""
            let postcode = value?["postcode"] as? String ?? ""
            let city = value?["city"] as? String ?? ""

            let user = UserModel(name: name, surname: surname, username: username, email: email, phone: phone, address: address, postcode: postcode, city: city)
            self.delegateLoadedProfile?.userProfile(user: user)
            print("Profile Data loaded successful")
        })
            { (error) in
            print(error.localizedDescription)
        }
    }

    func saveUserProfile(user: UserModel){
        let ref = Database.database().reference()
        guard let key = Auth.auth().currentUser?.uid else { return }
        let childUpdates = ["/users/\(key)": user.getValues()]
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                return
            }
            print("Profile Data updatet successful")
        })
    }
}
