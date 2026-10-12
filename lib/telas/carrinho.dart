import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_sound/gerenciador_estado.dart';

class Carrinho extends StatelessWidget {
  const Carrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final cores = Theme.of(context).colorScheme;

    final itens = estado.carrinho
        .map((id) => estado.equipamentoPorId(id))
        .whereType<Map<String, dynamic>>()
        .toList();

    if (itens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: cores.primary),
            const SizedBox(height: 12),
            const Text('Seu carrinho está vazio.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => estado.exibirEquipamentos(),
              child: const Text('Voltar aos Equipamentos'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: cores.primary),
                onPressed: () => estado.exibirEquipamentos(),
              ),
              Text(
                'Carrinho (${itens.length} ${itens.length == 1 ? 'item' : 'itens'})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cores.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final equipamento = itens[index];
              return Card(
                elevation: 1,
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: cores.primary.withValues(alpha: 0.2)),
                ),
                child: ListTile(
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.asset(
                      equipamento['imagem'] ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    equipamento['titulo'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    equipamento['preco'] ?? '',
                    style: TextStyle(
                      color: cores.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: cores.secondary,
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Efetuar compra'),
            onPressed: () {
              if (estado.finalizarCompra()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compra efetuada com sucesso!')),
                );
                estado.exibirEquipamentos();
              }
            },
          ),
        ),
      ],
    );
  }
}