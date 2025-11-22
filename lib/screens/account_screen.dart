import 'package:dart_assincronismo/services/account_service.dart';
import 'package:dart_assincronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:uuid/uuid.dart'; // Importe pacote para geração de códigos aleatórios

class AccountScreen {
  final AccountService _accountService = AccountService();
  final Uuid _uuid = Uuid();

  void initializeStream() {
    _accountService.streamInfos.listen((event) {
      print(event);
    });
  }

  // NOVO MÉTODO: Exibe o cabeçalho de boas-vindas
  void displayHeader() {
    print("--------------------------------------------------");
    print("      🏦 BEM-VINDO(A) AO BANCO D'OURO 🥇\n");
    print("    💎 Atendimento Rápido e Seguro :  Lewis 🔒");
    print("--------------------------------------------------");
    print("");
  }

  void runChatBot() async {
    bool isRunning = true;
    while (isRunning) {
      print("Como eu posso te ajudar? (digite o número desejado)");
      print("1 - Ver todas sua contas.");
      print("2 - Adicionar nova conta.");
      print("3 - Sair\n");

      String? input = stdin.readLineSync();

      if (input != null) {
        switch (input) {
          case "1":
            {
              await _getAllAccounts();
              break;
            }
          case "2":
            {
              print("Qual o nome completo da pessoa?");
              String? name = stdin.readLineSync();

              if (name != null) {
                print("Qual o saldo inicial da conta?");
                String? balanceString = stdin.readLineSync();

                if (balanceString != null) {
                  double? balance = double.tryParse(balanceString);

                  if (balance != null) {
                    // Separar Nome e Sobrenome e chamar a nova função de adição
                    await _readAndAddAccount(name, balance);
                  } else {
                    print("Valor de saldo inválido. Tente novamente.");
                  }
                }
              }
              break;
            }
          case "3":
            {
              isRunning = false;
              print("Te vejo na próxima.");
              break;
            }
          default:
            {
              print("Não entendi. Tente novamente.");
            }
        }
      }
    }
  }

  _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print(listAccounts);
    } on ClientException catch (clientException) {
      /*Dentro de catch pode ser atribuido qualquer nome*/
      print("------------------------------------------------");
      print("\nNão foi possível alcançar o servidor.");
      print("Tente novamente mais tarde.\n");
      print(clientException.message);
      print(clientException.uri);
      print("------------------------------------------------");
      print("");
    } on Exception {
      //Pai
      print("\nNão consegui recuperar os dados da conta.");
      print("Tente novamente mais tarde.\n");
      print("");
    } finally {
      //Sempre vai ser executado
      print("${DateTime.now()} | Ocorreu uma tentativa de consulta.\n");
    }
  }

  // Novo método para tratar a string de nome e chamar o serviço assíncrono
  _readAndAddAccount(String fullName, double balance) async {
    // Lógica de separação de nome e sobrenome (como no passo anterior)
    List<String> parts = fullName.split(" ");
    String firstName = parts.isNotEmpty ? parts.first : "Desconhecido";
    // O restante da string, se houver, será o sobrenome.
    String lastName = parts.length > 1
        ? parts.sublist(1).join(" ")
        : "Não Informado";

    // NOVO ID: Geração de um ID ÚNICO
    // v4 gera um ID aleatório (version 4) - temos algo em torno de 7 versoões de geração de IDs
    String newId = _uuid.v4();

    // Geração da nova Account com os dados lidos + ID único
    Account newAccount = Account(
      id: newId,
      name: firstName,
      lastName: lastName,
      balance: balance,
    );
    await _accountService.addAccount(newAccount);
  }
}
