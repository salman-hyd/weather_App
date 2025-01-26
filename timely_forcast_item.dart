// Import the necessary Flutter package
import 'package:flutter/material.dart';

// A stateless widget representing a single item in the hourly weather forecast
class HourlyForcastItem extends StatelessWidget {
  // Time of the forecast (e.g., "3 PM")
  final String time;

  // Temperature at the forecasted time (e.g., "25°C")
  final String temperature;

  // Icon representing the weather condition (e.g., sun, cloud)
  final IconData icon;

  // Constructor to initialize the widget's properties
  const HourlyForcastItem({
    super.key, // Optional key for widget identification
    required this.time, // Time is required and must be provided
    required this.temperature, // Temperature is required and must be provided
    required this.icon, // Icon is required and must be provided
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // Adds shadow effect to the card for better visibility
      child: Container(
        width: 100, // Fixed width for the forecast item
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Rounded corners for the card
        ),
        padding: const EdgeInsets.all(8.0), // Adds padding inside the container
        child: Column(
          children: [
            // Display the time of the forecast
            Text(
              time,
              style: const TextStyle(
                fontSize: 18, // Font size for time
                fontWeight: FontWeight.bold, // Bold font for emphasis
              ),
              maxLines: 1, // Ensures the text doesn't overflow
              overflow: TextOverflow.ellipsis, // Truncates overflowing text with "..."
            ),
            const SizedBox(height: 5), // Spacing between time and icon

            // Display the weather condition icon
            Icon(
              icon,
            ),
            const SizedBox(height: 5), // Spacing between icon and temperature

            // Display the temperature at the forecasted time
            Text(
              temperature,
              style: const TextStyle(
                fontSize: 14.5, // Slightly smaller font for the temperature
              ),
            ),
          ],
        ),
      ),
    );
  }
}
