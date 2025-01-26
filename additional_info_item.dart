// Import the necessary Flutter package
import 'package:flutter/material.dart';

// A stateless widget that represents an item showing additional weather information
class AdditionalInfoItems extends StatelessWidget {
  // Icon to visually represent the information
  final IconData icon;

  // Label to describe the type of information (e.g., "Humidity", "Wind Speed")
  final String label;

  // Value to display the data (e.g., "70%", "10 km/h")
  final String value;

  // Constructor to initialize the widget's properties
  const AdditionalInfoItems({
    super.key, // Optional key for widget identification
    required this.icon, // The icon is required and must be provided
    required this.label, // The label is required and must be provided
    required this.value, // The value is required and must be provided
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the provided icon
        Icon(
          icon,
        ),
        const SizedBox(height: 8), // Add vertical spacing between icon and label

        // Display the label with a specific text style
        Text(
          label,
          style: TextStyle(
            fontSize: 16, // Set the font size for the label
          ),
        ),
        const SizedBox(height: 8), // Add vertical spacing between label and value

        // Display the value with bold styling for emphasis
        Text(
          value,
          style: const TextStyle(
            fontSize: 20, // Larger font size for better visibility
            fontWeight: FontWeight.bold, // Bold text for the value
          ),
        ),
      ],
    );
  }
}
