# MyWeatherApp 🌤️

A beautiful and responsive Flutter weather application that provides real-time weather updates and 5-day forecasts. The app features dynamic animated backgrounds using Lottie based on the current weather conditions.

## Features ✨

- **Real-time Weather Data**: Current temperature, wind speed, humidity, and more.
- **Auto-Detect Location**: Instantly fetches precise weather for your exact GPS coordinates upon launch using `geolocator`.
- **5-Day / 3-Hour Forecast**: Detailed forecast scrollable by hour and day.
- **Interactive Data Cards**: Swipe vertically to switch between **Temperature**, **Wind Speed**, and **Humidity**.
- **Dynamic Animations**: Beautiful Lottie animations that change based on weather conditions.
- **Offline & Error Resilience**: Gorgeous custom error screens with retry mechanisms and Lottie graphics for unhandled exceptions or connection drops.
- **Smart Data Caching**: Remembers your last searched city across app restarts using `shared_preferences`.
- **Pull-to-Refresh**: Easily reload data with smart 5-minute cooldown locks to prevent API spam.
- **Intelligent Theming**: Automatically switches between Light and Dark mode depending on the active time of day.
- **Custom UI**: Glassmorphism/neumorphism effects and custom fonts (MadimiOne, Oxanium).

## Design Workflow 🎨

This project followed a structured design-to-development process:
1.  **Prototyping**: The entire UI/UX was first designed and prototyped in **Figma** to ensure a seamless user experience.
2.  **Implementation**: The design was then pixel-perfectly translated into **Flutter** code.

## Screenshots 📸

<p align="center">
  <img src="assets/screenshots/location_permission.png" alt="Location Permission (Dark)" width="200" />
  <img src="assets/screenshots/home_screen_light.jpeg" alt="Home Screen (Light)" width="200" />
  <img src="assets/screenshots/details_screen_dark.jpeg" alt="Details Screen (Dark)" width="200" />
  <img src="assets/screenshots/error_screen.png" alt="Error Screen (Light)" width="200" />
</p>

## Tech Stack 🛠️

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `setState` & `WidgetsBindingObserver` (Native Lifecycle)
- **Networking/Data**: `http`, `shared_preferences`, `geolocator`
- **Animations**: `lottie`
- **Responsiveness**: `flutter_screenutil`
- **Icons**: `flutter_svg`, `cupertino_icons`
- **Environment**: `flutter_dotenv`

## Project Structure 📂

```
lib/
├── core/           # Core utilities and helpers
├── models/         # Data models for parsing API responses
├── presentation/   # UI Screens (Home Screen)
├── widgets/        # Reusable UI components
└── main.dart       # Entry point of the application
```

## Getting Started 🚀

Follow these steps to set up the project locally.

### Prerequisites

- Flutter SDK installed.
- An API Key (likely from OpenWeatherMap or similar service, check the code for the specific provider).

### Installation

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/milanrnw/WEATHER_TEST.git
    cd myweatherapp
    ```

2.  **Install dependencies**:

    ```bash
    flutter pub get
    ```

3.  **Environment Setup**:

    Create a `.env` file in the root directory and add your API credentials:

    ```env
    API_KEY=your_api_key_here
    # Add other required environment variables if any
    ```

4.  **Run the App**:

    ```bash
    flutter run
    ```

## Acknowledgments 🙌

- Weather data provided by [Your Weather API Provider].
- Lottie animations from [LottieFiles](https://lottiefiles.com/).
