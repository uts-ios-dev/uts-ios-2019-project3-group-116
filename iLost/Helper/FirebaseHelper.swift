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

//Resource Firebase https://firebase.google.com/docs/database/ios/start?authuser=0

class FirebaseHelper {

    var uid:String?
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
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let riversRef = storageRef.child("userProfile/\(user.username).jpg")
            _ = riversRef.putData((user.image?.pngData())!, metadata: nil) { (metadata, error) in
//                guard let metadata = metadata else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
                // Metadata contains file metadata such as size, content-type.
                //_ = metadata.size
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard url != nil else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    user.imageURL = "\(url)"
                }
            }
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
         self.uid = Auth.auth().currentUser?.uid
    }

    func loadUserProfile(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            let address = value?["address"] as? String ?? ""
            let postcode = value?["postcode"] as? String ?? ""
            let city = value?["city"] as? String ?? ""

            let user = UserModel(name: name, surname: surname, username: username, email: email, phone: phone, address: address, postcode: postcode, city: city, image: nil)
            self.delegateLoadedProfile?.userProfile(user: user)
            print("Profile Data loaded successful")
        })
            { (error) in
            print(error.localizedDescription)
        }
    }

    func saveUserProfile(values: [String:String]){
        let ref = Database.database().reference()
        guard let key = Auth.auth().currentUser?.uid else { return }
        let childUpdates = ["/users/\(key)": values]
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                return
            }
            print("Profile Data updatet successful")
        })
    }

    func saveItemDescription(item: ItemModel){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values = item.getValues()
        values["User"] = uid
        let child = Database.database().reference().root.child("items").childByAutoId()
        child.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                return
            }
            print("success update DB")
            self.delegateCreatedUser?.userCreated()
        })

        let locations = item.getLocations()
        for index in locations.indices {
            child.child("locations").child("Location \(index)").updateChildValues(locations[index], withCompletionBlock: {
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

    func saveImage(data: Data, item: String, fileName: String ){
        guard let uid = uid else { return }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images").child(uid).child(item)
        let spaceRef = imagesRef.child(fileName)
        let _ = spaceRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else { return }
            if let error = error {
                print("Failed Image Upload: ", error.localizedDescription)
                return
            }
        }
    }

    func downloadImage(item: String, fileName: String) {
        guard let uid = uid else { return }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images").child(uid).child(item)
        let spaceRef = imagesRef.child(fileName)
        // You can also access to download URL after upload.
        spaceRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed Image Upload: ", error.localizedDescription)
                return
            } else {
                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
            }
        }
    }

    func logOutUser(){
        do{
            try Auth.auth().signOut()
        }
        catch {
            print("error logout")
        }
    }

    func getUserName() -> String? {
        guard let username = Auth.auth().currentUser?.displayName else { return nil }
        return username
    }
}
