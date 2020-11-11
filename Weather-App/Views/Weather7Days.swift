//
//  Weather7Days.swift
//  Weather-App
//
//  Created by Anil on 11/11/20.
//

import SwiftUI
import UIKit

struct Weather7Days: View {
    
   @State var coordinate: Coordinate?
   @State var weatherData: WeatherData?
    
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: WeatherBody.changeColors(for: weatherData?.daily[0].weather[0].main ?? "Rain")), center: .center, startRadius: 1, endRadius: 1000)
                .ignoresSafeArea()
                .opacity(0.5)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(0..<(weatherData?.daily.count)!){i in
                        GeometryReader{ geometry in
                        WeatherCard(coordinate: $coordinate, weatherData: $weatherData, i: i)
                            .rotation3DEffect(
                                Angle(degrees: Double(geometry.frame(in: .global).minX) / -20),
                                axis: (x:0, y: 10.0, z:0))
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }.frame(height: UIScreen.main.bounds.height - 250)
            .padding(.leading, 10)
            
        }
    }


}

struct Weather7Days_Previews: PreviewProvider {
    static var previews: some View {
        Weather7Days()
    }
}

struct WeatherCard: View {
    
    @Binding var coordinate: Coordinate?
    @Binding var weatherData: WeatherData?
    var i:Int
    
    var body: some View{
        ZStack{
            RadialGradient(gradient: Gradient(colors: WeatherBody.changeColors(for: weatherData?.daily[i].weather[0].main ?? "Rain")), center: .center, startRadius: 1, endRadius: 1000)
            VStack{
                Image(systemName: WeatherBody.getIcon(for: "\(weatherData?.hourly[i].weather[0].main ?? "Rain")"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("\((weatherData?.daily[i].weather[0].description) ?? "clear sky")")
                    .padding(.top)
                    .font(.system(size: 20))
                HStack{
                    Text("\(String(format: "%.0f",weatherData?.daily[i].temp.day ?? 27))°")
                        .font(.system(size: 100)).bold()
                    Text("/")
                        .font(.system(size: 70)).bold()
                    Text("\(String(format: "%.0f",weatherData?.daily[i].temp.night ?? 27))°")
                        .font(.system(size: 50)).bold()
                }
                Text("\((weatherData?.daily[i].yearMonthDay) ?? "10/10/2020")")
                    .font(.system(size: 25)).bold()
                Text("\(coordinate?.name ?? "Turkey") \(coordinate?.sys.country ?? "TR")")
                
                
                
            }.frame(width: UIScreen.main.bounds.width - 50)
        }.cornerRadius(25)
        .shadow(radius: 5)
        .foregroundColor(.white)
        .padding()
        
    }
    
    
}



