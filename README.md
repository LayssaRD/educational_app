# Educational Products App

Aplicação mobile desenvolvida em Flutter para gerenciamento de produtos e materiais educacionais, com persistência local em SQLite e sincronização em nuvem via Supabase.

## Funcionalidades

- CRUD completo de **Produtos Educacionais**
- CRUD completo de **Cursos**
- CRUD completo de **Alunos**
- CRUD completo de **Matrículas**
- Persistência local com SQLite (funciona offline)
- Sincronização automática com Supabase ao recuperar conexão

## Tecnologias

- Flutter / Dart
- SQLite (`sqflite`)
- Supabase (`supabase_flutter`)
- `flutter_dotenv`
- `uuid`
- `path`

## Arquitetura

O projeto segue arquitetura em camadas organizada por features:

```
lib/
├── core/
│   ├── database/
│   ├── mixin/
│   ├── presentation/
│   │   └── widgets/
│   │       └── form/
│   ├── supabase/
│   └── sync/
└── features/
    ├── course/
    │   ├── data/
    │   │   ├── datasources/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── controllers/
    │       └── pages/
    ├── educational_product/
    ├── enrollment/
    └── student/
```

Cada feature possui:
- **datasource local** — SQLite via sqflite
- **datasource remoto** — Supabase
- **repository** — orquestra local e remoto com suporte offline

## Como executar

```bash
git clone https://github.com/LayssaRD/educational_app.git
cd educational_app
flutter pub get
```

Crie um arquivo `.env` na raiz do projeto com suas credenciais do Supabase:

```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=sua-chave-anon
```

Em seguida execute:

```bash
flutter run
```

> O projeto deve ser executado em Android ou iOS.

## Autor

Layssa Rodrigues Alves — UTFPR
