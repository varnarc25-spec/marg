# Marg - Indian Trading App

A Zerodha-proof, beginner-friendly Indian trading app built with Flutter. This app provides a guided, opinionated trading experience focused on options and equity trading.

## 🎯 Features

### ✅ Completed Features

1. **Onboarding Flow**
   - Splash screen with brand identity
   - Language selection (English, हिंदी, తెలుగు, தமிழ்)
   - User goal selection
   - Experience level assessment
   - Risk appetite quiz (5 questions)
   - Account mode selection (Paper/Real Trading)

2. **Home Dashboard**
   - Personalized greeting
   - Portfolio snapshot with P&L
   - Risk meter visualization
   - Market overview (NIFTY, BANKNIFTY)
   - Quick action buttons

3. **Trade with Guidance**
   - Instrument selection (Equity/Options)
   - Symbol selection
   - Strategy suggestions
   - Risk warnings
   - Payoff preview charts
   - Trade confirmation

4. **Options Strategy Builder**
   - Strategy cards (Iron Condor, Straddle, etc.)
   - Strike price selector
   - Max Profit/Loss display
   - Breakeven points
   - Margin requirements

5. **Trade Journal & Psychology**
   - Trade history list
   - Trade detail screen
   - Emotion tracking (😄 😐 😟)
   - Notes input
   - AI-style explanations

6. **Learning Hub**
   - Educational content cards
   - Progress tracking
   - Video placeholders
   - Language-aware content

7. **Settings**
   - Language switching
   - Dark/Light theme toggle
   - Reset onboarding
   - App information

## 🏗️ Architecture

### Clean Architecture
- **Core**: Theme, constants, utilities
- **Data**: Models, repositories (mock JSON data)
- **Features**: Feature-based modules (onboarding, home, trade, journal, learning, settings)
- **Shared**: Reusable widgets and providers

### State Management
- **Riverpod**: Used for state management throughout the app
- Providers for: User profile, market data, portfolio, theme, language, onboarding status

### UI/UX
- **Material 3**: Modern Material Design
- **Indian Fintech Color Palette**: Trust-building blue, green for profits, red for losses
- **Smooth Animations**: Hero, fade, scale transitions
- **Responsive Design**: Works on Android & iOS

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # State management
  shared_preferences: ^2.3.2    # Local storage
  intl: ^0.20.2                 # Localization
  fl_chart: ^0.69.0             # Charts
  animations: ^2.0.11           # Animations
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.9.2 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone/Navigate to the project**
   ```bash
   cd marg
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Flow

1. **Splash Screen** → Brand introduction
2. **Onboarding** → Language → Goals → Experience → Risk Quiz → Account Mode
3. **Home Dashboard** → Portfolio → Market Data → Quick Actions
4. **Trade Flow** → Instrument → Symbol → Strategy → Confirm
5. **Journal** → View trades → Add emotions → Notes
6. **Learning** → Educational content → Progress tracking
7. **Settings** → Customize app preferences

## 🎨 Design Principles

- **Trust-building**: Clean, professional UI inspired by Zerodha
- **Beginner-friendly**: Simple language, guided flows
- **Vernacular-first**: Multi-language support
- **Visual feedback**: Clear P&L indicators, risk meters
- **Educational**: Built-in learning resources

## 📊 Mock Data

The app uses mock JSON data as specified:
- User Profile: USR001, Sai, Telugu, Beginner, Medium risk
- Market Data: NIFTY 50, BANKNIFTY with price and change
- Portfolio: ₹250,000 total, -₹1,240 today P&L
- Options Strategy: Iron Condor with profit/loss calculations
- Trade History: Sample trades with emotions and notes

## 🔧 Next Steps / Improvements

### Immediate
- [ ] Test app on physical devices (Android & iOS)
- [ ] Fix any runtime errors or import issues
- [ ] Add error handling for network failures
- [ ] Implement proper navigation stack management

### Short-term
- [ ] Add actual localization files (ARB files for i18n)
- [ ] Implement real backend API integration
- [ ] Add authentication flow
- [ ] Implement actual trading API connections
- [ ] Add push notifications

### Long-term
- [ ] Real-time market data integration
- [ ] Advanced charting with technical indicators
- [ ] Paper trading simulation engine
- [ ] AI-powered trade suggestions
- [ ] Social features (share trades, leaderboards)
- [ ] Advanced analytics and reporting

## 🐛 Known Issues

- Mock data only (no real backend)
- Localization strings are hardcoded (needs i18n setup)
- Charts are placeholder (needs real data integration)
- Onboarding reset requires app restart

## 📝 Code Structure

```
lib/
├── core/
│   ├── theme/          # App themes (light/dark)
│   ├── constants/      # App-wide constants
│   └── utils/          # Utility functions
├── data/
│   ├── models/         # Data models
│   └── repositories/   # Mock data repositories
├── features/
│   ├── onboarding/     # Onboarding flow
│   ├── home/           # Home dashboard
│   ├── trade/          # Trading features
│   ├── journal/        # Trade journal
│   ├── learning/       # Learning hub
│   └── settings/       # Settings screen
├── shared/
│   ├── widgets/        # Reusable widgets
│   └── providers/      # Riverpod providers
└── main.dart           # App entry point
```

## 🤝 Contributing

This is a professional trading app template. When extending:
1. Follow clean architecture principles
2. Use Riverpod for state management
3. Maintain Material 3 design guidelines
4. Add proper error handling
5. Write unit tests for business logic

## 📄 License

This project is created for educational and demonstration purposes.

---

**Built with ❤️ using Flutter**
