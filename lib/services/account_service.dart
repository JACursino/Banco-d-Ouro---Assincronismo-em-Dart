import 'dart:async';
import 'package:dart_assincronismo/api_key.dart';
import 'package:dart_assincronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = "https://api.github.com.br/gists/b52a4ebbde885199f357ba69855c82a9";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura.");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }
    return listAccounts;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $gitHubToken"},
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição de adição bem sucedida(${account.name}).");
    } else {
      _streamController.add(
          "${DateTime.now()} | Requisição de adição falhou(${account.name}).");
    }
  }

  // 1. MÉTODO getAccountById
  // Retorna uma conta específica pelo ID ou null se não encontrar
  Future<Account?> getAccountById(String id) async {
    List<Account> listAccounts = await getAll();

    _streamController.add("${DateTime.now()} | Buscando conta com ID: $id");

    // Percorre a lista procurando a conta com o ID correspondente
    for (Account account in listAccounts) {
      if (account.id == id) {
        _streamController.add("${DateTime.now()} | Conta encontrada: ${account.name}");
        return account;
      }
    }

    // Se chegou aqui, não encontrou
    _streamController.add("${DateTime.now()} | Conta com ID $id não encontrada.");
    return null;
  }

  // 2. MÉTODO updateAccount
  // Atualiza uma conta existente se o ID existir
  updateAccount(Account updatedAccount) async {
    List<Account> listAccounts = await getAll();

    // Procura o índice da conta com o mesmo ID
    int index = listAccounts.indexWhere(
      (account) => account.id == updatedAccount.id,
    );

    // Se não encontrar (index == -1), não faz nada
    if (index == -1) {
      _streamController.add(
          "${DateTime.now()} | Falha ao atualizar: conta ID ${updatedAccount.id} não existe.");
      return;
    }

    // Substitui a conta antiga pela nova
    listAccounts[index] = updatedAccount;

    // Converte a lista atualizada para JSON
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    // Salva no Gist
    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $gitHubToken"},
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Conta atualizada com sucesso: ${updatedAccount.name}");
    } else {
      _streamController.add(
          "${DateTime.now()} | Falha ao atualizar conta: ${updatedAccount.name}");
    }
  }

  // 3. MÉTODO deleteAccount
  // Remove uma conta pelo ID
  deleteAccount(String id) async {
    List<Account> listAccounts = await getAll();

    // Procura o índice da conta
    int index = listAccounts.indexWhere(
      (account) => account.id == id,
    );

    // Se não encontrar, não faz nada
    if (index == -1) {
      _streamController.add(
          "${DateTime.now()} | Falha ao deletar: conta ID $id não existe.");
      return;
    }

    // Guarda o nome antes de remover
    String accountName = listAccounts[index].name;

    // Remove a conta da lista
    listAccounts.removeAt(index);

    // Converte a lista atualizada para JSON
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    // Salva no Gist
    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $gitHubToken"},
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Conta deletada com sucesso: $accountName");
    } else {
      _streamController.add(
          "${DateTime.now()} | Falha ao deletar conta: $accountName");
    }
  }
}
