//
//  ContentView.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import SwiftUI


struct ContentView: View {
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
    
    func changeColors(for weatherData: String) -> [Color]{
        
        switch weatherData{
        case "Clear" : return [.blue, .white]
        case "Rain" : return [.gray, .white]
        case "Clouds" : return [.black, .white]
        default: return [.yellow, .white]
        }
        
    }
    
    
    
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
                RadialGradient(gradient: Gradient(colors: changeColors(for: weatherModelView.hourlyWeather?.hourly[0].weather[0].main ?? "Rain")), center: .center, startRadius: 1, endRadius: 1000)
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
                    WeatherData()
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
        }
    }
    
    func weatherDataOpacityAnimation(){
        weatherDataOpacity = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
            self.weatherDataOpacity = true
        })
    }
    
}

struct WeatherData: View {
    
    @EnvironmentObject var weatherModelView: WeatherViewModel
    
    func getIcon(for weatherData: String) -> String{
        
        switch weatherData {
        case "Clear" : return "sun.max.fill"
        case "Rain": return "cloud.rain.fill"
        case "Clouds" : return "cloud.fill"
        default: return ""
        }
        
    }
    
    var body: some View{
        Image(systemName: getIcon(for: "\(weatherModelView.hourlyWeather?.hourly[0].weather[0].main ?? "Rain")"))
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .padding(.top)
        Text("\(String(format: "%.0f",weatherModelView.hourlyWeather?.hourly[0].tempature ?? 27))°")
            .font(.system(size: 100)).bold()
        Text("\((weatherModelView.hourlyWeather?.hourly[0].minAndSecond) ?? "12:00")")
            .font(.system(size: 30)).bold()
        Text("\(weatherModelView.coordinate?.name ?? "Turkey") \(weatherModelView.coordinate?.sys.country ?? "TR")")
            .font(.system(size: 20)).bold()
        Spacer()
        HStack(){
            ForEach(1..<5){i in
                VStack{
                    Image(systemName: getIcon(for: "\(weatherModelView.hourlyWeather?.hourly[i].weather[0].main ?? "Rain")"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("\(String(format: "%.0f",weatherModelView.hourlyWeather?.hourly[i].tempature ?? 27))°")
                        .font(.system(size: 30)).bold()
                    Text("\((weatherModelView.hourlyWeather?.hourly[i].minAndSecond) ?? "12:00")")
                        .font(.system(size: 20)).bold()
                    
                }.frame(maxWidth: .infinity)
            }
            
        }
    }
}




