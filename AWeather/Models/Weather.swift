//
//  Weather.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct Weather: Codable, Equatable{
    public let main: String
    
    public init(main: String){
        self.main = main
    }
}
