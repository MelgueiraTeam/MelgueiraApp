class boxMelgueira {
   double _temperatura_ninho;
   double _umidade_ninho;

   double _temperatura_melgueira;
   double _umidade_melgueira;

    double time = 0;

  boxMelgueira(this._temperatura_ninho, this._umidade_ninho,
      this._temperatura_melgueira, this._umidade_melgueira, this.time);

  double get temperatura_ninho => _temperatura_ninho;

  double get umidade_melgueira => _umidade_melgueira;

  set umidade_melgueira(double value) {
    _umidade_melgueira = value;
  }

  double get temperatura_melgueira => _temperatura_melgueira;

  set temperatura_melgueira(double value) {
    _temperatura_melgueira = value;
  }

  double get umidade_ninho => _umidade_ninho;

  set umidade_ninho(double value) {
    _umidade_ninho = value;
  }

  set temperatura_ninho(double value) {
    _temperatura_ninho = value;
  }
}