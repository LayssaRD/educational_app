# REFLEXAO.md — Reflexão sobre o uso da IA

## Como a IA foi utilizada

A IA foi utilizada como apoio durante todo o desenvolvimento, desde a criação dos primeiros arquivos até a implementação das funcionalidades adicionais. A interação foi feita de forma iterativa — enviando o código atual e descrevendo o problema ou a melhoria desejada.

## Partes geradas com auxílio da IA

**Atividade 1 — EducationalProduct:**
- Tema visual completo em tons de roxo
- Correção do `main.dart` com `WidgetsFlutterBinding.ensureInitialized()` e `useMaterial3`
- Método `showEditDialog` para edição de produtos
- Substituição do `Row` por `Wrap` para corrigir overflow nos chips
- `README.md` e arquivos de documentação

**Atividade 2 — Course, Student, Enrollment:**
- Models, repositories e controllers das três novas classes
- `AppDatabase` atualizado com novas tabelas e chaves estrangeiras
- Pages completas com CRUD para Course, Student e Enrollment
- `main.dart` com navegação via `BottomNavigationBar`

## Partes desenvolvidas manualmente

- Estrutura inicial do projeto
- Classe `EducationalProduct` com os campos obrigatórios
- `AppDatabase` inicial com a tabela de produtos
- `EducationalProductRepository` com os métodos de CRUD
- `EducationalProductController` com a lista em memória
- Lógica inicial da `EducationalProductPage`
- Integração e testes no emulador Android

## Adaptações realizadas manualmente

- Inserção do `WidgetsFlutterBinding.ensureInitialized()` após orientação da IA
- Substituição do `Row` por `Wrap` no subtítulo do `ListTile`
- Ajuste do `centerTitle: true` na `AppBar`
- Verificação e validação de todo código gerado antes de aplicar

## O que aprendi durante o processo

- A importância do `WidgetsFlutterBinding.ensureInitialized()` ao usar plugins nativos como o `sqflite`, que exigem o Flutter inicializado antes de acessar canais nativos.
- Que o `sqflite` é exclusivo para Android e iOS — não funciona na web.
- Como a arquitetura em camadas organiza o código de forma que cada parte tem uma responsabilidade clara: Model cuida dos dados, Repository fala com o banco, Controller gerencia a lista em memória e a Page exibe e interage com o usuário.
- A diferença prática entre `Row` e `Wrap`: `Row` não quebra linha e pode causar overflow, enquanto `Wrap` distribui os filhos conforme o espaço disponível.
- Como relacionar tabelas no SQLite usando chaves estrangeiras e como carregar dados relacionados nos dropdowns da interface.
- Que a IA é uma ferramenta eficiente para identificar erros e gerar código, mas entender o que foi gerado é essencial para aplicar corretamente e explicar durante a apresentação.
