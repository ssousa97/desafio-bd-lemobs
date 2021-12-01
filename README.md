## Questão 1

- [x] Resolva o problema dos protocolos duplicados, lembrando que é importante manter os dados.
- [x] Blinde o banco, para que caso como esses não ocorra novamente.
- [x] Crie uma trigger para gerar o protocolo toda vez que uma nova solicitação for inserida.
- [x] Corrigir o sequencial de cada inserção.
- [x] Crie uma function para o protocolo_mobile. Essa function será chamada pela API do sistema .
- [x] Se possível, sugira melhorias na estrutura da tabela:
    * Alterar as colunas da tabela, para que protocolo e protocolo_mobile sejam chaves estrangeiras. E nas suas respectivas tabelas sejam chaves únicas para evitar repetição de dados.
    * Inserir protocolo_mobile ao mesmo tempo que é inserido o protocolo. Assim não depender de chamar função na API, onde pode acontecer algum erro e o dado ficar vazio.
  
## Questão 2 
Tive uma certa dificuldade em estabelecer a relação de vinculo com sendo única entre equipe, nucleo e setor. 

## Observações

Os scripts foram desenvolvidos considerando um banco pré existente com os dados num estado inválido como descrito na questão 1. 
No entando, o arquivo questao1.sql possui INSERTS que podem ser usados como teste.
Para rodar o docker:
   docker-compose up -d
  
