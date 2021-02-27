//
//  CryptoAssetFirebaseManager.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import Foundation
import Firebase


class CryptoAssetFirebaseManager {
    
    let assetsCollectionFirebaseTag = "assets"
    
    let db = Firebase.Firestore.firestore()
    let storage = Storage.storage()
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    private func uploadImage(_ image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        let image = image.resizeImage(128, opaque: true)
        
        if let data = image.jpegData(compressionQuality: 1) {
            let storageRef = storage.reference()
            let imageRef = storageRef.child("\(UUID().uuidString).jpeg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(data, metadata: metadata) { (_, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            completion(downloadURL, nil)
                        } else {
                            completion(nil, NSError.withLocalizedDescription("Unable to get image download url"))
                        }
                    }
                }
            }
            
        } else {
            completion(nil, NSError.withLocalizedDescription("Unable to get png data from image"))
        }
    }
    
    private func uploadAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        do {
            let data = try encoder.encode(asset)
            if var json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                json.removeValue(forKey: "id")
                
                let document = db.collection(assetsCollectionFirebaseTag).document(asset.id)
                document.setData(json) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                        completion(error)
                    } else {
                        print("Document successfully written!")
                        completion(nil)
                    }
                }
            } else {
                let error = NSError.withLocalizedDescription("Unable to create json object")
                completion(error)
            }
        } catch {
            let error = NSError.withLocalizedDescription("Unable to encode crypto asset")
            completion(error)
        }
    }
    
    func updateRemoteAsset(_ asset: CryptoAsset, _ image: UIImage?, completion: @escaping (CryptoAsset?, Error?) -> Void) {
        if let image = image {
            uploadImage(image) { (url, error) in
                if let error = error {
                    completion(nil, error)
                } else if let url = url {
                    var updatedAsset = asset
                    updatedAsset.iconURL = url.absoluteString
                    
                    self.uploadAsset(updatedAsset) { (error) in
                        if let error = error {
                            completion(nil, error)
                        } else {
                            completion(updatedAsset, nil)
                        }
                    }
                } else {
                    completion(nil, nil)
                }
            }
        } else {
            uploadAsset(asset) { (error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(asset, nil)
                }
            }
        }
    }
    
    func getRemoteAssets(completion: @escaping ([CryptoAsset]?, Error?) -> Void) {
        db.collection(assetsCollectionFirebaseTag).getDocuments { (query, error) in
            if let error = error {
                completion(nil, error)
            } else if let query = query {
                var assets: [CryptoAsset] = []
                
                query.documents.forEach { (document) in
                    do {
                        var jsonData = document.data()
                        jsonData.updateValue(document.documentID, forKey: "id")
                        
                        if let data = try? JSONSerialization.data(withJSONObject: jsonData) {
                            var asset = try self.decoder.decode(CryptoAsset.self, from: data)
                            asset.id = document.documentID
                            assets.append(asset)
                        } else {
                            print("Can't create json data from firebase document data")
                        }
                    } catch {
                        print(error)
                    }
                }
                
                completion(assets, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}
