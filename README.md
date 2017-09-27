# Demonstration of a terminating Push Notification Service Extension on iOS 11

This is a minimal sample project in Xcode 9 and iOS 11 that demonstrates the unintentional termination of a push notification service with the error code `Program ended with exit code: 0` when in debug mode. This makes it impossible to debug service extensions when using iOS 11 devices.

Versions used:

- Xcode 9.0 (9A235)
- iPhone 6 with iOS 11 (15A372)

## Steps to reproduce

1. Checkout the project

2. In the developer portal of Apple, setup an AppId with Push Notifications enabled in *Capabilities*, make sure to adjust the *bundle id* in the project accordingly.

3. Create the needed certificates for sending push notifications in the *development* configuration and export them from the keychain into a `aps_development.pem` file

4. Build the main project (scheme *ServiceExtensionMinimalProject*) on a real device

5. Build and run *ServiceExtension* scheme on a real device and select the previously built extension to run with.

6. Once the app is started, put it to background (keep it connected to the debugger)

7. Send a rich push notification to the correct device token (it's printed in the console). I use [Houston](https://github.com/nomad/houston) to send a push notifications easily:

   ```bash
   apn push "160dc27b1f2cdc72cc5262114ae29a78d040c71b5c9363ee4169817affe322c1"  -c aps_development.pem  -p -P '{"aps": {"alert": "New Push Notification", "badge": 0, "sound": "", "mutable-content": 1, "category": "myCategory", "content-available": 1}}'
   ```

8. Once the push notification arrives, it does not contain the *[modified]* prefix, which indicates that the push notification service extension was not properly executed. This is also visible by the error message in the console `Program ended with exit code: 0`. Breakpoints in the push notification service extension do not work at all.

## Notes

- If you run this project (*ServiceExtension* scheme) without the debugger attached, the service extension is not killed and the push notification message contains the *[modified]* prefix (thus, the service extension was able to run and modify the payload).
- If you run the same app on a device with iOS 10.3.3 (14G60), the push notification service extension is correctly executed, the payload modified and also breakpoints in the debugger are working fine.
- This does not seem to be a problem with memory pressure since the push notification service extension is not doing anything at all.