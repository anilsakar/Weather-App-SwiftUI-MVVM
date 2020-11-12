# Weather-App-SwiftUI-MVVM

Weather app is an app that shows entered city or your current location weather data. As a back end weather service it uses [OpenWeatherMap](https://openweathermap.org/) API to fetch weather data.

To secure API keys inside the app it uses [Keychain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper) to secure it. When the application starts, it fetches api key from [Firebase Real Time Database](https://firebase.google.com/) and adds it to the [Keychain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper). When an app needs to use an api key to send a request to the API it gets the api key from [Keychain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper) and creates the URL.

Because the app uses [Firebase Real Time Database](https://firebase.google.com/) if API key changes, the app will get notified and API key will change in all devices automatically.


--Opening App Allow Location Once--  
![opening-allow-once](https://user-images.githubusercontent.com/27813389/98970046-8fff8180-2520-11eb-957a-58d045fdf23a.gif)

--Opening App Allow Location Everytime--  
![openin-allow-everytime](https://user-images.githubusercontent.com/27813389/98970126-a3125180-2520-11eb-837f-6973a495ee38.gif)

--My Location Button--  
![my-location-button](https://user-images.githubusercontent.com/27813389/98970198-b7eee500-2520-11eb-9bef-bc454b13e29c.gif)

--Search City--  
![search-city](https://user-images.githubusercontent.com/27813389/98970265-c9d08800-2520-11eb-914d-869a1dc7ad00.gif)

--See Searched City 7 Day Weather Forecast--  
![see-7-day-forecast](https://user-images.githubusercontent.com/27813389/98970349-e2d93900-2520-11eb-8d58-db0654b3f525.gif)



