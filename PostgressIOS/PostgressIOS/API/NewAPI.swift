//
//  NewAPI.swift
//  PostgressIOS
//
//  Created by Thien Vu on 03/10/2022.
//

import Foundation

class NewAPI {
    
    static let shared = NewAPI()
    
    init() {}
    
    private func setComponent(path:String, query : [String:Any]) -> URLComponents {
        var component = URLComponents()
        component.host = "api.openweathermap.org"
        component.scheme = "https"
        component.path = path
        
        var items = [URLQueryItem]()
        for (key,value) in query {
            let urlQuery = URLQueryItem(name: key, value: value as? String)
            items.append(urlQuery)
        }
        component.queryItems = items
        
        return component
    }
    
    private func setURLRequest(method : String, component : URL) -> URLRequest {
        var request = URLRequest(url: component)
        request.httpMethod = method
        return request
    }
    
    func newAPI(path: String, method : String, query : [String:Any], completion : @escaping (Result<[String:Any],Error>) -> Void) {
        
        let component = self.setComponent(path: path, query: query)
        if let url = component.url {
            let request = self.setURLRequest(method: method, component: url)
            
            let task = URLSession.shared.dataTask(with: request) { data , response, error in
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                    completion(.failure(Status.badRequest))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(Status.badResponse))
                    return
                }
                
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data)
                        completion(.success(json as! [String : Any]))
                    }
                } catch {
                    completion(.failure(Status.badResponse))
                }
            }
            
            task.resume()
            
        } else {
            completion(.failure(Status.requestFailed))
        }
    }
    
}
