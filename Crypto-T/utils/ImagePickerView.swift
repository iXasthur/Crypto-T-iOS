//
//  ImagePickerView.swift
//  ImagePickerView
//
//  Created by Karthick Selvaraj on 02/05/20.
//  Copyright © 2020 Karthick Selvaraj. All rights reserved.
//

import SwiftUI
import UIKit


struct ImagePickerView: UIViewControllerRepresentable {
    
    var cropToSquare: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var uiImage: UIImage?
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(cropToSquare: cropToSquare, uiImage: $uiImage, presentationMode: presentationMode)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = context.coordinator
        pickerController.mediaTypes = ["public.image"]
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let cropToSquare: Bool
    
    @Binding var presentationMode: PresentationMode
    @Binding var uiImage: UIImage?
    
    init(cropToSquare: Bool, uiImage: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
        self.cropToSquare = cropToSquare
        self._presentationMode = presentationMode
        self._uiImage = uiImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if cropToSquare {
                if let croppedImage = uiImage.cropedToSquare() {
                    self.uiImage = croppedImage
                } else {
                    self.uiImage = uiImage
                }
            } else {
                self.uiImage = uiImage
            }
        }
        
        $presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        $presentationMode.wrappedValue.dismiss()
    }
    
}
