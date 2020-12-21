//
//  Temperature.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct Temperature: Codable, Equatable{
    public let min: String
    public let max: String
    public let day: String
    public let night: String
    public let morn: String
    public let eve: String
    
    public init(min: String, max: String, day: String, night: String, morn: String, eve: String){
        self.min = min
        self.max = max
        self.day = day
        self.night = night
        self.morn = morn
        self.eve = eve
    }
}
