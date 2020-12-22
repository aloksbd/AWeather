//
//  AForcastCacheSaver.swift
//  AWeather
//
//  Created by Alok Subedi on 22/12/2020.
//

public protocol AForcastCacheSaver {
    func save(_ item: AForecast, completion: @escaping (Error?) -> ())
}
