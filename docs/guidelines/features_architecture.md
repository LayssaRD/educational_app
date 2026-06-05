# Diretrizes de Arquitetura

Diretrizes arquiteturais seguidas durante o desenvolvimento do projeto **Educational Products App**, definidas em conjunto com o uso de IA como apoio.

---

## Arquitetura em Camadas

O projeto foi organizado por camadas de responsabilidade, conforme orientação do professor na disciplina de Desenvolvimento Mobile da UTFPR. Cada camada tem uma função bem definida e não deve misturar responsabilidades com as demais.

A página nunca executa comandos SQL diretamente. Toda operação de banco de dados passa pelo Repository. A Controller é o único intermediário entre a Page e o Repository.

---

## Estrutura de Pastas

```text
lib/
├── database/
│   └── app_database.dart
├── models/
│   ├── educational_product.dart
│   ├── course.dart
│   ├── student.dart
│   └── enrollment.dart
├── repositories/
│   ├── educational_product_repository.dart
│   ├── course_repository.dart
│   ├── student_repository.dart
│   └── enrollment_repository.dart
├── controllers/
│   ├── educational_product_controller.dart
│   ├── course_controller.dart
│   ├── student_controller.dart
│   └── enrollment_controller.dart
└── pages/
    ├── educational_product_page.dart
    ├── course_page.dart
    ├── student_page.dart
    └── enrollment_page.dart
```

---

## Persistência com SQLite

O app usa o pacote `sqflite` para persistência local. Algumas regras seguidas:

- Chamar `WidgetsFlutterBinding.ensureInitialized()` no `main()` antes do `runApp()`
- Usar `INTEGER PRIMARY KEY AUTOINCREMENT` para o identificador de cada tabela
- O campo identificador no Model é `int?` para suportar registros ainda não persistidos
- Campos obrigatórios definidos com `NOT NULL` no banco
- Os nomes dos campos no Model são idênticos aos nomes das colunas SQLite
- Chaves estrangeiras habilitadas via `PRAGMA foreign_keys = ON` no `onConfigure`
- Migrações tratadas no `onUpgrade` para preservar dados existentes
- O projeto não roda na web — apenas Android e iOS são suportados

---

## Responsabilidade de cada camada

**Model** — representa os dados da entidade. Contém apenas os campos e os métodos `toMap()` e `fromMap()`. Nenhuma lógica de negócio.

**Repository** — único arquivo que fala com o banco. Implementa `insert`, `findAll`, `update` e `delete`. Não conhece a interface.

**Controller** — mantém a lista em memória e chama o Repository. Instanciada diretamente na Page. Não usa `ChangeNotifier` — o estado visual é gerido com `setState` na própria Page.

**Page** — exibe a lista e os formulários. Usa `AlertDialog` para cadastro, edição e confirmação de exclusão. Usa `SnackBar` para feedback. Toda operação passa pela Controller.

---

## Relacionamentos entre tabelas

A tabela `enrollments` possui chaves estrangeiras para `students`, `courses` e `products`. A `EnrollmentPage` carrega as três listas via seus respectivos controllers para exibir os dados nos dropdowns e na listagem.

---

## Regras gerais

- A Page nunca acessa o Repository diretamente
- Campos obrigatórios são validados antes de salvar
- Os `TextEditingController` e seleções de dropdown são limpos após salvar ou cancelar
