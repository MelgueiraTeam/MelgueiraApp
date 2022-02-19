class MediaBox {
  int id = 0;

  double? temperatura_ninho = 0;
  double? umidade_ninho = 0;

  DateTime? dia = DateTime.parse("0001-01-01 01:01:01");

  double? temperatura_melgueira = 0;
  double? umidade_melgueira = 0;

  MediaBox(this.id, this.temperatura_ninho, this.umidade_ninho, this.dia, this.temperatura_melgueira,
      this.umidade_melgueira);

  String tString() {
    return "MediaBox { id: ${id}.  temperatura_ninho: ${temperatura_ninho}. umidade_ninho: ${umidade_ninho}. Dia: ${dia}. " +
        "temperatura_melgueira: ${temperatura_melgueira}. umidade_melgueira: ${umidade_melgueira}";
  }
}
