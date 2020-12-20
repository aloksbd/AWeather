//
//  Temperature.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct Temperature: Decodable, Equatable{
    public let min: String
    public let max: String
    public let day: String
    public let night: String
    public let morn: String
    public let eve: String
}
