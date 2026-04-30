@echo off
echo Gerando plataformas Android e Web, se necessario...
flutter create . --platforms=android,web

echo Baixando dependencias...
flutter pub get

echo Verificando ambiente...
flutter doctor

echo Finalizado. Para rodar no Chrome: flutter run -d chrome
pause
