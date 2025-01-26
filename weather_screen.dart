// Import necessary packages and libraries
import 'dart:convert'; // Provides utilities for JSON encoding and decoding
import 'dart:ui'; // Provides utilities for rendering effects like blur
import 'package:intl/intl.dart'; // Provides utilities for date and time formatting
import 'package:flutter/material.dart'; // Core Flutter package for building UI
import 'package:weather_app/additional_info_item.dart'; // Custom widget for additional information
import 'package:weather_app/secreats.dart'; // Contains API key for OpenWeather
import 'package:weather_app/timely_forcast_item.dart'; // Custom widget for hourly forecast
import 'package:http/http.dart' as http; // For making HTTP requests

// Define the WeatherScreen widget as a stateful widget
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key}); // Constructor

  @override
  State<WeatherScreen> createState() => _WeatherScreenState(); // Creates the state for this widget
}

// The state class for WeatherScreen
class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState(); // Call the parent class's initState
    getCurrentWeather(); // Fetch current weather data when the widget is initialized
  }

  // Function to fetch current weather data from OpenWeather API
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city ='delhi'; // City for which weather data is fetched
      final res = await http.get(
        // Make an HTTP GET request to the weather API
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city,&APPID=$OpenWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body); // Parse the JSON response
      if (data['cod'] != '200') {
        // Check if the response code indicates success
        throw 'an unexpected error'; // Throw an error if the code is not '200'
      }
      return data; // Return the parsed weather data
    } catch (e) {
      throw e.toString(); // Catch and rethrow any exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for the WeatherScreen widget
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WEATHER APP',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text for the app bar title
          ),
        ),
        centerTitle: true, // Center the app bar title
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // Trigger a rebuild of the UI when refresh is pressed
              });
            },
            icon: const Icon(Icons.refresh), // Refresh icon
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(), // Fetch weather data asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(
              child: const CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            // Display an error message if data fetching fails
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          // Parse the fetched weather data
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0]; // Current weather data
          final currentTemp = data['list'][0]['main']['temp']; // Current temperature
          final currentSky = currentWeatherData['weather'][0]['main']; // Current sky condition
          final currentPressure = currentWeatherData['main']['pressure']; // Current pressure
          final currentwindspeed = currentWeatherData['wind']['speed']; // Current wind speed
          final currentHumidity = currentWeatherData['main']['humidity']; // Current humidity

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Main card displaying current weather details
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 20, // Elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded corners
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        // Apply a blur effect
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Display current temperature
                              Text(
                                '${(currentTemp - 273.15).round()} C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10), // Spacing
                              // Display an icon based on current sky condition
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.water_drop,
                                size: 64,
                              ),
                              const SizedBox(height: 10),
                              // Display current sky description
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Section for hourly weather forecast
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 30, // Number of forecast items
                    scrollDirection: Axis.horizontal, // Scroll horizontally
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final hourlysky = data['list'][index + 1]['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForcast['dt_txt']); // Parse forecast time
                      return HourlyForcastItem(
                        time: DateFormat.j().format(time), // Format time to 12-hour clock
                        temperature: hourlyForcast['main']['temp'].toString(),
                        icon: hourlysky == 'Clouds' || hourlysky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Section for additional weather information
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Display additional information like humidity, wind speed, and pressure
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItems(
                      icon: Icons.water_drop, // Humidity icon
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItems(
                      icon: Icons.air, // Wind speed icon
                      label: 'Wind Speed',
                      value: currentwindspeed.toString(),
                    ),
                    AdditionalInfoItems(
                      icon: Icons.beach_access, // Pressure icon
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
