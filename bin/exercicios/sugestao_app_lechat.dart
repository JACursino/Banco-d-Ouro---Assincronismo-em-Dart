import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Classe para representar uma receita
class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? 'Sem nome',
      description: json['description'] ?? 'Sem descrição',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
}

// Função para buscar receitas da API
Future<List<Recipe>> fetchRecipes() async {
  final url =
      "https://gist.githubusercontent.com/JACursino/30e0162d0a77c849f990d4f4808ec4a7/raw/f238d3bbe5fc6df3a4431fa1ec879f6fc10dfa18/recipes.json";

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao carregar receitas: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Erro ao buscar receitas: $e");
  }
}

// Função para listar todas as receitas
void listRecipes(List<Recipe> recipes) {
  print("\n=== Lista de Receitas ===");
  for (var i = 0; i < recipes.length; i++) {
    print("${i + 1}. ${recipes[i].name}");
  }
}

// Função para buscar receita por nome
void searchRecipe(List<Recipe> recipes) {
  stdout.write("\nDigite o nome da receita: ");
  final query = stdin.readLineSync()?.toLowerCase() ?? '';
  final filtered = recipes.where((r) => r.name.toLowerCase().contains(query)).toList();

  if (filtered.isEmpty) {
    print("Nenhuma receita encontrada.");
  } else {
    listRecipes(filtered);
  }
}

// Função para mostrar detalhes de uma receita
void showRecipeDetails(List<Recipe> recipes) {
  stdout.write("\nDigite o número da receita: ");
  final input = stdin.readLineSync();
  final index = int.tryParse(input ?? '') ?? 0;

  if (index < 1 || index > recipes.length) {
    print("Número inválido!");
    return;
  }

  final recipe = recipes[index - 1];
  print("\n=== ${recipe.name} ===");
  print("Descrição: ${recipe.description}");
  print("\nIngredientes:");
  recipe.ingredients.forEach((i) => print("- $i"));
  print("\nModo de Preparo:");
  recipe.steps.asMap().forEach((i, step) => print("${i + 1}. $step"));
}

// Função principal
void main() async {
  print("Bem-vindo ao Mão na Massa!");

  try {
    final recipes = await fetchRecipes();
    print("Receitas carregadas com sucesso!");

    while (true) {
      print("\n=== Menu ===");
      print("1. Listar todas as receitas");
      print("2. Buscar receita por nome");
      print("3. Ver detalhes de uma receita");
      print("4. Sair");
      stdout.write("Escolha uma opção: ");

      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          listRecipes(recipes);
          break;
        case '2':
          searchRecipe(recipes);
          break;
        case '3':
          showRecipeDetails(recipes);
          break;
        case '4':
          print("Até logo!");
          return;
        default:
          print("Opção inválida!");
      }
    }
  } catch (e) {
    print("Erro: $e");
  }
}
