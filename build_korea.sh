#!/bin/bash

flutter clean
flutter pub get

# Korea
open ios/Runner.xcworkspace   # sanity check bundle ID BEFORE building

flutter build ios --dart-define=COUNTRY=korea
