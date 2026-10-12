import 'package:flutter/material.dart';

class AvaliacaoEstrelas extends StatelessWidget {
  final double media;
  final int total;
  final double tamanho;
  final bool mostrarTexto;

  const AvaliacaoEstrelas({
    super.key,
    required this.media,
    required this.total,
    this.tamanho = 14,
    this.mostrarTexto = true,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.secondary;

    if (total == 0) {
      return Text(
        'Sem avaliações',
        style: TextStyle(fontSize: tamanho - 2, color: Colors.black54),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            media >= i
                ? Icons.star
                : (media >= i - 0.5 ? Icons.star_half : Icons.star_border),
            size: tamanho,
            color: cor,
          ),
        if (mostrarTexto) ...[
          const SizedBox(width: 4),
          Text(
            '${media.toStringAsFixed(1)} ($total)',
            style: TextStyle(fontSize: tamanho - 2, color: Colors.black87),
          ),
        ],
      ],
    );
  }
}