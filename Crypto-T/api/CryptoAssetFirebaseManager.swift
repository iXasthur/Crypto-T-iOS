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
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func updateRemoteAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
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
