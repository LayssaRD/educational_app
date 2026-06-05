# PROMPTS.md — Prompts utilizados com IA

Registro dos principais prompts utilizados durante o desenvolvimento do projeto com apoio de IA.

---

## Criação do Model

> "Criar a classe EducationalProduct com os campos productId, name, description, price e stockQuantity, seguindo o padrão com toMap() e fromMap()"

A IA gerou o modelo seguindo as convenções do sqflite, com `int?` para o identificador e os métodos de serialização com nomes de campos idênticos às colunas do banco.

---

## Padronização dos demais arquivos

> (Com base no model como referência)

Com o model definido, os demais arquivos foram validados e ajustados para seguir o mesmo padrão de nomenclatura e estrutura: `AppDatabase`, `Repository` e `Controller`.

---

## Estilização da interface

> "Deixar em tons de roxo e padronizado"

Solicitação para aplicar um tema roxo consistente em toda a interface, incluindo AppBar, cards, inputs, botões e SnackBars.

---

## Correção de overflow

> (Enviando log de erro do Android)

A IA identificou que o `Row` dos chips transbordava em telas menores e sugeriu substituir por `Wrap`.

---

## Atividade 2 — Novas funcionalidades

> "Implementar Student, Course e Enrollment relacionados ao EducationalProduct"

A IA gerou os models, repositories, controllers e pages para as três novas classes, incluindo o `AppDatabase` atualizado com as novas tabelas e chaves estrangeiras, e o `main.dart` com navegação via `BottomNavigationBar`.
