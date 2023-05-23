# Initial Config

## If using FlutterFire (eg. with astro_auth)

1. [Add firebase to the app](https://firebase.google.com/docs/flutter/setup)

`flutter pub add firebase_core`
`flutterfire configure`

1. Add to the top of main:

```dart
void main() async {
  -> WidgetsFlutterBinding.ensureInitialized();
  -> await Firebase.initializeApp(
  ->   options: DefaultFirebaseOptions.currentPlatform,
  ->   );

  ...

  runApp(const AppWidget());
}
```
