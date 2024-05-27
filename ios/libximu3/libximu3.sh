rm -rf libximu3.xcframework

lipo -create libs/x-IMU3-API-aarch64-apple-ios/libximu3.dylib -output iPhoneOS/libximu3.framework/libximu3
chmod +x iPhoneOS/libximu3.framework/libximu3
cd iPhoneOS/libximu3.framework/
install_name_tool -id @rpath/libximu3.framework/libximu3 libximu3
cd ../../

lipo -create libs/x-IMU3-API-aarch64-apple-ios-sim/libximu3.dylib libs/x-IMU3-API-x86_64-apple-ios/libximu3.dylib -output iPhoneSimulator/libximu3.framework/libximu3
chmod +x iPhoneSimulator/libximu3.framework/libximu3
cd iPhoneSimulator/libximu3.framework/
install_name_tool -id @rpath/libximu3.framework/libximu3 libximu3
cd ../../

xcodebuild -create-xcframework \
-framework "iPhoneOS/libximu3.framework" \
-framework "iPhoneSimulator/libximu3.framework" \
-output "libximu3.xcframework"
