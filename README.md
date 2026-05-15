# WASH-Ed-Community-Resilience-Platform

The WASH-Ed Community Resilience Platform is a cross-platform mobile application designed to support Filipino families with children aged 6–12 prepare for flood emergencies while promoting WASH (Water, Sanitation, and Hygiene) education.

The app combines:
- Emegency preparedness resources
- Child-friendly WASH education
- Flood risk warnings

Educational content will feature the Kiko Carabao character and utilise WASH-Ed curriculum materials to teach children hygiene behaviours that are critical during disasters when waterborne diseases increase.

The platform will integrate hazard data from [API] to provide location-based flood warnings for families and preparedness information for families. 

## Project Goals
The proposed Minimum Viable Product (MVP) aims to achieve the following outcomes
- Deliver accessible and engaging WASH education for children aged 6–12 and their families
- Provide real-time flood alerts and hazard information through integration with official government data sources (Gov API TBA) or an alternative adequate API
- Support family emergency preparedness via practical tools such as checklists and evacuation guidance
- Create an intuitive, child-friendly user experience leveraging the Kiko Carabao character
- Ensure usability in low-connectivity environments, including offline access to essential content

## Target Users
### Primary Users
- Filipino Children aged 6-12
- Parents/guardians and educators in flood-prone communities

### Secondary Users
- Community health workers
- Local government units

## Features of App
- Location based flood alerts
- WASH Education Modules featuring Kiko Carabao
- User account types
- Offline functionality for core content
- Flood preparedness checklists and evacuation guidance
- Direct links to official hazard monitoring websites
- Interactive mini games for WASH learning

## Non Functional Requirements
- Fast loading times
- Child-friendly and intuitive interface
- Accessibility for users with low digital literacy
- Low-bandwidth optimisation

## Tech Stack
| Layer | Technology |
|-------|------------|
| Mobile Framework | Flutter (Dart) |
| Backend | |
| Database & Auth | |
| Push Notifications | |
| Offline Storage ||
| API | |
| UI/UX Design | Figma |
| Mini Games | Links to itch.io |
| Version Control | GitHub |
| Project Management | JIRA |

## Configuration / Environment Variables

## System Prerequisites
1. Flutter SDK - [https://docs.flutter.dev/install]
2. Dart SDK (included with Flutter)
3. Android Studio - for Android builds
[https://docs.flutter.dev/platform-integration/android/setup]
[https://docs.flutter.dev/tools/android-studio]
4. Git

## Installation Instructions
### 1. Clone the Repository
```
git clone https://github.com/nataliaavu/WASH-Ed-Community-Resilience-Platform
cd wash-ed-community-resilience-platform
```

### 2. Install Flutter Dependencies
```
flutter pub get
```

### 3. Configure Environment Variables?

IDK WHAT TO DO FOR INSTALLATION INSTRUCTIONS

## Project Structure
This is a Flutter project targeting Android and iOS
```
wash-ed-resilience-platform/
├── android/                        # Android platform files
│   ├── app/
│   │   └── src/
│   │       └── build.gradle.kts
│   ├── gradle/wrapper/
│   │   └── gradle-wrapper.properties
│   ├── build.gradle.kts
│   ├── gradle.properties
│   └── settings.gradle.kts
│
├── assets/                         # Static assets bundled with the app
│   ├── kiko/                       # Kiko Carabao character sprites
│   │   ├── WashEd_kiko_sprite_base.png
│   │   ├── WashEd_kiko_sprite_cheer.png
│   │   ├── WashEd_kiko_sprite_sad.png
│   │   ├── WashEd_kiko_sprite_side-jump.png
│   │   ├── WashEd_kiko_sprite_stress.png
│   │   ├── WashEd_kiko_sprite_thumbs-up.png
│   │   └── washed-carabao_sprite_defeat.png
│   └── wash-ed/                    # WASH-Ed branding and logo assets
│       ├── WASHEd_logo_2022_icon_drop-shadow.png
│       ├── WASHEd_logo_2022_icon_no-shadow.png
│       ├── WASHEd_logo_2022_og_drop-shadow.png
│       ├── WASHEd_logo_2022_og_no-shadow.png
│       ├── WASHEd_logo_2022_one-text_drop-shadow.png
│       ├── WASHEd_logo_2022_one-text_no-shadow.png
│       ├── WASHEd_logo_2022_two-text_drop-shadow.png
│       ├── WASHEd_logo_2022_two-text_no-shadow.png
│       └── masy-x-washed_badge-samples_v1.png
│
├── ios/                            # iOS platform files
│   ├── Flutter/
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   └── Release.xcconfig
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   └── Runner/
│       ├── Assets.xcassets/
│       │   ├── AppIcon.appiconset/
│       │   └── LaunchImage.imageset/
│       ├── Base.lproj/
│       │   ├── LaunchScreen.storyboard
│       │   └── Main.storyboard
│       ├── AppDelegate.swift
│       ├── Info.plist
│       ├── Runner-Bridging-Header.h
│       └── SceneDelegate.swift
│
├── lib/                            # Main Flutter/Dart source code
│   ├── models/
│   │   └── weather_api.dart        # Weather/flood API data models
│   ├── views/
│   │   ├── home/
│   │   │   └── home_page.dart      # Main dashboard with weather widget and flood risk
│   │   ├── learn/
│   │   │   └── learn_page.dart     # WASH education modules and resources
│   │   ├── onboarding/
│   │   │   ├── init_page.dart      # App entry / splash
│   │   │   └── onboarding_page.dart # Welcome carousel screens
│   │   ├── prepare/
│   │   │   └── prepare_page.dart   # Flood guidance, checklists, emergency contacts
│   │   └── setup/
│   │       ├── setup_page.dart     # Setup flow coordinator
│   │       ├── setup_role_page.dart    # Student / Educator role selection
│   │       ├── setup_name_page.dart   # User name entry
│   │       ├── setup_location_page.dart # Province/municipality selection
│   │       └── setup_squad_page.dart  # Safety squad / emergency contacts setup
│   ├── widgets/
│   │   ├── modules_list.dart       # Reusable learning modules list widget
│   │   └── weather_widget.dart     # Weather and flood risk display widget
│   ├── home.dart                   # Home shell / bottom nav coordinator
│   ├── profile.dart                # Profile screen (details, account type, locations, language)
│   └── main.dart                   # App entry point
│
├── test/
│   └── widget_test.dart            # Widget tests
│
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── devtools_options.yaml
├── pubspec.lock
├── pubspec.yaml                    # Flutter dependencies and asset declarations
└── README.md
```


## Contributors
| Name | Role |
|------|------|
| Natalia Vu | Team Lead / Full Stack Developer |
| Alyssa Guerrero | Business Analyst / Front End Developer|
| Bidhan Battachan | Back End Developer / Tester |
| Jin Feng | Back End Developer / Tester |
| Matt Aducayen | Back End Developer |
| William Lay | Front End Developer |

## Client
Developed in collaboration with: **WASH Education Pty Ltd.**
- Thomas Da Jose
- Arielle Struhl
- Gryan Perez

## License
This project was developed for educational and research purposes in collaboration with WASh-Ed. All educational content and character assets remain the property of WASH Education Pty Ltd.
