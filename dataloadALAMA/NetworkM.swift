//
//  NetworkM.swift
//  dataloadALAMA
//
//  Created by Евгений Сабина on 16.05.24.
//


import Foundation
import Alamofire

//enum APIRoutes {
//
//    case getTodosPhoto
//    
//    var baseURL: URL {
//        return URL(string: "https://jsonplaceholder.typicode.com/")!
//    }
//    
//    var path: String {
//        switch self {
//        case .getTodosPhoto:
//            return "photos"
//        }
//    }
//
//    var method: String {
//        switch self {
//        case .getTodosPhoto:
//            return "GET"
//        }
//    }
//    
//    var request: URLRequest {
//        
//        let url = URL(string: path, relativeTo: baseURL)!
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        return request
//    }
//}


class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    func getTodosPhoto(completion: @escaping (Result<[todosPhoto], Error>) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/photos").responseDecodable(of: [todosPhoto].self) { response in
            switch response.result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
