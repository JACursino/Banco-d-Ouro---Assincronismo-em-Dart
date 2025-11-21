import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

String formatarData(DateTime data) {
  return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
}

String formatarHora(DateTime data) {
  return "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
}

// Função para mostrar carregamento
void mostrarCarregamento() {
  List<String> animacao = ['.', '..', '...'];
  for (int i = 0; i < 3; i++) {
    stdout.write('\rCarregando${animacao[i]}');
    sleep(Duration(milliseconds: 200));
  }
  stdout.write('\r    Carregamento concluído!   \n');
}

const String urlConsultas = 'https://gist.githubusercontent.com/JACursino/c56d252d68c51cbacab8a65c2ce0625f/raw/35d2a2ee5b576282584d89e6e60cf0a9d97c21f3/vet.json';

Future<List> buscarConsultas() async {
  try {
    var resposta = await http.get(Uri.parse(urlConsultas));
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      print('Erro ao buscar dados (código ${resposta.statusCode})');
      return [];
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return [];
  }
}

void main() async {
  print('=== Sistema de Agendamento da Clínica Vet ===');
  stdout.write('Carregando dados das consultas');
  mostrarCarregamento();

  List consultas = await buscarConsultas();

  if (consultas.isEmpty) {
    print('Nenhuma consulta encontrada.');
    return;
  }

  Set<String> nomesVeterinarios = {};
  consultas.forEach((consulta) {
    nomesVeterinarios.add(consulta['veterinarian'].toString());
  });

  print('\nVeterinários disponíveis:');
  nomesVeterinarios.forEach((nome) => print('- $nome'));

  String? nomeDigitado;
  bool nomeValido = false;
  while (!nomeValido) {
    stdout.write('\nDigite o nome do veterinário: ');
    nomeDigitado = stdin.readLineSync();
    if (nomeDigitado == null || nomeDigitado.isEmpty) {
      print('Nome não pode ser vazio. Tente novamente.');
      continue;
    }
    if (!nomesVeterinarios.contains(nomeDigitado)) {
      print('Veterinário não encontrado. Tente novamente.');
      continue;
    }
    nomeValido = true;
  }

  List consultasDoVet = consultas.where((consulta) {
    String nomeVet = consulta['veterinarian'].toString().toLowerCase();
    return nomeVet == nomeDigitado!.toLowerCase();
  }).toList();

  if (consultasDoVet.isEmpty) {
    print('Nenhuma consulta encontrada para "$nomeDigitado".');
    return;
  }

  consultasDoVet.sort((a, b) {
    DateTime dataA = DateTime.parse(a['appointment'].toString().replaceAll(' ', 'T'));
    DateTime dataB = DateTime.parse(b['appointment'].toString().replaceAll(' ', 'T'));
    return dataA.compareTo(dataB);
  });

  print('\nConsultas do veterinário $nomeDigitado:');
  print('| ${'Pet'.padRight(10)} | ${'Data'.padRight(10)} | ${'Hora'.padRight(5)} |');
  print('|${'-' * 12}|${'-' * 12}|${'-' * 7}|');
  consultasDoVet.forEach((consulta) {
    DateTime dataHora = DateTime.parse(consulta['appointment'].toString().replaceAll(' ', 'T'));
    String nomePet = consulta['pet_name'] ?? 'Sem nome';
    print('| ${nomePet.padRight(10)} | ${formatarData(dataHora).padRight(10)} | ${formatarHora(dataHora).padRight(5)} |'); // O método padRight(10) garante que o texto ocupe exatamente 10 caracteres
  });

  print('\n=== Fim do programa ===');
}
