//
//  TMDBAPIManager.swift
//  TMDB
//
//  Created by SC on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON


class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    
    /// Fetch Trending
    func fetchData(page: Int, completionHandler: @escaping ([MediaModel]) -> ()) {
        print("fetchData starting")

        let url = Endpoint.trendingURL + APIKey.TMDB + "&page=\(page)"
        
        var mediaArray: [MediaModel] = []
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    // for-loop
//                    for result in json["results"].arrayValue {
//                        let mediaType = result["media_type"].stringValue
//                        let title = mediaType == "movie" ? result["title"].stringValue : result["name"].stringValue
//                        let id = result["id"].intValue
//                        let backdropPath = result["backdrop_path"].stringValue
//                        let posterPath = result["poster_path"].stringValue
//                        let genreID = result["genre_ids"][0].intValue
////                        print("genreID", genreID)
//                        let releaseDate = result["release_date"].stringValue
//                        let voteAverage = result["vote_average"].doubleValue
//                        let overview = result["overview"].stringValue
//
//
//                        let mediaModel = MediaModel(title: title, mediaType: mediaType, id: id, backdropPath: backdropPath, posterPath: posterPath, genreID: genreID, releaseDate: releaseDate, voteAverage: voteAverage, overview: overview)
//                        mediaArray.append(mediaModel)
//
//
////                        self.trendingCollectionView.stopSkeletonAnimation()
////                        self.trendingCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))  // 여기에서 hide 하지 않으면 스크롤 불가
////                        self.trendingCollectionView.reloadData()
//                    }
                    
                    // map
                    mediaArray = json["results"].arrayValue.map { result in
                        let mediaType = result["media_type"].stringValue
                        
                        let mediaModel = MediaModel(
                                            title: mediaType == "movie" ? result["title"].stringValue : result["name"].stringValue,
                                            mediaType: mediaType,
                                            id: result["id"].intValue,
                                            backdropPath: result["backdrop_path"].stringValue,
                                            posterPath: result["poster_path"].stringValue,
                                            genreID: result["genre_ids"][0].intValue,
                                            releaseDate: result["release_date"].stringValue,
                                            voteAverage: result["vote_average"].doubleValue,
                                            overview: result["overview"].stringValue
                                        )
//                        mediaArray.append(mediaModel)
                        print("🤍", mediaModel)
                        return mediaModel
                    }
                    
//                    mediaArray = json["results"].arrayValue.map {
//                        MediaModel(
//                            title: mediaType == "movie" ? $0["title"].stringValue : $0["name"].stringValue,
//                            mediaType: result["media_type"].stringValue,
//                            id: <#T##Int#>,
//                            backdropPath: <#T##String#>,
//                            posterPath: <#T##String#>,
//                            genreID: <#T##Int#>,
//                            releaseDate: <#T##String#>,
//                            voteAverage: <#T##Double#>,
//                            overview: <#T##String#>
//                        )
//                    }
                    
                    
                    completionHandler(mediaArray)

//                    print("completionHandler 다음")  // completionHandler 후 작업도 가능
                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchData ending")
    }
    
    
    /// Fetch Credits Using TMDB API
    func fetchCredits(media: MediaModel, completionHandler: @escaping (_ cast: [CastModel], _ crew: [CastModel]) -> ()) {
        let creditsURL = "\(Endpoint.baseURL)\(media.mediaType)/\(media.id)/credits?api_key=\(APIKey.TMDB)"
        // https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=<<api_key>>&language=en-US
        // https://api.themoviedb.org/3/tv/{tv_id}/credits?api_key=<<api_key>>&language=en-US
        
        AF.request(creditsURL, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
//                    dump(json)
                    
//                    var castArray: [CastModel] = []
//                    var crewArray: [CastModel] = []
                    
                    // for-loop
//                    for cast in json["cast"].arrayValue {
//                        let profilePath = cast["profile_path"].stringValue
//                        let name = cast["name"].stringValue
//                        let character = cast["character"].stringValue
//
//                        let cast = CastModel(profilePath: profilePath, name: name, character: character)
//
//                        castArray.append(cast)
//
////                        self.detailsTableView.reloadData()
//                    }
                    
                    // map
                    let castArray = json["cast"].arrayValue.map {
                        CastModel(
                            profilePath: $0["profile_path"].stringValue,
                            name: $0["name"].stringValue,
                            character: $0["character"].stringValue
                        )
                    }
//                    print("castArray 타입:", type(of: castArray))  // Array<CastModel>
                    
//                    completionHandler(castArray, crewArray)
                    // ❓ castArray만 만들어져도 reload 하는 방법?
                    
                    // for-loop
//                    for crew in json["crew"].arrayValue {
//                        let profilePath = crew["profile_path"].stringValue
//                        let name = crew["name"].stringValue
//                        let job = crew["job"].stringValue
//
//                        let crew = CastModel(profilePath: profilePath, name: name, character: job)
//
//                        crewArray.append(crew)
//
////                        self.detailsTableView.reloadData()
//                    }
                    
                    // map
                    let crewArray = json["crew"].arrayValue.map { crew in
                        CastModel(
                            profilePath: crew["profile_path"].stringValue,
                            name: crew["name"].stringValue,
                            character: crew["job"].stringValue
                        )
                    }
                    
                    completionHandler(castArray, crewArray)

                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchVideo(mediaType: String, mediaID: Int, completionHandler: @escaping (String) -> ()) {
//        guard let mediaType = self.mediaType != nil ? self.mediaType : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
//            print("Cannot find mediaType.")
//            return
//        }
//
//        guard let mediaID = self.mediaID != nil ? self.mediaID : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
//            print("Cannot find mediaID.")
//            return
//        }
        

        let url = "\(Endpoint.baseURL)\(mediaType)/\(mediaID)/videos?api_key=\(APIKey.TMDB)"
        // https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US
        // https://api.themoviedb.org/3/tv/{tv_id}/videos?api_key=<<api_key>>&language=en-US
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let videoKey = json["results"][0]["key"].stringValue

                    completionHandler(videoKey)
                    
//                    self.hud.dismiss(animated: true)  // 위치를 어디에?
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDetailsAndRecommendations(movieID: Int, completionHandler: @escaping (_ title: String, _ posterPaths: [String]) -> ()) {
//    func fetchDetailsAndRecommendations(movieID: Int, completionHandler: @escaping ((String, [String])) -> ()) {  // tuple
        // https://api.themoviedb.org/3/movie/{movie_id}?api_key={api_key}&append_to_response=recommendations  // &language=en-US&page=1
        let url = Endpoint.getMovieDetailsAndRecommendationsURL(movieID: movieID)
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print(json)
                    
                    let title = json["title"].stringValue
                    let posterPaths = json["recommendations"]["results"].arrayValue.map { $0["poster_path"].stringValue }
//                    let recommendations = json["recommendations"]["results"].arrayValue.map { $0["title"].stringValue }
//                    print(#function, title, posterPaths)
                    completionHandler(title, posterPaths)
//                    completionHandler((title, posterPaths))  // tuple
                case.failure(let error):
                    print(error)
            }
        }
    }
    
    
    func callRequestsForDetailsAndRecommendations(movieIDs: [Int], completionHandler: @escaping ([(String, [String])]) -> ()) {
        var titlesAndPosterPaths: [(String, [String])] = []
        
        TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[0]) { title, posterPaths in
            titlesAndPosterPaths.append((title, posterPaths))
//            titleAndPosterPaths.append(contentsOf: (title, posterPaths))
//            print(#function, titleAndPosterPaths)
            
            TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[1]) { title, posterPaths in
                titlesAndPosterPaths.append((title, posterPaths))
                
                TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[2]) { title, posterPaths in
                    titlesAndPosterPaths.append((title, posterPaths))
                 
                    TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[3]) { title, posterPaths in
                        titlesAndPosterPaths.append((title, posterPaths))
                     
                        TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[4]) { title, posterPaths in
                            titlesAndPosterPaths.append((title, posterPaths))
                            
                            TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[5]) { title, posterPaths in
                                titlesAndPosterPaths.append((title, posterPaths))
                                
                                TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: movieIDs[6]) { title, posterPaths in
                                    titlesAndPosterPaths.append((title, posterPaths))
                                    
//                                    print(#function)
//                                    dump(titlesAndPosterPaths)
                                    
                                    completionHandler(titlesAndPosterPaths)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



