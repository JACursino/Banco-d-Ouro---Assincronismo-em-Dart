import 'package:dart_assincronismo/models/exceptions/transaction_exceptions.dart';
import 'package:dart_assincronismo/screens/account_screen.dart';
import 'package:dart_assincronismo/services/transaction_service.dart';



void main() {
   TransactionService().makeTransaction(
    idSender: "ID001",
    idReceiver: "ID002",
    amount: 5000,
  );

  try {
    TransactionService().makeTransaction(
      idSender: "ID001",
      idReceiver: "ID002",
      amount: 5000,
    );
  } on InsufficientFundsException catch (e) {
    print(e.message);
    print(
        "${e.cause.name} possui saldo ${e.cause.balance} que é menor que ${e.amount + e.taxes}");
  }

/*   AccountScreen accountScreen = AccountScreen();

  accountScreen.displayHeader();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
 */
}
