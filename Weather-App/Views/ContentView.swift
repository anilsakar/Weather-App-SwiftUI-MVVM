//
//  ContentView.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import SwiftUI
import Firebase


struct ContentView: View {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        WeatherBody()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
}

struct WeatherBody: View{
    
    @ObservedObject var locationManager = LocationManager()
    var weatherModelView: WeatherViewModel = WeatherViewModel()
    
    @State private var weatherDataOpacity:Bool = true
    @State private var weatherCity:String = ""
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View{
        NavigationView{
            ZStack{
                RadialGradient(gradient: Gradient(colors: WeatherBody.changeColors(for: weatherModelView.weatherData?.hourly[0].weather[0].main ?? "Thunderstorm")), center: .center, startRadius: 1, endRadius: 1000)
                    .ignoresSafeArea()
                    .opacity(0.7)
                VStack{
                    HStack{
                        TextField("", text: $weatherCity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(25)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            weatherModelView.findSearched(city: weatherCity, latitude: nil, longitude: nil)
                            weatherDataOpacityAnimation()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .font(.title)
                                .foregroundColor(Color.white.opacity(0.5))
                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        }
                        .foregroundColor(.black)
                        .background(Color.clear)
                        .cornerRadius(40)
                    }
                    .padding()
                    WeatherDataView()
                        .opacity(weatherDataOpacity ? 1 : 0 )
                        .animation(.easeInOut(duration: 0.25))
                        .environmentObject(weatherModelView)
                    
                    Spacer()
                }.foregroundColor(.white)
                
                .navigationBarTitle("Weather App")
                .navigationBarItems(trailing:
                                        Button("My Location") {
                                            weatherModelView.findSearched(city: nil, latitude: Double(userLatitude), longitude: Double(userLongitude))
                                            weatherDataOpacityAnimation()
                                        }.foregroundColor(.black)
                )
                
            }
        }.onReceive(locationManager.$locationStatus) { newValue in
            switch newValue{
            case .authorizedWhenInUse:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    weatherModelView.findSearched(city: nil, latitude: Double(userLatitude), longitude: Double(userLongitude))
                    weatherDataOpacityAnimation()
                }
            case .authorizedAlways:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    weatherModelView.findSearched(city: nil, latitude: Double(userLatitude), longitude: Double(userLongitude))
                    weatherDataOpacityAnimation()
                }
                
            default: return
            }
        }
    }
    
    func weatherDataOpacityAnimation(){
        weatherDataOpacity = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
            self.weatherDataOpacity = true
        })
    }
    
    
    static func changeColors(for weatherData: String) -> [Color]{
        
        switch weatherData{
        case "Thunderstorm": return [.purple, .white]
        case "Drizzle" : return [.gray, .white]
        case "Rain" : return [.gray, .white]
        case "Snow" : return [.blue, .white]
        case "Mist" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Smoke" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Haze" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Dust" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Fog" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Sand" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Ash" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Squall" : return [Color(red: 244 / 255, green: 164 / 255, blue: 96 / 255), .white]
        case "Tornado" : return [.gray, .white]
        case "Clear" : return [.yellow, .white]
        case "Clouds" : return [.green, .white]
        default: return [.green, .white]
        }
        
    }
    static func getIcon(for weatherData: String) -> String{
        
        switch weatherData {
        case "Thunderstorm": return "cloud.bold.rain.fill"
        case "Drizzle" : return "cloud.drizzle.fill"
        case "Rain" : return "cloud.rain.fill"
        case "Snow" : return "snow"
        case "Mist" : return "wind"
        case "Smoke" : return "smoke.fill"
        case "Haze" : return "sun.haze.fill"
        case "Dust" : return "sun.dust.fill"
        case "Fog" : return "cloud.fog.fill"
        case "Sand" : return "tornado"
        case "Ash" : return "sun.dust.fill"
        case "Squall" : return "cloud.heavyrain.fill"
        case "Tornado" : return "tornado"
        case "Clear" : return "sun.max.fill"
        case "Clouds" : return "cloud.fill"
        default: return "sun.max.fill"
        }
        
    }
    
}

struct WeatherDataView: View {
    
    @EnvironmentObject var weatherModelView: WeatherViewModel
    
    var body: some View{
        Image(systemName: WeatherBody.getIcon(for: "\(weatherModelView.weatherData?.hourly[0].weather[0].main ?? "Rain")"))
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .padding(.top)
        Text("\((weatherModelView.weatherData?.hourly[0].weather[0].description) ?? "clear sky")")
            .padding(.top)
            .font(.system(size: 20))
        Text("\(String(format: "%.0f",weatherModelView.weatherData?.hourly[0].tempature ?? 27))°")
            .font(.system(size: 100)).bold()
        Text("\((weatherModelView.weatherData?.hourly[0].minAndSecond) ?? "12:00")")
            .font(.system(size: 30)).bold()
        Text("\(weatherModelView.coordinate?.name ?? "Turkey") \(weatherModelView.coordinate?.sys.country ?? "TR")")
            .font(.system(size: 20)).bold()
        Spacer()
        HStack(){
            ForEach(1..<5){i in
                VStack{
                    Image(systemName: WeatherBody.getIcon(for: "\(weatherModelView.weatherData?.hourly[i].weather[0].main ?? "Rain")"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("\(String(format: "%.0f",weatherModelView.weatherData?.hourly[i].tempature ?? 27))°")
                        .font(.system(size: 30)).bold()
                    Text("\((weatherModelView.weatherData?.hourly[i].minAndSecond) ?? "12:00")")
                        .font(.system(size: 20)).bold()
                }.frame(maxWidth: .infinity)
            }
            
        }
        NavigationLink(
            destination: Weather7Days(coordinate: weatherModelView.coordinate, weatherData: weatherModelView.weatherData),
            label: {
                Text("See 7 day Forecast")
            })
            .padding(.top)
            .font(.system(size: 25))
    }
}




struct Test: View {
    var body: some View{
        Text("hello")
    }
}




