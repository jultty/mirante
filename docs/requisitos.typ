#set enum(numbering: "1.1.1.", full: true)

= Projeto Final EWA
== Requisitos Funcionais \ \

+ *Menu principal*
  + Exibe as opções:
    - Treinar
    - Gerenciar treinos
    - Gerenciar exercícios
    - Sair
  + Pede confirmação antes de sair
  + Exibe visualizações dos dados coletados
+ *Treinar*
  + Grava os atributos de um evento de treinamento a cada exercício
    + a data e hora em que o exercício foi treinado
    + a pontuação
    + o tipo do exercício (múltipla escolha ou ordenação)
    + a disciplina (múltipla escolha ou ordenação)
  + Pular uma questão
  + Sair do treinamento a qualquer momento
+ *Gerenciar treinos*
  + Criar novos treinos
  + Excluir treinos
  + Editar treinos
  + Editar um treino permite selecionar quais exercícios o compõem
  + A criação de um novo treino para o cliente é idêntica à edição
+ *Gerenciar exercícios*
  + Criar exercícios de múltipla escolha
    + Permite adicionar novas alternativas
    + Permite excluir alternativas
    + Permite selecionar a alternativa correta 
  + Criar exercícios de ordenação
    + Permite adicionar novas alternativas
    + Permite excluir alternativas
    + Permite arrastar as alternativas para estabelecer a ordem correta 
