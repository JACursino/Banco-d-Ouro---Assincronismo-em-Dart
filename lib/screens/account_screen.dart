//import 'package:dart_assincronismo/services/account_service.dart';
import 'package:dio/dio.dart';
import 'package:dart_assincronismo/services/account_dio_service.dart';
import 'package:dart_assincronismo/models/account.dart';
//import 'package:http/http.dart';
import 'dart:io';
import 'package:uuid/uuid.dart'; // Importe pacote para geração de códigos aleatórios

class AccountScreen {
  //  final AccountService _accountService = AccountService();
  final AccountDioService _accountService = AccountDioService();
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
    } on DioException catch (dioException) {
      print("------------------------------------------------");
      print("\n Erro ao buscar contas:");

      // Aqui vamos tratar os diferentes tipos de erro
      if (dioException.type == DioExceptionType.connectionError) {
        // Verifica se é erro de DNS (URL incorreta)
        if (dioException.message?.contains('Failed host lookup') ?? false) {
          print(" URL incorreta ou servidor indisponível.");
          print(" Verifique o endereço e tente novamente.");
        } else {
          print(" Sem conexão com a internet.");
          print(" Verifique sua conexão e tente novamente.");
        }

      } else if (dioException.type == DioExceptionType.badResponse) {
        // Erros de resposta HTTP (400, 404, 500, etc)
        int? statusCode = dioException.response?.statusCode;
          if (statusCode == 404) {
            print("🔍 Recurso não encontrado (erro 404).");
            print("Verifique se a URL está correta.");
          } else if (statusCode == 500) {
            print("🔧 Erro no servidor (erro 500).");
            print("Tente novamente mais tarde.");
          } else if (statusCode == 401 || statusCode == 403) {
            print("🔐 Acesso negado (erro $statusCode).");
            print("Verifique suas credenciais.");
          } else {
            print("⚠️ Erro na resposta do servidor (código $statusCode).");
        }

      } else {
        print("❌ ${dioException.message}");
      }
        print("------------------------------------------------");
        print("");
      } on TypeError {
        print("------------------------------------------------");
        print("\n🔧 Erro de formatação:");
        print("Os dados recebidos não estão no formato esperado.");
        print("O servidor pode estar retornando HTML ao invés de JSON.");
        print("------------------------------------------------");
        print("");
      } on Exception catch (e) {
        print("\nNão consegui recuperar os dados da conta.");
        print("Erro: $e");
        print("");
      } finally {
        print("${DateTime.now()} | Ocorreu uma tentativa de consulta.\n");
      }
  }

_readAndAddAccount(String fullName, double balance) async {
  // Lógica de separação de nome e sobrenome
  List<String> parts = fullName.split(" ");
  String firstName = parts.isNotEmpty ? parts.first : "Desconhecido";
  String lastName = parts.length > 1
      ? parts.sublist(1).join(" ")
      : "Não Informado";

  // NOVO ID: Geração de um ID ÚNICO
  String newId = _uuid.v4();

  // Geração da nova Account com os dados lidos + ID único
  Account newAccount = Account(
    id: newId,
    name: firstName,
    lastName: lastName,
    balance: balance,
  );

  try {
    await _accountService.addAccount(newAccount);
    print("\n✅ Conta adicionada com sucesso!");
    print("Nome: $firstName $lastName");
    print("Saldo: R\$ ${balance.toStringAsFixed(2)}\n");
  } on DioException catch (dioException) {
    print("------------------------------------------------");
    print("\n🔴 Erro ao adicionar conta:");

    if (dioException.type == DioExceptionType.connectionError) {
      if (dioException.message?.contains('Failed host lookup') ?? false) {
        print("🌐 URL incorreta ou servidor indisponível.");
      } else {
        print("📡 Sem conexão com a internet.");
      }
    } else if (dioException.type == DioExceptionType.badResponse) {
      int? statusCode = dioException.response?.statusCode;
      print("⚠️ Erro na resposta do servidor (código $statusCode).");
    } else {
      print("❌ ${dioException.message}");
    }

    print("------------------------------------------------");
    print("");
  } on Exception catch (e) {
    print("\n❌ Não consegui adicionar a conta.");
    print("Erro: $e\n");
  } finally {
    print("${DateTime.now()} | Tentativa de adicionar conta.\n");
  }
}}
