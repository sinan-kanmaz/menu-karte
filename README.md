flutter pub run flutter_flavorizr


flutterfire config \
  --project=qrmenu-dev-36a5e \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.qrmenu.dev \
  --macos-bundle-id=com.qrmenu.dev \
  --android-app-id=com.qrmenu.dev



flutterfire config \
  --project=my-digi-menu-stage \
  --out=lib/firebase_options_stage.dart

  flutterfire config \
  --project=menu-karte \
  --out=lib/firebase_options.dart


  CORS CONFIG

  echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json
  
  gsutil cors set cors-config.json gs://qrmenu-dev-36a5e.appspot.com
  
  gsutil cors get gs://qrmenu-dev-36a5e.appspot.com
