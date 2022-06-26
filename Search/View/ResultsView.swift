//
//  ResultsView.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: ResultsViewModel
    var body: some View {
        VStack {
            if viewModel.isFetching {
                ProgressView()
            } else {
                if viewModel.error != nil {
                    ErrorView()
                } else {
                    ResultsGrid()
                }
            }
        }
        .navigationBarTitle(viewModel.query, displayMode: .inline)
        .environmentObject(viewModel)
        .ignoresSafeArea(SafeAreaRegions.all, edges: .bottom)
    }
    
    init(query: String) {
        _viewModel = StateObject(wrappedValue: ResultsViewModel(query: query))
    }
}

struct ErrorView: View {
    @EnvironmentObject var viewModel: ResultsViewModel
    var body: some View {
        if let error = viewModel.error {
            VStack {
                Text(error.rawValue)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry", action: { viewModel.fetchResults() })
            }
        }
    }
}

struct ResultsGrid: View {
    @EnvironmentObject var viewModel: ResultsViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 1)], spacing: 1) {
                ForEach(viewModel.photos, id: \.id) { photo in
                    Button {
                        guard let portfolioUrl = photo.user.portfolioUrl else { return }
                        UIApplication.shared.open(portfolioUrl)
                    } label: {
                        ResultView(photo: photo)
                            .aspectRatio(1, contentMode: .fill)
                    }
                    .onAppear {
                        viewModel.fetchMorePhotos(currentPhoto: photo)
                    }
                    .allowsHitTesting(photo.user.portfolio_url != nil)
                }
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultsView(query: "Example")
        }
    }
}
