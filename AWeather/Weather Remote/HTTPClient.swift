//
//  HTTPClient.swift
//  AWeather
//
//  Created by Alok Subedi on 20/12/2020.
//

import Foundation

public protocol HTTPClient{
    typealias Result = Swift.Result<Data?, Error>
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> ())
}
