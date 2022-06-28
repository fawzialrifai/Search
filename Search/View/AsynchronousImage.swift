//
//  AsynchronousImage.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import SwiftUI

struct AsynchronousImage<Content: View, Placeholder: View>: View {
    @StateObject var downloadManager: DownloadManager
    let content: (UIImage) -> Content
    let placeholder: () -> Placeholder
    var body: some View {
        if let data = downloadManager.data, let uiImage = UIImage(data: data) {
            content(uiImage)
        } else {
            placeholder()
        }
    }
    
    init(url: URL?) where Content == Image, Placeholder == EmptyView {
        self.init(url: url) { image in
            Image(uiImage: image)
        } placeholder: {
            EmptyView()
        }
    }
    
    init(url: URL?, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.content = content
        self.placeholder = placeholder
        _downloadManager = StateObject(wrappedValue: DownloadManager(url: url))
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsynchronousImage(url: Photo.URLS.example.smallURL)
        .previewLayout(.sizeThatFits)
    }
}
