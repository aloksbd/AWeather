//
//  ARemoteForecastLoader.swift
//  AWeather
//
//  Created by Alok Subedi on 20/12/2020.
//

import Foundation

public class ARemoteForecastLoader: AForecastLoader{
    private var url: URL
    private var httpClient: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    
    public init(httpClient: HTTPClient, url: URL){
        self.httpClient = httpClient
        self.url = url
    }
    
    public func load(completion: @escaping (AForecastLoader.Result) -> ()){
        httpClient.get(from: url){ [weak self] result in
            guard self != nil else { return }
            switch result{
            case .failure(_):
                completion(.failure(Error.connectivity))
            case  let .success((data, response)):
                if response.statusCode == 200{
                    if let forecast = try? JSONDecoder().decode(AForecast.self, from: data){
                        completion(.success(forecast))
                    }else{
                        completion(.failure(Error.invalidData))
                    }
                }else{
                    completion(.failure(Error.invalidData))
                }
            }
        }
    }
    
    deinit {
        print("deinit : ")
    }
}
