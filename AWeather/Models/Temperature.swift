//
//  Temperature.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

struct Temperature: Decodable, Equatable{
    let min: String
    let max: String
    let day: String
    let night: String
    let morn: String
    let eve: String
}
