import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'gerenciador_estado.dart';
import 'login/usuario.dart';
import 'telas/equipamentos.dart';
import 'telas/especificacoes.dart';
import 'telas/carrinho.dart';

const Color azul = Color(0xFF1565C0);
const Color vermelho = Color(0xFFD32F2F);

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
          primary: azul,
          onPrimary: Colors.white,
          secondary: vermelho,
          onSecondary: Colors.white,
          error: vermelho,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF1B1B1F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: azul,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: azul,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: azul),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: azul,
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
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                    Icon(Icons.login, color: azul),
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
                    Icon(Icons.logout, color: vermelho),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
          ],
        ),
      ),
      body: telaAtual,
    );
  }
}
