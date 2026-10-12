import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'gerenciador_estado.dart';
import 'login/usuario.dart';
import 'telas/equipamentos.dart';
import 'telas/especificacoes.dart';
import 'telas/carrinho.dart';

const Color corPrimaria = Color(0xFF1565C0);
const Color corSecundaria = Color(0xFFD32F2F);

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
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: corPrimaria,
          onPrimary: Colors.white,
          secondary: corSecundaria,
          onSecondary: Colors.white,
          error: corSecundaria,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF1B1B1F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: corPrimaria,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrimaria,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: corPrimaria),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: corPrimaria,
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/imgs/guitar-amp-svgrepo-com.svg',
              height: 28,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'NewSound',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Ícone de usuário no canto superior esquerdo, com seletor abaixo
        leading: PopupMenuButton<String>(
          tooltip: 'Conta',
          position: PopupMenuPosition.under,
          color: Colors.white,
          icon: Icon(
            estado.estaLogado
                ? Icons.account_circle
                : Icons.account_circle_outlined,
          ),
          onSelected: (opcao) {
            if (opcao == 'login') {
              estado.login(usuarioMock);
            } else {
              estado.logout();
            }
          },
          itemBuilder: (context) => [
            if (estado.estaLogado)
              PopupMenuItem<String>(
                enabled: false,
                child: Text(
                  'Olá, ${estado.usuario?.nome ?? ''}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            if (!estado.estaLogado)
              const PopupMenuItem<String>(
                value: 'login',
                child: Row(
                  children: [
                    Icon(Icons.login, color: corPrimaria),
                    SizedBox(width: 8),
                    Text('Login'),
                  ],
                ),
              )
            else
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: corSecundaria),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => estado.exibirCarrinho(),
              ),
              if (estado.carrinho.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${estado.carrinho.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: telaAtual,
    );
  }
}
