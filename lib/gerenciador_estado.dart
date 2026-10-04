import 'package:flutter/material.dart';
import 'login/usuario.dart';

enum EmExibicao { telaEquipamentos, telaEspecificacoes, telaCarrinho }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaEquipamentos;
  EmExibicao get exibicao => _exibicao;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _estaLogado = false;
  bool get estaLogado => _estaLogado;

  int _idEquipamento = -1;
  int get idEquipamento => _idEquipamento;

  List<dynamic> _carrinho = [];
  List<dynamic> get carrinho => _carrinho;

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

  void login(Usuario? usuario) {
    _usuario = usuario;
    _estaLogado = true;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    _estaLogado = false;
    notifyListeners();
  }

  void adicionarCarrinho(int idEquipamento) {
    carrinho.add(idEquipamento);
    notifyListeners();
  }
}