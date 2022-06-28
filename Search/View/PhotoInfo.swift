//
//  PhotoInfo.swift
//  Search
//
//  Created by Fawzi Rifai on 27/06/2022.
//

import SwiftUI

struct PhotoInfo: View {
    let photo: Photo
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List {
                if let description = photo.description {
                    Section(header: Text("Description")) {
                        Text(description)
                    }
                }
                Section(header: Text("Photo")) {
                    HStack {
                        Text("Published")
                        Spacer()
                        Text(photo.created_at, style: .date)
                    }
                    HStack {
                        Text("Dimensions")
                        Spacer()
                        Text("\(Int(photo.width)) × \(Int(photo.height))")
                    }
                }
                if let camera = photo.exif {
                    Section(header: Text("Camera")) {
                        HStack {
                            Text("Make")
                            Spacer()
                            Text(camera.make)
                        }
                        HStack {
                            Text("Model")
                            Spacer()
                            Text(camera.model)
                        }
                    }
                }
                Section(header: Text("User")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(photo.user.username)
                    }
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(photo.user.name)
                    }
                    if let portfolioUrl = photo.user.portfolioUrl {
                        Button {
                            UIApplication.shared.open(portfolioUrl)
                        } label: {
                            HStack {
                                Text("Portfolio")
                                Spacer()
                                Image(systemName: "safari")
                            }
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Info", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: { presentationMode.wrappedValue.dismiss() })
                }
            }
        }
    }
}

struct PhotoInfoList_Previews: PreviewProvider {
    static var previews: some View {
        PhotoInfo(photo: .example)
    }
}
