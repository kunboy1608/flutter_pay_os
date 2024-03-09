<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This is not an official library from PayOs. PayOs provides an automated payment solution powered by VietQR.

## Features

The library provides functions, functions, and methods to integrate PayOs into Flutter applications for all 6 platforms: Android, iOs, Windows, Web, MacOs and Linux

## Getting started

You need to register for PayOs service to get 3 things apiKey, clientKey and checksumKey.
[PayOs homepage](https://payos.vn/)

## Usage

Add code below into file pubspec.yaml
```
flutter_pay_os:
    git: 
        url: https://github.com/kunboy1608/flutter_pay_os.git
        ref: main # branch name
```
If you use this package for macOs, please add text below into macos/Runner/DebugProfile.entitlements and macos/Runner/Release.entitlements in your project.
```
<key>com.apple.security.network.client</key>
<true/>
```

All done. Good luck.

## Example
```
git clone https://github.com/kunboy1608/flutter_pay_os.git
cd flutter_pay_os/example
flutter run
```

## Additional information

All contributions are welcome. You can create an issue, or pull request.
