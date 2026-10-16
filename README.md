# NewSound 

## 🎵 Tema do Projeto
O **NewSound** é um aplicativo mobile de e-commerce voltado para a exibição, consulta de especificações técnicas e compra de equipamentos musicais (guitarras, baterias, amplificadores, etc.). O projeto conta com catálogo em grid, especificações detalhadas, sistema de avaliações/comentários e carrinho de compras reativo.

---

## 🛠️ Tecnologias Utilizadas
- **Flutter** & **Dart**
- **Provider**: Gerenciamento de estado global reativo.
- **Flutter SVG**: Renderização de vetores gráficos na interface.

---

## 📁 Estrutura de Pastas Relevantes
```text
NewSound/
├── assets/
│   ├── jsons/           # Dados estáticos (equipamentos.json e comentarios.json)
│   └── imgs/            # Imagens dos produtos e ícones SVG
├── lib/
│   ├── componentes/     # Widgets reutilizáveis (CartaoEquipamento, AvaliacaoEstrelas)
│   ├── login/           # Modelo e mock do usuário
│   ├── telas/           # Telas (Equipamentos, Especificacoes e Carrinho)
│   ├── gerenciador_estado.dart # Lógica de negócio central com Provider
│   └── main.dart        # Ponto de entrada e configuração do MaterialApp
└── pubspec.yaml         # Dependências e declaração de assets
```

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- SDK do **Flutter** instalado e configurado.
- Dispositivo físico ou Emulador Android/iOS ativo.

### Passo a Passo
1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/Venan42/NewSound
   cd NewSound
   ```

2. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Executar a aplicação:**
   ```bash
   flutter run
   ```