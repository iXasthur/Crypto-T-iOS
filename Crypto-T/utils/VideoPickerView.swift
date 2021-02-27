//
//  VideoPickerView.swift
//  VideoPickerView
//
//  Created by Karthick Selvaraj on 02/05/20.
//  Copyright © 2020 Karthick Selvaraj. All rights reserved.
//

import SwiftUI
import UIKit


struct VideoPickerView: UIViewControllerRepresentable {
    
    @Binding var videoNSURL: NSURL?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> VideoPickerViewCoordinator {
        return VideoPickerViewCoordinator(videoNSURL: $videoNSURL, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = context.coordinator
        pickerController.mediaTypes = ["public.movie"]
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class VideoPickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var videoNSURL: NSURL?
    @Binding var isPresented: Bool
    
    init(videoNSURL: Binding<NSURL?>, isPresented: Binding<Bool>) {
        self._videoNSURL = videoNSURL
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoNSURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            self.videoNSURL = videoNSURL
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}
