import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_sound/componentes/avaliacao_estrelas.dart';
import 'package:new_sound/gerenciador_estado.dart';

class Especificacoes extends StatelessWidget {
  const Especificacoes({super.key});

  Widget _titulo(String texto, Color cor) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final cores = Theme.of(context).colorScheme;
    final id = estado.idEquipamento;
    final equipamento = estado.equipamentoPorId(id);

    if (equipamento == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Equipamento não encontrado.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => estado.exibirEquipamentos(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      );
    }

    final comentarios = estado.comentariosDe(id);
    final comprou = estado.usuarioComprou(id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => estado.exibirEquipamentos(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
          ),
          const SizedBox(height: 8),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cores.primary.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              equipamento['imagem'] ?? '',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.music_note,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            (equipamento['tipo'] ?? '').toString().toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: cores.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            equipamento['titulo'] ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          AvaliacaoEstrelas(
            media: estado.mediaAvaliacoes(id),
            total: estado.totalAvaliacoes(id),
            tamanho: 18,
          ),
          const SizedBox(height: 8),
          Text(
            equipamento['preco'] ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: cores.secondary,
            ),
          ),
          _titulo('Descrição', cores.primary),
          Text(equipamento['descricao'] ?? ''),
          _titulo('Especificações técnicas', cores.primary),
          Text(equipamento['especificacoes'] ?? '', style: const TextStyle(height: 1.5)),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: estado.estaLogado
                  ? () {
                      estado.adicionarCarrinho(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Equipamento adicionado ao carrinho!'),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Adicionar ao Carrinho'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          if (!estado.estaLogado)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  'Faça login para adicionar ao carrinho.',
                  style: TextStyle(color: cores.secondary),
                ),
              ),
            ),
          const Divider(height: 40),
          Text(
            'Comentários (${comentarios.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cores.primary,
            ),
          ),
          const SizedBox(height: 8),
          // Só quem comprou o produto pode comentar
          if (comprou)
            _FormularioComentario(idEquipamento: id)
          else
            Text(
              estado.estaLogado
                  ? 'Compre este equipamento para poder comentar.'
                  : 'Faça login e compre este equipamento para poder comentar.',
              style: const TextStyle(color: Colors.black54),
            ),
          const SizedBox(height: 8),
          for (final c in comentarios)
            Card(
              elevation: 0,
              color: cores.primary.withValues(alpha: 0.05),
              surfaceTintColor: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            c['usuario'] ?? '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        AvaliacaoEstrelas(
                          media: (c['nota'] as int).toDouble(),
                          total: 1,
                          mostrarTexto: false,
                          tamanho: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(c['texto'] ?? ''),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FormularioComentario extends StatefulWidget {
  final int idEquipamento;
  const _FormularioComentario({required this.idEquipamento});

  @override
  State<_FormularioComentario> createState() => _FormularioComentarioState();
}

class _FormularioComentarioState extends State<_FormularioComentario> {
  final TextEditingController _controle = TextEditingController();
  int _nota = 5;

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _publicar() {
    final texto = _controle.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva um comentário antes de publicar.')),
      );
      return;
    }
    context
        .read<GerenciadorEstado>()
        .adicionarComentario(widget.idEquipamento, _nota, texto);
    _controle.clear();
    setState(() => _nota = 5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentário publicado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Deixe seu comentário',
            style: TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            for (int i = 1; i <= 5; i++)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(i <= _nota ? Icons.star : Icons.star_border,
                    color: cor),
                onPressed: () => setState(() => _nota = i),
              ),
          ],
        ),
        TextField(
          controller: _controle,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'O que você achou do equipamento?',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _publicar,
            child: const Text('Publicar'),
          ),
        ),
      ],
    );
  }
}