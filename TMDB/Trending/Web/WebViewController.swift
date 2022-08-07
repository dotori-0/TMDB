//
//  WebViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/07.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON


class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
//    var url: String?
//    var media: MediaModel?
    var mediaType: String?
    var mediaID: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchVideo()
    }
    
    func fetchVideo() {
        guard let mediaType = self.mediaType != nil ? self.mediaType : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find mediaType.")
            return
        }
        
        guard let mediaID = self.mediaID != nil ? self.mediaID : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find mediaID.")
            return
        }
        
        // ❓ guard let 구문으로 nil이 아닐 경우에 옵셔널 해제(?)하는 방법?
        let url = "\(Endpoint.detailsURL)\(mediaType)/\(mediaID)/videos?api_key=\(APIKey.TMDB)"
        // https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US
        // https://api.themoviedb.org/3/tv/{tv_id}/videos?api_key=<<api_key>>&language=en-US
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let videoKey = json["results"][0]["key"].stringValue
                    let url = "https://www.youtube.com/watch?v=\(videoKey)"
                    
                    self.openWebPage(url: url)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Ivalid URL")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
}



//@IBAction func closeButtonClicked(_ sender: UIBarButtonItem) {
//}
//
//@IBAction func goBackButtonClicked(_ sender: UIBarButtonItem) {
//    if webView.canGoBack {
//        webView.goBack()
//    }
//}
//
//@IBAction func refreshButtonClicked(_ sender: UIBarButtonItem) {
//    webView.reload()
//}
//
//@IBAction func goForwardButtonClicked(_ sender: UIBarButtonItem) {
//    if webView.canGoForward {
//        webView.goForward()
//    }
//}
}
