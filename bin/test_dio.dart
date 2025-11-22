import 'package:dart_assincronismo/services/account_dio_service.dart';

void main() async {
  print("🧪 Testando erros do Dio...\n");

  AccountDioService service = AccountDioService();

  print("Tentando buscar contas com URL incorreta...");

  List accounts = await service.getAll();

  print("Resultado: $accounts");
}
