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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    SearchBar()
                    if viewModel.recentSearches.count > 0 {
                        RecentsSection()
                    }
                    if viewModel.randomPhotos.count > 0 {
                        RandomPhotosSection()
                    } else {
                        PlaceholderSection()
                    }
                }
            }
            .navigationTitle("Home")
            .environmentObject(viewModel)
            .actionSheet(isPresented: $viewModel.isClearAllRecentsPresented) {
                ActionSheet(
                    title: Text("All recent searches will be cleared."),
                    buttons: [
                        .default(Text("Clear")) {
                            withAnimation {
                                viewModel.recentSearches.removeAll()
                            }
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
}

struct SearchBar: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        HStack {
            TextField("Search for photos", text: $viewModel.searchBarText, onCommit: { viewModel.search(for: viewModel.searchBarText) })
                .frame(maxWidth: 400)
            NavigationLink(destination: ResultsView(query: viewModel.query.trimmed), isActive: $viewModel.isQueryResultsPresented) {
                Button {
                    viewModel.search(for: viewModel.searchBarText)
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            .disabled(viewModel.searchBarText.isTotallyEmpty)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 2)
        .padding()
    }
}

struct RecentsSection: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    viewModel.isClearAllRecentsPresented = true
                }
            }
            .padding(.horizontal, 24)
            VStack {
                Divider()
                    .padding(.leading, 24)
                ForEach(viewModel.recentSearches.prefix(3), id: \.self) { query in
                    RecentQueryView(query: query)
                }
            }
        }
    }
}

struct RecentQueryView: View {
    let query: String
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        Button {
            viewModel.search(for: query)
        } label: {
            HStack {
                Text(query)
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        Divider()
            .padding(.leading, 32)
    }
}

struct RandomPhotosSection: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Editorial")
                .font(.headline)
                .padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.randomPhotos, id: \.id) { photo in
                        ResultView(photo: photo)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onAppear {
                                viewModel.fetchMorePhotos(currentPhoto: photo)
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct PlaceholderSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Editorial")
                .font(.headline)
                .padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(1 ..< 15, id: \.self) { placeholder in
                        Rectangle()
                            .foregroundColor(Color.gray)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
