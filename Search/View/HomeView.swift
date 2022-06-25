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
                    }
                }
            }
            .navigationTitle("Home")
            .environmentObject(viewModel)
            .actionSheet(isPresented: $viewModel.isClearAllRecentsPresented) {
                ActionSheet(
                    title: Text("All recent searches will be cleared."),
                    buttons: [
                        .default(Text("Clear All")) {
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
            TextField("Search for photos", text: $viewModel.query, onCommit: { viewModel.search(for: viewModel.query) })
                .frame(maxWidth: 300)
            NavigationLink(destination: ResultsView(query: viewModel.query.trimmed), isActive: $viewModel.isQueryResultsPresented) {
                Button {
                    viewModel.search(for: viewModel.query)
                } label: {
                    Image(systemName: "magnifyingglass")
                }
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

struct RecentsSection: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Recent")
                    .font(.headline)
                Spacer()
                Button("Clear All") {
                    viewModel.isClearAllRecentsPresented = true
                }
            }
            .padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.recentSearches, id: \.self) { query in
                        RecentQueryView(query: query)
                    }
                }
                .padding()
            }
        }
    }
}

struct RecentQueryView: View {
    let query: String
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        Button {
            viewModel.query = query
            viewModel.search(for: query)
        } label: {
            ZStack {
                Color.blue
                Text(query)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(height: 100)
            .frame(minWidth: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 2)
            .contextMenu(menuItems: {
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            viewModel.deleteFromRecents(query)
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            })
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RandomPhotosSection: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Random Photos")
                .font(.headline)
                .padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.randomPhotos, id: \.id) { photo in
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
                        .buttonStyle(PlainButtonStyle())
                        .allowsHitTesting(photo.user.portfolio_url != nil)
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
