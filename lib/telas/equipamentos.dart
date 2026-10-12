import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_sound/componentes/cartao_equipamento.dart';
import 'package:new_sound/gerenciador_estado.dart';

class Equipamentos extends StatelessWidget {
  const Equipamentos({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final cores = Theme.of(context).colorScheme;

    if (estado.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (estado.equipamentos.isEmpty) {
      return const Center(child: Text('Nenhum equipamento encontrado.'));
    }

    return Column(
      children: [
        // Cabeçalho com carrinho
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          color: cores.primary.withValues(alpha: 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catálogo (${estado.equipamentos.length} itens)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: cores.primary,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: cores.primary),
                    onPressed: () => estado.exibirCarrinho(),
                  ),
                  if (estado.carrinho.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cores.secondary,
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
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: estado.equipamentos.length,
            itemBuilder: (context, index) {
              final equipamento = estado.equipamentos[index];
              final id = equipamento['id'] as int;
              return CartaoEquipamento(
                equipamento: equipamento,
                mediaAvaliacoes: estado.mediaAvaliacoes(id),
                totalAvaliacoes: estado.totalAvaliacoes(id),
                onTap: () => estado.exibirEspecificacoes(id),
              );
            },
          ),
        ),
      ],
    );
  }
}