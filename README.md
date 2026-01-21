# 🇷🇸 Serbia Open Data Explorer

A cross-platform Flutter application for exploring and searching through Serbia's open data datasets. Browse hundreds of publicly available datasets from various government organizations with advanced filtering and search capabilities.

## 📋 Overview

Serbia Open Data Explorer provides an intuitive interface to discover, filter, and access open data resources published by Serbian government institutions. The application loads dataset metadata from a local CSV file and offers powerful search and filtering features to help users find relevant datasets quickly.

## ✨ Features

- **🔍 Real-time Search**: Search datasets by name or description with debounced input for optimal performance
- **🏢 Organization Filter**: Filter datasets by publishing organization
- **📄 Format Filter**: Find datasets available in specific formats (CSV, JSON, XML, etc.)
- **🏷️ Tag-based Filtering**: Discover datasets by topic tags
- **📅 Update Frequency Filter**: Filter by how often datasets are updated
- **📱 Responsive UI**: Material Design 3 interface with adaptive layouts
- **🌐 External Links**: Open dataset URLs directly in your browser
- **📊 Dataset Details**: View comprehensive information about each dataset including:
  - Description and metadata
  - Organization and license information
  - Available formats and tags
  - Update frequency
  - Direct links to data sources

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/rus89/serbia_open_data_explorer.git
   cd serbia_open_data_explorer
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Platform-specific Setup

The app supports all Flutter platforms:

- **Android**: API 21 or higher
- **iOS**: iOS 12.0 or higher
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **macOS**: macOS 10.14 or higher
- **Linux**: GTK 3.0+
- **Windows**: Windows 10 or higher

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point and home page
├── models/
│   └── dataset_entry.dart         # Dataset data model
├── services/
│   └── dataset_loader.dart        # CSV loading and data management
└── ui/
	 └── dataset_details_page.dart  # Dataset details view

assets/
└── data/
	 └── datasets/
		  └── datasets.csv           # Dataset metadata
```

## 🔧 Technology Stack

- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **CSV Package**: CSV parsing for dataset metadata
- **URL Launcher**: Opening dataset links in browser
- **Material Design 3**: Modern UI components

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.5+1 # State management
  csv: ^6.0.0 # CSV parsing
  url_launcher: ^6.3.2 # External URL handling
  path: ^1.9.1 # Path utilities
```

## 🎨 Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures representing datasets
- **Services**: Business logic for loading and managing data
- **UI**: Presentation layer with widgets and pages
- **State Management**: Provider pattern for reactive updates

### Key Components

#### DatasetLoader Service

- Loads CSV data from assets
- Parses dataset metadata
- Provides computed properties for filters (organizations, formats, tags, frequencies)
- Uses `ChangeNotifier` for state updates

#### SearchWidget

- Implements debounced search for performance
- Multiple dropdown filters working in combination
- Real-time result counting
- Clear all filters functionality

## 📊 Dataset Format

The application expects a CSV file with the following fields:

- ID
- Name
- Description
- URL
- Organization
- License
- Update Frequency
- Tags
- Resource Formats

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Serbian government open data initiatives
- Flutter community for excellent documentation and packages
- All contributors to the open data ecosystem

## 📞 Contact

For questions or feedback, please open an issue on GitHub.

---

Made with ❤️ using Flutter
