import 'dart:convert'; // Biblioteca para trabalhar com JSON
import 'dart:math'; // Biblioteca para gerar números aleatórios
import 'package:http/http.dart'; // Biblioteca para trabalhar com HTTP

void buscarReceitas() {
  String url =
      "https://gist.githubusercontent.com/JACursino/30e0162d0a77c849f990d4f4808ec4a7/raw/f238d3bbe5fc6df3a4431fa1ec879f6fc10dfa18/recipes.json";

  Future<Response> respostaFutura = get(Uri.parse(url));

  respostaFutura.then((Response resposta) {
    if (resposta.statusCode == 200) { // verifica se a resposta foi bem-sucedida
      List<dynamic> listaReceitas = jsonDecode(resposta.body);

      // seleção aleatória da receita do dia
      int indiceAleatorio = Random().nextInt(listaReceitas.length);
      var receitaDoDia = listaReceitas[indiceAleatorio];

      print("\n----------------------------------------");
      print("             Receita do Dia");
      print("----------------------------------------");
      print("Nome: ${receitaDoDia['nome']}");

      print("\nIngredientes:");
      for (var ingrediente in receitaDoDia['ingredientes']) {
        print("- $ingrediente");
      }

      print("\nModo de preparo:");
      print(receitaDoDia['preparação']);

      print("------------------------------------");
      print("Humm... deu água na boca aí também?");
      print("------------------------------------");
    } else {
      print("Não foi possível acessar a base de receitas. Código: ${resposta.statusCode}");
    }
  });
}

void main() {
  print("\n----------------------------------------");
  print("Bem-vindo(a) ao programa Mão na Massa!");
  print("Vamos descobrir qual é a receita do dia.");
  print("----------------------------------------");

  buscarReceitas();
}
