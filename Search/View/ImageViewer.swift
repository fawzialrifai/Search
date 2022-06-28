//
//  ImageViewer.swift
//  Search
//
//  Created by Fawzi Rifai on 27/06/2022.
//

import SwiftUI
import PDFKit

struct ImageViewer: View {
    let photo: Photo
    @State private var isInfoPresented = false
    var body: some View {
        AsynchronousImage(url: photo.urls.fullURL) { image in
            PhotoDetailView(image: image)
                .ignoresSafeArea(.all, edges: .bottom)
        } placeholder: {
            ProgressView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar {
            Button {
                isInfoPresented.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
        }
        .sheet(isPresented: $isInfoPresented) {
            PhotoInfo(photo: photo)
        }
    }
}

struct PhotoDetails_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(photo: .example)
    }
}

struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.backgroundColor = .clear
        guard let page = PDFPage(image: image) else { return pdfView }
        pdfView.document = PDFDocument()
        pdfView.document?.insert(page, at: 0)
        pdfView.autoScales = true
        return pdfView
    }
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
