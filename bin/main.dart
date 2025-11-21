import 'package:dart_assincronismo/screens/account_screen.dart';

void main() {
  AccountScreen accountScreen = AccountScreen();

  accountScreen.displayHeader();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
}

