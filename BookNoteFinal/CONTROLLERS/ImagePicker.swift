//
//  ImagePicker.swift
//  BookNote
//
//  Created by Maciej Daszkiewicz on 09/01/2024.
//

import SwiftUI
import PhotosUI

@MainActor
class ImagePicker: ObservableObject {

    @Published var image: Image?
    @Published var uiImage: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                try await loadTransferable(from: imageSelection)
            }
        }
    }
  
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.uiImage = uiImage
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
