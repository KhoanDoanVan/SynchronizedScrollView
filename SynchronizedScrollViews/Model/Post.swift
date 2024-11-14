//
//  Post.swift
//  SynchronizedScrollViews
//
//  Created by Đoàn Văn Khoan on 14/11/24.
//

import SwiftUI

struct Post: Identifiable {
    let id: UUID = .init()
    var username: String
    var content: String
    var pics: [PicItem]
    /// View Based Properties
    var scrollPosition: UUID?
}

/// Sample Posts
var samplePosts: [Post] = [
    .init(username: "iJustine", content: "Nature Pics", pics: pics),
    .init(username: "iJustine", content: "Nature Pics", pics: pics.reversed())
]

private var pics: [PicItem] = (1...5).compactMap { index -> PicItem? in
    return .init(image: "image\(index)")
}
