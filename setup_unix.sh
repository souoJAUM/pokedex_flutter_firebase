#!/usr/bin/env bash
set -e
flutter create . --platforms=android,web
flutter pub get
flutter doctor
echo "Finalizado. Para rodar no Chrome: flutter run -d chrome"
