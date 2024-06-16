//
//  APIManager.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 27/05/24.
//

import Foundation
import UIKit

class APIManager{
    
    private init(){}
    // MARK: Singleton instance
    static let shared = APIManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getData(query: String, completion: @escaping(Result<[WikipediaPage], errorStrings>)->()){
        
        guard let urlString = URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&generator=search&gsrnamespace=0&gsrsearch=\(query)&gsrlimit=20&prop=pageimages|extracts&pilimit=max&exintro&explaintext&exsentences=1&exlimit=max")  else{
            completion(.failure(.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: urlString){(data, response, error) in
            if error != nil{
                completion(.failure(.errorFromApi))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else{
                completion(.failure(.wrongData))
                return
            }
            
            do{
                debugPrint(data)
                let data = try JSONDecoder().decode(WikipediaModel.self, from: data)
                let pages = Array(data.query.pages.values)
                debugPrint(pages)
                completion(.success(pages))
            }catch{
                completion(.failure(.failedParsing))
            }
        }.resume()
    }
    
    func getImage(url: String, completion: @escaping(Result<UIImage, errorStrings>)->()){
        
        guard let urlString = URL(string: url)  else{
            completion(.failure(.invalidUrl))
            return
        }
        
        if let cachedImage = cache.object(forKey: urlString.absoluteString as NSString){
            completion(.success(cachedImage))
            return
        }

        URLSession.shared.dataTask(with: urlString){(data, response, error) in
            if error != nil{
                completion(.failure(.errorFromApi))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else{
                completion(.failure(.wrongData))
                return
            }
            
            if let image = UIImage(data: data){
                self.cache.setObject(image, forKey: urlString.absoluteString as NSString)
                completion(.success(image))
            }else{
                completion(.failure(.failedParsing))
            }
        }.resume()
    }
}
