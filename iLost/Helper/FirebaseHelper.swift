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
    func SignedIn(success: Bool)
}
protocol FirebaseCreateUserDelegate {
    func saved(success: Bool, errorMessage: String)
}

protocol FirebaseLoadedProfileDelegate {
    func userProfile(user: UserModel)
}

protocol FirebaseLoadedItemsDelegate {
    func getItemModels(items: [ItemModel])
}

//Resource Firebase https://firebase.google.com/docs/database/ios/start?authuser=0

class FirebaseHelper {

    var uid:String?
    var delegateSignIn: FirebaseSignInDelegate?
    var delegateCreatedUser: FirebaseCreateUserDelegate?
    var delegateLoadedProfile: FirebaseLoadedProfileDelegate?
    var delegateloadedItems: FirebaseLoadedItemsDelegate?
    
    func createUser(user: UserModel, password: String) {
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("Failed to register: ", error.localizedDescription)
                self.delegateCreatedUser?.saved(success: false, errorMessage: error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else { return }
            var values = user.getValues()
            if let image = user.image {
                self.saveImage(image: image, folderName: "userProfile", fileName: "\(user.name) \(user.surname)") { url in
                    if let url = url {
                        user.imageURL = "\(url)"
                        values["imageURL"] = user.imageURL
                    }
                    self.insertUser(uid: uid, values: values)
                }
            } else {
                self.insertUser(uid: uid, values: values)
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to Login: ", error.localizedDescription)
                self.delegateSignIn?.SignedIn(success: false)
                return
            }else{
                print("signed in")
                self.delegateSignIn?.SignedIn(success: true)
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
            let imageUrl = value?["imageURL"] as? String ?? ""

            let user = UserModel(name: name, surname: surname, username: username, email: email, phone: phone, address: address, postcode: postcode, city: city, image: nil, imageURL: imageUrl)
            self.delegateLoadedProfile?.userProfile(user: user)
            print("Profile Data loaded successful")
        })
            { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadLostItems(){
        var items = [ItemModel]()
        Database.database().reference().child("items").observe(.value, with: { (snapshot) in
            if let test = snapshot.value as? [String:AnyObject] {
                for child in test {
                    let value = child.value as? NSDictionary
                    let title = value?["title"] as? String ?? ""
                    let description = value?["description"] as? String ?? ""
                    let category = value?["category"] as? String ?? ""
                    let dateLost = value?["dateLost"] as? String ?? ""
                    let dateFound = value?["dateFound"] as? String ?? ""
                    if dateFound == "" {
                        let item = ItemModel(title: title, description: description, category: category, dateLost: dateLost, dateFound: dateFound, images: nil, imagesURL: [])
                        items.append(item)
                    }
                }
            }
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
    
    func insertUser(uid: String, values: [String:String]) {
        Database.database().reference().root.child("users").child(uid).updateChildValues(values, withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                self.delegateCreatedUser?.saved(success: false, errorMessage: error.localizedDescription)
                return
            }
            print("success update DB")
            self.delegateCreatedUser?.saved(success: true, errorMessage: "")
        })
    }

    func saveItemDescription(item: ItemModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values = item.getValues()
        values["User"] = uid
        var itemId = ""
        
        let child = Database.database().reference().root.child("items").childByAutoId()
        child.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                self.delegateCreatedUser?.saved(success: false, errorMessage: error.localizedDescription)
                return
            }
            print("success update DB")
            self.delegateCreatedUser?.saved(success: true, errorMessage: "")
            
            if let key = ref.key {
                itemId = key
            }
        })
        
        if let images = item.images, let title = item.title, let cat = item.category  {
            var i = 1
            var urls = [String]()
            for image in images {
                saveImage(image: image, folderName: "itemImages", fileName: "\(title)-\(cat)-\(i)") { url in
                    if let imageUrl = url {
                        urls.append("\(imageUrl)")
                        values["imagesURL"] = urls
                    }
                    self.updateItem(uid: itemId, values: values)
                }
                i+=1
            }
        }

        let locations = item.getLocations()
        for index in locations.indices {
            child.child("locations").child("Location \(index)").updateChildValues(locations[index], withCompletionBlock: {
                (error, ref) in
                if let error = error {
                    print("Failed to update DB: ", error.localizedDescription)
                    self.delegateCreatedUser?.saved(success: false, errorMessage: error.localizedDescription)
                    return
                }
                print("success update DB")
                self.delegateCreatedUser?.saved(success: true, errorMessage: "")
            })
        }
    }
    
    func updateItem(uid: String, values: [String: Any]) {
        Database.database().reference().root.child("items").child(uid).updateChildValues(values, withCompletionBlock: {
            (error, ref) in
            if let error = error {
                print("Failed to update DB: ", error.localizedDescription)
                self.delegateCreatedUser?.saved(success: false, errorMessage: error.localizedDescription)
                return
            }
            print("success update DB")
            self.delegateCreatedUser?.saved(success: true, errorMessage: "")
        })
    }

    func saveImage(image: UIImage, folderName: String, fileName: String, completion: @escaping ((_ url: URL?) -> ())) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("\(folderName)/\(fileName).jpg")
        imagesRef.putData((image.pngData())!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                completion(nil)
                return
            }
            imagesRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    completion(nil)
                    return
                }
                completion(url)
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


    func loadItems() {
        var items: [ItemModel] = []
        Database.database().reference().child("items").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.value as? [String:AnyObject] {
                for child in snapshots {
                    let value = child.value as? NSDictionary
                    let user = value?["User"] as? String ?? ""
                    let uid = Auth.auth().currentUser?.uid
                    if user == uid {
                        let title = value?["title"] as? String ?? ""
                        let dateFound = value?["dateFound"] as? String ?? ""
                        let dateLost = value?["dateLost"] as? String ?? ""
                        let description = value?["description"] as? String ?? ""
                        let category = value?["category"] as? String ?? ""
                        let imagesUrl = value?["imagesURL"] as? [String] ?? []

                        let item = ItemModel()
                        item.dateLost = dateLost
                        item.dateFound = dateFound
                        item.title = title
                        item.itemID = child.key
                        item.category = category
                        item.description = description
                        item.imagesURL = imagesUrl
                        items.append(item)
                    }
                }
                self.delegateloadedItems?.getItemModels(items: items)
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
}

