//
//  WebViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/07.
//

import UIKit
import WebKit

import Alamofire
//import SkeletonView
import JGProgressHUD
import SwiftyJSON


class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
//    var url: String?
//    var media: MediaModel?
    var mediaType: String?
    var mediaID: Int?
    
    private let hud = JGProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView.isSkeletonable = true
//        webView.showAnimatedSkeleton()
//        webView.showAnimatedGradientSkeleton()

        fetchVideo()
    }
    
    
    private func fetchVideo() {
        // ❓ guard let 구문으로 nil이 아닐 경우에 옵셔널 해제(?)하는 방법?
        hud.show(in: view, animated: true)
        guard let mediaType = self.mediaType != nil ? self.mediaType : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find mediaType.")
            return
        }
        
        guard let mediaID = self.mediaID != nil ? self.mediaID : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find mediaID.")
            return
        }
        
        TMDBAPIManager.shared.fetchVideo(mediaType: mediaType, mediaID: mediaID) { videoKey in
            let url = Endpoint.youtubeURL + videoKey
            self.openWebPage(url: url)
        }
    }

    
    private func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Ivalid URL")
            return
        }

        let request = URLRequest(url: url)
        
        webView.load(request)
        hud.dismiss(animated: true)
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
