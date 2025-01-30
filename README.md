# Lista de Tarefas - Todo List

Este projeto Flutter permite criar de forma organizada suas tarefas. O usuário pode criar e apagar tarefas na lista, tendo a opção também de desfazer a remoção da tarefa.

## 📌 Funcionalidades
- Adicionar tarefas com título e data automática.
- Exibir a lista de tarefas pendentes.
- Excluir tarefas individualmente com opção de desfazer.
- Limpar todas as tarefas de uma vez.
- Feedback visual quando não há tarefas.

## 🛠 Tecnologias Utilizadas
- **Flutter**: SDK para desenvolvimento de aplicativos multiplataforma.
- **Dart**: Linguagem de programação usada no Flutter.
- **Material Design**: Interface intuitiva e responsiva.
- **Shared Preferences**: Armazena a lista de tarefas localmente.

## 📦 Dependências
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

## 🚀 Como Rodar o Projeto
1. **Clone o repositório**
   ```sh
   git clone https://github.com/seu-usuario/todo_list.git
   cd todo_list
   ```
2. **Instale as dependências**
   ```sh
   flutter pub get
   ```
3. **Execute o projeto**
   ```sh
   flutter run
   ```

## 🖼️ Estrutura do Projeto
```
/lib
  ├── main.dart                # Arquivo principal do aplicativo
  ├── pages/
  │     ├── todo_list_page.dart # Tela principal com a lista de tarefas
  ├── models/
  │     ├── todo.dart           # Modelo de dados para as tarefas
  ├── repositories/
  │     ├── todo_repository.dart # Gerenciamento de tarefas com armazenamento local
  ├── widgets/
  │     ├── todo_list_item.dart  # Widget responsável por exibir cada tarefa
/assets
  ├── nenhuma_tarefa.png        # Imagem exibida quando não há tarefas
```

## 🔍 Sobre o Gerenciamento de Tarefas
As tarefas são armazenadas localmente utilizando a biblioteca shared_preferences. Isso permite que a lista seja mantida mesmo após o fechamento do aplicativo.

## 📄 Licença
Este projeto está licenciado sob a [MIT License](LICENSE).




