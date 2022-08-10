//
//  Endpoint.swift
//  TMDB
//
//  Created by SC on 2022/08/10.
//

import Foundation

struct Endpoint {
    static let trendingURL = "https://api.themoviedb.org/3/trending/all/week?api_key="
    static let imageConfigurationURL = "https://image.tmdb.org/t/p/original"
//    static let movieDetailsURL = "https://api.themoviedb.org/3/movie/"
//    static let tvDetailsURL = "https://api.themoviedb.org/3/tv/"
    static let baseURL = "https://api.themoviedb.org/3/"
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
    // https://api.themoviedb.org/3/tv/{tv_id}?api_key=<<api_key>>&language=en-US
    
    // videos
    // https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US
    // https://api.themoviedb.org/3/tv/{tv_id}/videos?api_key=<<api_key>>&language=en-US
    
    // Movie Recommendations
    // https://api.themoviedb.org/3/movie/725201/recommendations?api_key=<<api_key>>&language=en-US&page=1
    
    // Details
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
    
    // Details and Recommendations
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key={api_key}&append_to_response=recommendations
    
    static let youtubeURL = "https://www.youtube.com/watch?v="
}
