//
//  MediaModel.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import Foundation

struct MediaModel {
    let title: String
    let mediaType: String
    let backdropPath: String
//    let genreIDs: [Int]
    let genreID: Int
    let releaseDate: String
    let voteAverage: Double
    let overview: String
}
