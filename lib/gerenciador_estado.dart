import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/usuario.dart';

enum EmExibicao { telaEquipamentos, telaEspecificacoes, telaCarrinho }

class GerenciadorEstado extends ChangeNotifier {
  GerenciadorEstado() {
    _carregarEquipamentos();
  }

  EmExibicao _exibicao = EmExibicao.telaEquipamentos;
  EmExibicao get exibicao => _exibicao;

  int _idEquipamento = -1;
  int get idEquipamento => _idEquipamento;

  void exibirEquipamentos() {
    _exibicao = EmExibicao.telaEquipamentos;
    notifyListeners();
  }

  void exibirEspecificacoes(int idEquipamento) {
    _exibicao = EmExibicao.telaEspecificacoes;
    _idEquipamento = idEquipamento;
    notifyListeners();
  }

  void exibirCarrinho() {
    _exibicao = EmExibicao.telaCarrinho;
    notifyListeners();
  }

  List<Map<String, dynamic>> _equipamentos = [];
  List<Map<String, dynamic>> get equipamentos => _equipamentos;

  bool _carregando = true;
  bool get carregando => _carregando;

  final Map<int, List<Map<String, dynamic>>> _comentarios = {};

  Future<void> _carregarEquipamentos() async {
    try {
      final String resposta =
          await rootBundle.loadString('assets/jsons/equipamentos.json');
      final List<dynamic> dados = json.decode(resposta);

      _equipamentos =
          dados.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      final String respostaComentarios =
          await rootBundle.loadString('assets/jsons/comentarios.json');
      final List<dynamic> dadosComentarios = json.decode(respostaComentarios);

      for (final c in dadosComentarios) {
        final comentario = Map<String, dynamic>.from(c as Map);
        final id = comentario['idEquipamento'] as int;
        _comentarios.putIfAbsent(id, () => []).add({
          'usuario': comentario['usuario'],
          'nota': comentario['nota'],
          'texto': comentario['texto'],
        });
      }
    } catch (e, stacktrace) {
      debugPrint('Erro ao carregar JSON: $e');
      debugPrint('Stacktrace: $stacktrace');
    }
    _carregando = false;
    notifyListeners();
  }

  Map<String, dynamic>? equipamentoPorId(int id) {
    for (final e in _equipamentos) {
      if (e['id'] == id) return e;
    }
    return null;
  }

  List<Map<String, dynamic>> comentariosDe(int id) => _comentarios[id] ?? [];

  int totalAvaliacoes(int id) => comentariosDe(id).length;

  double mediaAvaliacoes(int id) {
    final lista = comentariosDe(id);
    if (lista.isEmpty) return 0;
    final soma = lista.fold<int>(0, (s, c) => s + (c['nota'] as int));
    return soma / lista.length;
  }

  void adicionarComentario(int id, int nota, String texto) {
    if (_usuario == null) return;
    _comentarios.putIfAbsent(id, () => []);
    _comentarios[id]!.insert(0, {
      'usuario': _usuario!.nome,
      'nota': nota,
      'texto': texto,
    });
    notifyListeners();
  }

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _estaLogado = false;
  bool get estaLogado => _estaLogado;

  void login(Usuario? usuario) {
    _usuario = usuario;
    _estaLogado = true;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    _estaLogado = false;
    _carrinho.clear(); 
    notifyListeners();
  }

  final List<int> _carrinho = [];
  List<int> get carrinho => _carrinho;

  void adicionarCarrinho(int idEquipamento) {
    _carrinho.add(idEquipamento);
    notifyListeners();
  }

  bool finalizarCompra() {
    if (_usuario == null || _carrinho.isEmpty) return false;
    _usuario!.adicionarCompras(List<int>.from(_carrinho));
    _carrinho.clear();
    notifyListeners();
    return true;
  }

  bool usuarioComprou(int idEquipamento) {
    return _usuario?.compras.contains(idEquipamento) ?? false;
  }
}