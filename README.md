# x-IMU3-App

## Original flutter create command

`flutter create x-IMU3-App --project-name ximu3_app --org uk.co.x-io --platforms=android,ios`

## Updating x-IMU3 API

### Android
1. Replace [android/app/src/main/jniLibs/arm64-v8a/libximu3.so](https://github.com/xioTechnologies/x-IMU3-App/blob/main/android/app/src/main/jniLibs/arm64-v8a/libximu3.so) with latest [x-IMU3-API-aarch64-linux-android.zip](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-linux-android.zip)
2. Replace [android/app/src/main/jniLibs/x86_64/libximu3.so](https://github.com/xioTechnologies/x-IMU3-App/blob/main/android/app/src/main/jniLibs/x86_64/libximu3.so) with latest [x-IMU3-API-x86_64-linux-android.zip](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-x86_64-linux-android.zip)

### iOS
1. Replace [ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib) with latest [x-IMU3-API-aarch64-apple-ios.zip](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-apple-ios.zip)
2. Replace [ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib) with latest [x-IMU3-API-aarch64-apple-ios-sim.zip](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-aarch64-apple-ios-sim.zip)
3. Replace [ios/libximu3/libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib](https://github.com/xioTechnologies/x-IMU3-App/blob/main/ios/libximu3/libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib) with latest [x-IMU3-API-x86_64-apple-ios.zip](https://github.com/xioTechnologies/x-IMU3-Software/releases/latest/download/x-IMU3-API-x86_64-apple-ios.zip)
4. Run `./libximu3.sh` from ios/libximu3 as working directory

### ffigen
1. Replace [lib/core/api/Ximu3.h](https://github.com/xioTechnologies/x-IMU3-App/blob/main/lib/core/api/Ximu3.h) with latest
2. Run `dart run ffigen`

## Generating splash screen assets

`dart run flutter_native_splash:create`

## Generating launcher screen assets

`flutter pub run flutter_launcher_icons`
