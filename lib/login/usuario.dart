class Usuario {
  String _nome = "";
  String get nome => _nome;

  String _email = "";
  String get email => _email;

  List<dynamic> _compras = [];
  List<dynamic> get compras => _compras;

  Usuario(this._nome, this._email, [dynamic compras]) {
    if (compras != null) {
      _compras = compras;
    }
  }

  adicionarCompras(List<dynamic> carrinho) {
    _compras.add(carrinho);
  }
}
