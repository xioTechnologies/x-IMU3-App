# x-IMU3-App

## Original flutter create command

`flutter create x-IMU3-App --project-name ximu3_app --org uk.co.x-io --platforms=android,ios`

## Updating x-IMU3 API

### Android
1. Replace /android/app/src/main/jniLibs/arm64-v8a/libximu3.so with https://github.com/xioTechnologies/x-IMU3-Software/releases/download/v1.4.4/x-IMU3-API-aarch64-linux-android.zip
2. Replace /android/app/src/main/jniLibs/x86_64/libximu3.so with https://github.com/xioTechnologies/x-IMU3-Software/releases/download/v1.4.4/x-IMU3-API-x86_64-unknown-linux-gnu.zip

### iOS
1. Replace ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib with https://github.com/xioTechnologies/x-IMU3-Software/releases/download/v1.4.4/x-IMU3-API-aarch64-apple-ios.zip
2. Replace ios/libximu3/libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib with https://github.com/xioTechnologies/x-IMU3-Software/releases/download/v1.4.4/x-IMU3-API-aarch64-apple-ios-sim.zip
3. Replace ios/libximu3/libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib with https://github.com/xioTechnologies/x-IMU3-Software/releases/download/v1.4.4/x-IMU3-API-x86_64-apple-ios.zip
4. Run `./libximu3.sh` from ios/libximu3 as working directory

### ffigen
1. Replace lib/core/api/Ximu3.h with https://github.com/xioTechnologies/x-IMU3-Software/blob/main/x-IMU3-API/C/Ximu3.h
2. Run `dart run ffigen`

## Generating splash screen assets

`dart run flutter_native_splash:create`
