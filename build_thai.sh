#!/bin/bash

flutter clean
flutter pub get

# Thailand / YumWords
open ios/Runner.xcworkspace   # sanity check bundle ID BEFORE building

flutter build ios --dart-define=COUNTRY=thailand
