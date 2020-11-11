//
//  WeatherService.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import Foundation


enum ErrorMessage: String, Error {
    case invalidData = "Sorry. Something went wrong, try again"
    case dataError = "Something wrong with the data"
    case invalidResponse = "Server error. Please modify your search and try again"
    case apiKeyError = "Something wrong with your api key please check it"
    case urlError = "Something wrong with the url"
    case coordinateDidNotFound = "Selected results coordinate did not found"
    case dataValidationError = "Check fecthed data whether JSON or not"
}


class WeatherService{
    
    public static let shared: WeatherService = WeatherService()
    private var urlString:String?
    
    func getCoordinate(for search:String?, latitude lat:Double?, longitude lon:Double?, completed: @escaping (Result<Coordinate, ErrorMessage>) -> Void) {
        
        if let la = lat, let lo = lon{
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(la)&lon=\(lo)&appid=fa842b9d89ae11dc40ce99393374184a"
        }else{
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(search!)&units=metric&appid=fa842b9d89ae11dc40ce99393374184a"
        }
       /* if let myApiKey = KeychainWrapper.standard.string(forKey: "myApiKey"), myApiKey != "No Key"{
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(search)&units=metric&appid=fa842b9d89ae11dc40ce99393374184a"
       }else{
            completed(.failure(.apiKeyError))
            return
        }*/
        guard let url = URL(string: urlString!) else {
            completed(.failure(.urlError))
            return}
       
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
               
                completed(.failure(.dataError))
                return
            }
            
            do {
                let deconder = JSONDecoder()
                deconder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try deconder.decode(Coordinate.self, from: data)
                
                if results.coord == nil{
                    completed(.failure(.coordinateDidNotFound))
                    return
                }
                completed(.success(results))
                
                
            } catch {
                
                completed(.failure(.dataValidationError))
            }
        }
        task.resume()
        
    }
    
    func getHourlyWeatherFor(latitude lat:Double, longitude lon: Double, completed: @escaping (Result<HourlyWeather, ErrorMessage>) -> Void) {
        
       // if let myApiKey = KeychainWrapper.standard.string(forKey: "myApiKey"), myApiKey != "No Key"{
            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,daily,alerts&units=metric&appid=fa842b9d89ae11dc40ce99393374184a"
       /* }else{
            completed(.failure(.apiKeyError))
            return
        }*/
        guard let url = URL(string: urlString!) else {
            completed(.failure(.urlError))
            return}
       
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            
            if let _ = error {
                completed(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
               
                completed(.failure(.dataError))
                return
            }
            
            do {
                let deconder = JSONDecoder()
                var results = try deconder.decode(HourlyWeather.self, from: data)
                
                if results.hourly.isEmpty {
                    completed(.failure(.coordinateDidNotFound))
                    return
                }
                
                for i in 0...results.hourly.count-1{
                    let date = NSDate(timeIntervalSince1970: TimeInterval(results.hourly[i].date))
                    let newDate = self.convertToUTC(dateToConvert: "\(date.description)")
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: newDate)
                    results.hourly[i].minAndSecond = "\(components.hour!):\(components.minute!)0"
                }
                
                completed(.success(results))
                
                
            } catch {
                
                
                
                completed(.failure(.dataValidationError))
            }
        }
        task.resume()
        
    }
    
    func convertToUTC(dateToConvert:String) -> Date {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
         let convertedDate = formatter.date(from: dateToConvert)
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        formatter.timeZone = TimeZone(identifier: localTimeZoneIdentifier)
        return formatter.date(from: "\(formatter.string(from: convertedDate!))")!
            
        }
}
