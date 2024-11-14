//
//  Home.swift
//  SynchronizedScrollViews
//
//  Created by Đoàn Văn Khoan on 14/11/24.
//

import SwiftUI

struct Home: View {
    
    /// Constructing Pic Using Asset Image
//    @State private var pics: [PicItem] = (1...5).compactMap { index -> PicItem? in
//        return .init(image: "image\(index)")
//    }
    
    /// View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedPicID: UUID?
    @State private var posts: [Post] = samplePosts
    @State private var selectedPost: Post?

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    ForEach(posts) { post in
                        CardView(post)
                    }
                }
                .safeAreaPadding(15)
            }
            .navigationTitle("Animation")
        }
        .overlay { /// Blur view swiftUI
            if let selectedPost, showDetailView {
                DetailView(
                    showDetailView: $showDetailView,
                    post: selectedPost,
                    selectedPicID: $selectedPicID
                ) { id in
                    /// Updating Scroll Position
                    if let index = posts.firstIndex(where: { $0.id == selectedPost.id }) {
                        posts[index].scrollPosition = id
                    }
                }
                .transition(.offset(y: 5))
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ post: Post) -> some View {
        VStack(spacing: 10) {
            
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.username)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                    
                    Text(post.content)
                }
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
                .foregroundStyle(.primary)
                .offset(y: -10)
            }
            
            /// Image Carousel Using New ScrollView(iOS 17+)
            VStack(alignment: .leading, spacing: 10) {
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 10) {
                        HStack(spacing: 10) {
                            ForEach(post.pics) { pic in
                                LazyHStack {
                                    Image(pic.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: size.width)
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                                .frame(maxWidth: size.width)
                                .frame(height: size.height)
                                .onTapGesture {
                                    selectedPost = post
                                    selectedPicID = pic.id
                                    showDetailView = true
                                }
                                .contentShape(.rect)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: .init(get: {
                        return post.scrollPosition
                    }, set: { _ in
                        
                    }))
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                }
                .frame(height: 200)
                
                /// Image Button
                HStack(spacing: 10) {
                    ImageButton("suit.heart") {}
                    ImageButton("message") {}
                    ImageButton("arrow.2.squarepath") {}
                    ImageButton("paperplane") {}
                }
            }
            .safeAreaPadding(.leading, 40)
            
            /// Likes & Replies
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .frame(width: 30, height: 30)
                    .background(.background)
                Button("10 replies") {}
                Button("10 replies") {}
                    .padding(.leading, -5)
                Spacer()
            }
            .textScale(.secondary)
            .foregroundStyle(.secondary)
        }
        .background(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 1)
                .padding(.bottom, 30)
                .offset(x: 15, y: 10)
        }
    }
    
    @ViewBuilder
    func ImageButton(_ icon: String, onTap: @escaping () -> ()) -> some View {
        Button("", systemImage: icon, action: onTap)
            .font(.title3)
            .foregroundStyle(.primary)
    }
}


struct DetailView: View {
    
    @Binding var showDetailView: Bool
    var post: Post
    @Binding var selectedPicID: UUID?
    var updateScrollPosition: (UUID?) -> ()
    /// View properties
    @State private var detailScrollPosition: UUID?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(post.pics) { pic in
                    Image(pic.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $detailScrollPosition)
        .background(.black)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button {
                updateScrollPosition(detailScrollPosition)
                showDetailView = false
                selectedPicID = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .font(.title)
            .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
            .padding()
        }
        .onAppear {
            guard detailScrollPosition == nil else { return }
            detailScrollPosition = selectedPicID
        }
    }
}

#Preview {
    ContentView()
}
