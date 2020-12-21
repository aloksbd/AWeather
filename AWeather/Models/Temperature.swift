//
//  Temperature.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct Temperature: Codable, Equatable{
    public let min: Double
    public let max: Double
    public let day: Double
    public let night: Double
    public let morn: Double
    public let eve: Double
    
    public init(min: Double, max: Double, day: Double, night: Double, morn: Double, eve: Double){
        self.min = min
        self.max = max
        self.day = day
        self.night = night
        self.morn = morn
        self.eve = eve
    }
}
