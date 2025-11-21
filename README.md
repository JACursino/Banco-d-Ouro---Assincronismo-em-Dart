A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.


🌟 Fase 2: Robustez e Tratamento de Erros (Início em [Data do Commit])
Este projeto é uma continuação direta do nosso Chatbot do Banco d'Ouro. No entanto, a partir deste ponto, o foco principal é elevar a qualidade e a confiabilidade da aplicação, abordando cenários que foram ignorados na primeira etapa.

O commit inicial desta fase ([Hash do Commit]) marca o início da implementação de práticas essenciais de programação robusta:

Tratamento de Exceções e Erros:

Preparar o programa para lidar de forma elegante com situações excepcionais (como uma falha na conexão de rede, ausência de resposta do servidor, ou dados inesperados).

Utilizar os mecanismos de try-catch e on do Dart para garantir que o chatbot não 'quebre' e possa fornecer feedback útil ao usuário ou tentar se recuperar do erro.

Null Safety (Segurança contra Nulos):

Revisitar e refatorar o código para abraçar totalmente o recurso de Null Safety do Dart. Isso elimina a maioria dos temidos null pointer exceptions (NPEs), tornando o código mais seguro, mais previsível e mais fácil de manter.

Objetivo: Transformar o chatbot em uma aplicação pronta para produção, que opera de forma confiável mesmo em condições adversas, provando a importância de não apenas fazer o código funcionar, mas também de fazê-lo funcionar bem sob pressão.
