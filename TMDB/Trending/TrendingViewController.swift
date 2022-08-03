//
//  TrendingViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


class TrendingViewController: UIViewController {
    
    var mediaArray: [MediaModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    func fetchData() {
        print("fetchData starting")
//        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 옵셔널이기 때문에 타입 어노테이션이나 가드구문 등으로 처리
        let url = Endpoint.trendingURL + APIKey.TMDB
        
//        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
//        let parameters = [
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    // json["results"].arrayValue는 배열, 배열 내의 요소는 모두 딕셔너리
                    print(json["results"])

                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchData ending")
    }
}
