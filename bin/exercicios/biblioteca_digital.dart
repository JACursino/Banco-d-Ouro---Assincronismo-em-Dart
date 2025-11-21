import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

const String urlGist =
    'https://gist.githubusercontent.com/JACursino/0753ed2429dee9484ad3f0f1f504b540/raw/cad163846f0b8cabb88a770e632876e91b6a47d2/books.json';

Future<List<Map<String, dynamic>>> carregarLivros() async {
  try {
    final resposta =
        await get(Uri.parse(urlGist)).timeout(const Duration(seconds: 5)); /* vai aguardar no máximo 5 segundos por uma resposta do servidor */

    if (resposta.statusCode == 200) {
      final List dadosJson = jsonDecode(resposta.body); //jsonDecode converte o texto em estrutura de dados manipulável.
      return dadosJson.cast<Map<String, dynamic>>();
    } else {
      print('Falha ao carregar os dados (status: ${resposta.statusCode}).');
      return [];
    }
  } catch (erro) {
    print('Erro ao conectar-se ao servidor: $erro');
    return [];
  }
}

List<String> extrairAutores(List<Map<String, dynamic>> livros) {
  final Set<String> autores = {};
  for (var livro in livros) {
    autores.add(livro['author']);
  }
  return autores.toList()..sort();
}

List<Map<String, dynamic>> filtrarPorAutor(
    List<Map<String, dynamic>> livros, String autor) {
  return livros
      .where((livro) => livro['author'] == autor)
      .cast<Map<String, dynamic>>() //função do .cast é assegurar que a lista seja do mesmo tipo
      .toList(); //converte a sequência de valores em uma lista completa
}

void exibirLivrosEncontrados(
    List<Map<String, dynamic>> livros, String autor) {
  print('\nLivros de $autor:\n');

  if (livros.isEmpty) {
    print('Nenhuma obra encontrada.');
  } else {
    for (var livro in livros) {
      print('- ${livro['title']} (${livro['year_of_publication']})');
    }
  }
}

void main() async {
  print('--- Bem-vindo(a) à Biblioteca Digital ---');
  print('Conectando à base de dados...\n');

  final List<Map<String, dynamic>> livros = await carregarLivros();

  // Se não conseguir carregar, encerra o programa
  if (livros.isEmpty) {
    print('Não foi possível carregar os dados. Verifique sua conexão.');
    exit(0);
  }

  final List<String> autores = extrairAutores(livros);

  // Loop principal do menu interativo
  while (true) {
    print('\nAutores disponíveis na biblioteca:\n');
    for (var i = 0; i < autores.length; i++) {
      print('${i + 1}. ${autores[i]}');
    }
    print('\n0. Sair');
    stdout.write('\nDigite o número do autor que deseja consultar: ');
    final entrada = stdin.readLineSync();

    if (entrada == '0') {
      print('\nEncerrando o sistema...');
      break;
    }

    final indice = int.tryParse(entrada ?? '');
    if (indice == null || indice < 1 || indice > autores.length) {
      print('Opção inválida. Tente novamente.');
      continue;
    }

    final autorEscolhido = autores[indice - 1];
    final livrosAutor = filtrarPorAutor(livros, autorEscolhido);

    print('\n------------------------------------');
    exibirLivrosEncontrados(livrosAutor, autorEscolhido);
    print('------------------------------------\n');

    stdout.write('Pressione Enter para voltar ao menu...');
    stdin.readLineSync(); // pausa antes de limpar ou voltar
  }

  print('\n--- Fim da execução ---');
}
