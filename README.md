# Workshop Sample App

This is a sample demonstrating how to build a simple ChatGPT client using Flutter, Firebase and the ChatGPT API.

## Getting Started

This project contains 2 directories:
1. `chatgpt_flutter` - The Flutter client
2. `chatgpt_firebase` - The Firebase functions

### Pre-requisites

1. [Install the Flutter SDK](https://flutter.dev/docs/get-started/install)
2. Follow the instructions [here to install Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli)
3. Install the FlutterFire CLI: `flutter pub global activate flutterfire_cli`
4. You will need a Firebase project. If you don't have one, create one [here](https://console.firebase.google.com/).
5. You will need a ChatGPT API key. If you don't have one, create one [here](https://chatgpt.com/).
6. Put your ChatGPT API key & organization ID in [`functions/.env`](./chatgpt_firebase/functions/.env).

