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
        ZStack(alignment: .bottom) {
            ImageView(url: photo.urls.thumbUrl) {
                Rectangle()
                    .foregroundColor(Color.gray)
            }
            HStack(alignment: .lastTextBaseline) {
                Text(photo.user.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                if photo.user.portfolio_url != nil {
                    Image(systemName: "arrow.up.forward.app.fill")
                }
            }
            .foregroundColor(Color.white)
            .font(.caption.bold())
            .padding()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(photo: .example)
            .previewLayout(.sizeThatFits)
    }
}
