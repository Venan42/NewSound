import 'package:flutter/material.dart';
import 'package:new_sound/componentes/avaliacao_estrelas.dart';

class CartaoEquipamento extends StatelessWidget {
  final Map<String, dynamic> equipamento;
  final double mediaAvaliacoes;
  final int totalAvaliacoes;
  final VoidCallback onTap;

  const CartaoEquipamento({
    super.key,
    required this.equipamento,
    required this.mediaAvaliacoes,
    required this.totalAvaliacoes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: cores.primary.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  equipamento['imagem'] ?? 'assets/imgs/produto.jpeg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.music_note,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Textos
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (equipamento['tipo'] ?? '').toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: cores.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipamento['titulo'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AvaliacaoEstrelas(
                    media: mediaAvaliacoes,
                    total: totalAvaliacoes,
                    tamanho: 13,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    equipamento['preco'] ?? '',
                    style: TextStyle(
                      color: cores.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}