//
//  CryptoAssetFirebaseManager.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import Foundation
import Firebase
import AVFoundation


class CryptoAssetFirebaseManager {
    
    let db = Firebase.Firestore.firestore()
    let storage = Storage.storage()
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    
    private func getStorageDownloadURL(path: String, completion: @escaping (URL?, Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(path)
        fileRef.downloadURL { (url, error) in
            completion(url, error)
        }
    }
    
    private func uploadFile(fileRef: StorageReference, data: Data, metadata: StorageMetadata, completion: @escaping (CloudFileData?, Error?) -> Void) {
        fileRef.putData(data, metadata: metadata) { (_, error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.getStorageDownloadURL(path: fileRef.fullPath) { (url, error) in
                    if let error = error {
                        completion(nil, error)
                    } else if let url = url {
                        completion(CloudFileData(path: fileRef.fullPath, downloadURL: url.absoluteString), nil)
                    } else {
                        completion(nil, nil)
                    }
                }
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (CloudFileData?, Error?) -> Void) {
        let image = image.resizeImage(128, opaque: true)
        
        if let data = image.jpegData(compressionQuality: 1) {
            let storageRef = storage.reference()
            let path = "\(Constants.imagesFolderFirebaseName)/\(UUID().uuidString).jpeg"
            let imageRef = storageRef.child(path)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            uploadFile(fileRef: imageRef, data: data, metadata: metadata) { (fileData, error) in
                completion(fileData, error)
            }
            
        } else {
            completion(nil, NSError.withLocalizedDescription("Unable to get png data from image"))
        }
    }
    
    private func uploadVideo(_ videoNSURL: NSURL, completion: @escaping (CloudFileData?, Error?) -> Void) {
        if let url = videoNSURL.absoluteURL {
            let avAsset = AVURLAsset(url: url)
            avAsset.exportVideo { (url) in
                if let url = url {
                    do {
                        let nsdata = try NSData(contentsOf: url, options: .mappedIfSafe)
                        let data = Data(referencing: nsdata)
                        
                        let storageRef = self.storage.reference()
                        let path = "\(Constants.videosFolderFirebaseName)/\(UUID().uuidString).mp4"
                        let imageRef = storageRef.child(path)
                        
                        let metadata = StorageMetadata()
                        metadata.contentType = "video/mp4"
                        
                        self.uploadFile(fileRef: imageRef, data: data, metadata: metadata) { (fileData, error) in
                            completion(fileData, error)
                        }
                    } catch {
                        completion(nil, NSError.withLocalizedDescription("Unable to convert video URL"))
                    }
                } else {
                    completion(nil, NSError.withLocalizedDescription("Unable to convert video"))
                }
            }
        } else {
            completion(nil, NSError.withLocalizedDescription("Unable to get video URL"))
        }
    }
    
    private func uploadAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        do {
            let data = try encoder.encode(asset)
            if var json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                json.removeValue(forKey: "id")
                
                let document = db.collection(Constants.assetsCollectionFirebaseName).document(asset.id)
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
    
    private func updateRemoteAssetRec(_ asset: CryptoAsset, _ image: UIImage?, _ videoNSURL: NSURL?, completion: @escaping (CryptoAsset?, Error?) -> Void) {
        
        // Upload files 1 by 1 with every call
        // Priority:
        // 1 - Video
        // 2 - Image
        // 3 - Asset
        
        if let videoNSURL = videoNSURL {
            uploadVideo(videoNSURL) { (fileData, error) in
                var updatedAsset = asset
                
                if let error = error {
                    print(error)
                } else if let fileData = fileData {
                    updatedAsset.videoFileData = fileData
                }
                
                self.updateRemoteAssetRec(updatedAsset, image, nil, completion: completion)
            }
            
            return
        }
        
        if let image = image {
            uploadImage(image) { (fileData, error) in
                var updatedAsset = asset
                
                if let error = error {
                    print(error)
                } else if let fileData = fileData {
                    updatedAsset.iconFileData = fileData
                }
                
                self.updateRemoteAssetRec(updatedAsset, nil, videoNSURL, completion: completion)
            }
            
            return
        }
        
        uploadAsset(asset) { (error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(asset, nil)
            }
        }
        
    }
    
    func updateRemoteAsset(_ asset: CryptoAsset, _ image: UIImage?, _ videoNSURL: NSURL?, completion: @escaping (CryptoAsset?, Error?) -> Void) {
        updateRemoteAssetRec(asset, image, videoNSURL) { (updatedAssed, error) in
            completion(updatedAssed, error)
        }
    }
    
    func getRemoteAssets(completion: @escaping ([CryptoAsset]?, Error?) -> Void) {
        db.collection(Constants.assetsCollectionFirebaseName).getDocuments { (query, error) in
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
