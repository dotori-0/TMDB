//
//  Cinema.swift
//  TMDB
//
//  Created by SC on 2022/08/11.
//

import Foundation


struct Cinema {
    let type: String
    let location: String
    let latitude: Double
    let longitude: Double
}


struct CinemaList {
    static var mapAnnotations: [Cinema] = [
        Cinema(type: CinemaType.롯데시네마.rawValue, location: "롯데시네마 서울대입구", latitude: 37.4824761978647, longitude: 126.9521680487202),
        Cinema(type: CinemaType.롯데시네마.rawValue, location: "롯데시네마 가산디지털", latitude: 37.47947929602294, longitude: 126.88891083192269),
        Cinema(type: CinemaType.메가박스.rawValue, location: "메가박스 이수", latitude: 37.48581351541419, longitude:  126.98092132899579),
        Cinema(type: CinemaType.메가박스.rawValue, location: "메가박스 강남", latitude: 37.49948523972615, longitude: 127.02570417165666),
        Cinema(type: CinemaType.CGV.rawValue, location: "CGV 영등포", latitude: 37.52666023337906, longitude: 126.9258351013706),
        Cinema(type: CinemaType.CGV.rawValue, location: "CGV 용산 아이파크몰", latitude: 37.53149302830903, longitude: 126.9654030486416)
    ]
}


enum CinemaType: String {
    case 롯데시네마
    case 메가박스
    case CGV
    case all = "전체보기"
}
