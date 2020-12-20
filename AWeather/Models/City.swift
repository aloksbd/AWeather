//
//  City.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct City: Decodable, Equatable{
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
