import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gerenciador_estado.dart';
import 'login/usuario.dart';
import 'telas/equipamentos.dart';
import 'telas/especificacoes.dart';
import 'telas/carrinho.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GerenciadorEstado(),
      child: const NewSound(),
    ),
  );
}

class NewSound extends StatelessWidget {
  const NewSound({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewSound',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    Widget telaAtual = const SizedBox.shrink();

    if (estado.exibicao == EmExibicao.telaEquipamentos) {
      telaAtual = const Equipamentos();
    } else if (estado.exibicao == EmExibicao.telaEspecificacoes) {
      telaAtual = const Especificacoes();
    } else if (estado.exibicao == EmExibicao.telaCarrinho) {
      telaAtual = const Carrinho();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NewSound - Equipamentos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(estado.estaLogado ? Icons.logout : Icons.login),
            onPressed: () {
              if (estado.estaLogado) {
                estado.logout();
              } else {
                estado.login(Usuario("Usuário Mock", "mock@email.com"));
              }
            },
          ),
        ],
      ),
      body: telaAtual,
    );
  }
}