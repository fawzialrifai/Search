//
//  HomeView.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                    VStack {
                        Text("Search")
                            .font(.largeTitle.bold())
                        SearchBar()
                    }
                    Spacer()
                    if viewModel.photos.count > 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Random Photos")
                                .font(.headline)
                                .padding(.horizontal, 32)
                            RandomPhotosScrollView()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(viewModel)
        }
    }
}

struct SearchBar: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        HStack {
            TextField("Search for photos", text: $viewModel.query, onCommit: { viewModel.submitQuery() })
                .frame(maxWidth: 300)
                .keyboardType(.webSearch)
            NavigationLink(destination: ResultsView(query: viewModel.query.trimmed), isActive: $viewModel.isResultsPresented) {
                Image(systemName: "magnifyingglass")
            }
            .disabled(viewModel.query.isTotallyEmpty)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 2)
        .padding()
    }
}

struct RandomPhotosScrollView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.photos, id: \.id) { photo in
                    Button {
                        guard let url = photo.user.portfolioUrl else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        ResultView(photo: photo)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 2)
                            .onAppear {
                                viewModel.fetchMorePhotos(currentPhoto: photo)
                            }
                    }
                    .allowsHitTesting(photo.user.portfolio_url != nil)
                }
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
