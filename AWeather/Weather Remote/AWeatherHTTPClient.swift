//
//  AWeatherHTTPClient.swift
//  AWeather
//
//  Created by Alok Subedi on 21/12/2020.
//

import Foundation

public class AWeatherHTTPClient: HTTPClient{
    private let session: URLSession
    
    public init(session: URLSession = .shared){
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error{}
    
    public func get(from url: URL, completion: @escaping(HTTPClient.Result) -> Void){
        session.dataTask(with: url){ data, response, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data, let response = response as? HTTPURLResponse{
                completion(.success((data, response)))
            }else{
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}
