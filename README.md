# x-IMU3-App

## Development

### Original Flutter create command

`flutter create x-IMU3-App --project-name ximu3_app --org uk.co.x-io --platforms=android,ios`

### Updating dependencies

1. Run `flutter pub upgrade --major-versions`
2. Run `dart run build_runner build`
3. Run `dart run flutter_native_splash:create`
4. Run `flutter pub run flutter_launcher_icons`
5. Run `dart run ffigen`

### Updating x-IMU3 API

#### Android
1. Replace [android/app/src/main/jniLibs/arm64-v8a/libximu3.so](https://github.com/xioTechnologies/x-IMU3-App/blob/main/android/app/src/main/jniLibs/arm64-v8a/libximu3.so) with [latest](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-linux-android.zip)
2. Replace [android/app/src/main/jniLibs/x86_64/libximu3.so](https://github.com/xioTechnologies/x-IMU3-App/blob/main/android/app/src/main/jniLibs/x86_64/libximu3.so) with [latest](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-x86_64-linux-android.zip)

#### iOS
1. Replace [ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib) with [latest](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-apple-ios.zip)
2. Replace [ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib) with [latest](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-apple-ios-sim.zip)
3. Replace [ios/libximu3/libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib) with [latest](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-x86_64-apple-ios.zip)
4. Run `./libximu3.sh` from ios/libximu3 as working directory

#### ffigen
1. Replace [lib/core/api/Ximu3.h](https://github.com/xioTechnologies/x-IMU3-App/blob/main/lib/core/api/Ximu3.h) with latest
2. Run `dart run ffigen`

## Release

1. Update version in [pubspec.yaml](https://github.com/xioTechnologies/x-IMU3-App/blob/main/pubspec.yaml) and push tag
2. Add new version in [appstoreconnect.apple.com](https://appstoreconnect.apple.com/)
3. Add Build, Save, Add for Review, Submit to App Review
