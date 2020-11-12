# Weather-App-SwiftUI-MVVM

Weather app is a app that it shows entered city or your curretn location weather data. As a back end weather service it uses [OpenWeatherMap](https://openweathermap.org/) API to fetch weather data.

To secure API key inside app it uses [Key Chain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper) to secure it. When the application starts, it fetches api key from [Firebase Real Time Database](https://firebase.google.com/) and add it to the [Key Chain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper). When app need to use api key to send request to the API it gets the api key from [Key Chain Wrapper](https://github.com/jrendel/SwiftKeychainWrapper) and creates URL.

Because app uses [Firebase Real Time Database](https://firebase.google.com/) if API key changes, app will get notified and API key will change in all devices automatically.


