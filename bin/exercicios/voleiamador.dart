import 'dart:convert';
import 'package:http/http.dart';

const String urlGist = 'https://gist.githubusercontent.com/JACursino/13a5ea0140581c345715ab5462c0cb63/raw/03af70f2aed4b5fc874ba4c721fba0cedf2d6df6/players.json';

Future<Map<String, dynamic>> buscarDados() async {
  final resposta = await get(Uri.parse(urlGist));
  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    throw Exception('Falha ao carregar dados (${resposta.statusCode})');
  }
}

Future<void> main() async {
  print('=== Organizador de Times de Vôlei ===\n');

  try {
    Map<String, dynamic> dados = await buscarDados();

    Map<String, dynamic> regras = dados['rules'];
    List<dynamic> jogadores = dados['players'];

    int jogadoresPorTime = regras['playersPerTeam'];

    // Remover quem está descansando
    jogadores = jogadores.where((j) => j['isResting'] == false).toList();

    // Ordenar por quem esperou mais rodadas, e depois por nível de habilidade
    jogadores.sort((a, b) {
      if (a['roundsWaiting'] != b['roundsWaiting']) {
        return b['roundsWaiting'].compareTo(a['roundsWaiting']);
      }
      return b['skillRate'].compareTo(a['skillRate']);
    });

    List<List<dynamic>> times = [];
    for (int i = 0; i < jogadores.length; i += jogadoresPorTime) {
      int fim = (i + jogadoresPorTime < jogadores.length)
          ? i + jogadoresPorTime
          : jogadores.length;
      times.add(jogadores.sublist(i, fim));
    }

    print('\n=== Times formados ===\n');
    for (int i = 0; i < times.length; i++) {
      print('Time ${i + 1}');
      for (var jogador in times[i]) {
        print('  - ${jogador['name']} '
              '(${jogador['position']}, '
              'nível: ${jogador['skillRate']}, '
              'esperas: ${jogador['roundsWaiting']})');
      }
      print('');
    }

  } catch (erro) {
    print('Ocorreu um erro: $erro');
  }
}
