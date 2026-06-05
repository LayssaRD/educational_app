# Diretrizes de Interface (UI/UX)

Guia de estilo visual seguido no desenvolvimento do **Educational Products App**, definido com apoio de IA para manter consistência em todas as telas.

---

## Paleta de cores

O app usa um tema roxo em toda a interface, com as seguintes constantes definidas diretamente na página:

| Constante | Hex | Onde é usada |
| :--- | :--- | :--- |
| `_purple` | `#534AB7` | AppBar, botões principais, FAB, ícone de excluir |
| `_purpleDark` | `#3C3489` | Títulos, textos de destaque, fundo dos SnackBars |
| `_purpleMid` | `#7F77DD` | Ícones secundários, bordas de inputs, ícone de editar |
| `_purpleLight` | `#EEEDFE` | Fundo de inputs, chips, avatares |
| Background | `#F5F4FF` | Fundo do Scaffold |
| Borda dos cards | `#AFA9EC` | Borda dos cards na listagem |

---

## AppBar

- Fundo roxo (`#534AB7`), texto branco, `fontWeight: w600`, `fontSize: 18`
- `centerTitle: true`
- `elevation: 0`
- Ícones brancos via `iconTheme`

---

## Cards da listagem

Cada produto é exibido em um card com:

- Sem sombra (`elevation: 0`)
- Borda fina com cor `#AFA9EC` e `borderRadius: 12`
- `CircleAvatar` com fundo `#EEEDFE` e ícone `book_outlined` roxo
- Título em `fontWeight: w600` cor `#3C3489`
- Chips de preço e estoque com fundo `#EEEDFE` e `borderRadius: 20`
- Dois botões no trailing: editar (cor `#7F77DD`) e excluir (cor `#534AB7`)

Os chips usam `Wrap` em vez de `Row` para evitar overflow em telas menores.

---

## Formulários

Padrão de `InputDecoration` usado em todos os campos:

```dart
InputDecoration(
  labelStyle: TextStyle(color: Color(0xFF534AB7)),
  prefixIcon: Icon(icon, color: Color(0xFF7F77DD), size: 20),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Color(0xFF7F77DD)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Color(0xFF534AB7), width: 2),
  ),
  filled: true,
  fillColor: Color(0xFFEEEDFE),
)
```

---

## Diálogos

- `borderRadius: 16` em todos os `AlertDialog`
- Título cor `#3C3489`, `fontWeight: w600`
- Botão cancelar: `TextButton` roxo
- Botão de confirmação: `ElevatedButton` com fundo `#534AB7`, texto branco, `borderRadius: 8`

---

## SnackBar

- `backgroundColor: #3C3489` em todas as mensagens
- Textos diretos: `'Produto cadastrado com sucesso!'`, `'Produto atualizado com sucesso!'`, `'Produto removido'`, `'Preencha todos os campos'`

---

## Empty state

Quando não há produtos cadastrados:

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFF7F77DD)),
    SizedBox(height: 16),
    Text('Nenhum produto cadastrado',
      style: TextStyle(color: Color(0xFF534AB7), fontSize: 16)),
  ],
)
```
