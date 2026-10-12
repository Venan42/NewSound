import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_sound/componentes/cartao_equipamento.dart';
import 'package:new_sound/gerenciador_estado.dart';

class Equipamentos extends StatelessWidget {
  const Equipamentos({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();

    if (estado.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (estado.equipamentos.isEmpty) {
      return const Center(child: Text('Nenhum equipamento encontrado.'));
    }

    return GridView.builder(
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
    );
  }
}