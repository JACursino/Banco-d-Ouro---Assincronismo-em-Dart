



🏛️ Chatbot do Banco d'Ouro: Fase 1
🎯 Objetivo do Projeto (Dart: Assincronismo e Comunicação com APIs)
O objetivo principal deste projeto foi construir um Chatbot funcional para um ambiente bancário, focado em dominar os Fundamentos de Assincronismo e Comunicação com APIs na linguagem Dart.

Diferentemente de um projeto local, toda a gestão de dados (como nome e saldo das contas) é feita em um servidor externo.

🛠️ Principais Conceitos Implementados
Esta primeira fase do desenvolvimento estabeleceu a base crucial para a interação do nosso chatbot com o mundo externo, cobrindo os seguintes tópicos essenciais:

Comunicação com API: Uso de requisições HTTP (principalmente GET e POST) para obter e enviar dados de/para um servidor externo.

Assincronismo em Dart: Implementação e domínio dos conceitos de Future, async e await para lidar de forma eficiente com operações de rede que consomem tempo, garantindo que a aplicação não trave enquanto espera a resposta do servidor.

Manipulação de Dados: Conversão de dados entre o formato JSON (recebido da API) e estruturas de dados nativas do Dart (como Map e classes/Modelos).

Integração com o Chatbot: Criação de uma interface simples onde interações do usuário (ex: "ver contas") disparam operações assíncronas para buscar e exibir os dados atualizados.

Gerenciamento de Token: Entendimento e aplicação de mecanismos para manipular tokens em requisições, simulando a segurança de comunicação com uma API.

O resultado desta fase é um chatbot capaz de interagir de forma dinâmica com dados remotos, demonstrando um domínio sobre como as aplicações Dart modernas se comunicam com serviços online.

🌟 Fase 2: Robustez e Tratamento de Erros (Início em [Data do Commit])
Este projeto é uma continuação direta do nosso Chatbot do Banco d'Ouro. No entanto, a partir deste ponto, o foco principal é elevar a qualidade e a confiabilidade da aplicação, abordando cenários que foram ignorados na primeira etapa.

O commit inicial desta fase ([Hash do Commit]) marca o início da implementação de práticas essenciais de programação robusta:

Tratamento de Exceções e Erros:

Preparar o programa para lidar de forma elegante com situações excepcionais (como uma falha na conexão de rede, ausência de resposta do servidor, ou dados inesperados).

Utilizar os mecanismos de try-catch e on do Dart para garantir que o chatbot não 'quebre' e possa fornecer feedback útil ao usuário ou tentar se recuperar do erro.

Null Safety (Segurança contra Nulos):

Revisitar e refatorar o código para abraçar totalmente o recurso de Null Safety do Dart. Isso elimina a maioria dos temidos null pointer exceptions (NPEs), tornando o código mais seguro, mais previsível e mais fácil de manter.

Objetivo: Transformar o chatbot em uma aplicação pronta para produção, que opera de forma confiável mesmo em condições adversas, provando a importância de não apenas fazer o código funcionar, mas também de fazê-lo funcionar bem sob pressão.
