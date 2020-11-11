//
//  WeatherViewModel.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import Foundation


class WeatherViewModel: ObservableObject{
    
    init() {
        findSearched(city: "Turkey", latitude: nil, longitude: nil)
    }
    
    @Published var coordinate: Coordinate?
    @Published var weatherData: WeatherData?
    
    
    
    func findSearched(city search:String?, latitude lat:Double?, longitude lon:Double?){
        WeatherService.shared.getCoordinate(for: search, latitude: lat, longitude: lon) { [weak self] result in
            switch result{
            case .success(let returnValue):
                DispatchQueue.main.async {
                    self?.coordinate = returnValue
                }
                if let cord = returnValue.coord{
                    WeatherService.shared.getHourlyWeatherFor(latitude: cord.lat, longitude: cord.lon) { [weak self] result in
                        
                        switch result{
                        case .success(let returnValue):

                            DispatchQueue.main.async {
                                self?.weatherData = returnValue
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    
    
}
