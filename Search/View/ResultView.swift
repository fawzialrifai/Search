//
//  ResultView.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import SwiftUI

struct ResultView: View {
    let photo: Photo
    var body: some View {
        NavigationLink(destination: ImageViewer(photo: photo)) {
            ZStack(alignment: .bottomLeading) {
                AsynchronousImage(url: photo.urls.smallURL) { image in
                    GeometryReader { geometryReader in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometryReader.size.width, height: geometryReader.size.height)
                            .clipped()
                    }
                } placeholder: {
                    Rectangle()
                        .foregroundColor(Color.gray)
                }
                Text(photo.user.name)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.white)
                    .font(.caption.bold())
                    .padding()
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(photo: .example)
            .previewLayout(.sizeThatFits)
    }
}
