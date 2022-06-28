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
            GeometryReader { geometryReader in
                ScrollView(showsIndicators: false) {
                    SearchBar()
                        .frame(width: geometryReader.size.width)
                    RecentsSection()
                        .frame(width: geometryReader.size.width)
                    if viewModel.randomPhotos.count > 0 {
                        RandomPhotosSection(contentPadding: geometryReader.safeAreaInsets.leading)
                    } else {
                        PlaceholderSection(contentPadding: geometryReader.safeAreaInsets.leading)
                    }
                }
                .edgesIgnoringSafeArea(.horizontal)
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
        .navigationViewStyle(.stack)
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
        if viewModel.recentSearches.count > 0 {
            VStack {
                HStack {
                    Text("Recent")
                        .font(.headline)
                    Spacer()
                    Button("Clear") {
                        viewModel.isClearAllRecentsPresented = true
                    }
                }
                .padding(.horizontal, 24)
                Divider()
                    .padding(.leading, 24)
                ForEach(viewModel.recentSearches.prefix(3), id: \.self) { query in
                    RecentQueryView(query: query)
                }
            }
            .padding(.bottom)
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
    let contentPadding: CGFloat
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        HStack {
            Text("Editorial")
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, contentPadding + 24)
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
            .padding(.horizontal)
            .padding(.horizontal, contentPadding)
        }
    }
}

struct PlaceholderSection: View {
    let contentPadding: CGFloat
    var body: some View {
        HStack {
            Text("Editorial")
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, contentPadding + 24)
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
            .padding(.horizontal)
            .padding(.horizontal, contentPadding)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
