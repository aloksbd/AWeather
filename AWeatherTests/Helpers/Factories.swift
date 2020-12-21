//
//  Factories.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import Foundation
import AWeather

func forecastItem() -> AForecast{
    return makeItem().item
}

func anyNSError() -> NSError{
    return NSError(domain: "any error", code: 0)
}
