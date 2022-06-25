//
//  ImageView.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import SwiftUI

struct ImageView<Placeholder: View>: View {
    var placeholder: Placeholder
    @StateObject var downloadManager: DownloadManager
    var body: some View {
        if let data = downloadManager.data, let uiImage = UIImage(data: data) {
            GeometryReader { geometryReader in
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryReader.size.width, height: geometryReader.size.height)
                    .clipped()
            }
        } else {
            placeholder
        }
    }
    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _downloadManager = StateObject(wrappedValue: DownloadManager(url: url))
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: Photo.URLS.example.thumbUrl) {
            Rectangle()
                .foregroundColor(Color.gray)
        }
        .previewLayout(.sizeThatFits)
    }
}
