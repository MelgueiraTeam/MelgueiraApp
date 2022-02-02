class Alerta {
  int id = 0;
  String? descricao = "";
  int? excluido = 0;

  double? tempMin = 0;
  double? umidMin = 0;
  double? tempMax = 0;
  double? umidMax = 0;

  DateTime? dataCadastro = DateTime.parse("0001-01-01 01:01:01");
  DateTime? dataAlteracao = DateTime.parse("0001-01-01 01:01:01");
  DateTime? dataExclusao = DateTime.parse("0001-01-01 01:01:01");

  Alerta(
      this.id,
      this.descricao,
      this.excluido,
      this.tempMin,
      this.umidMin,
      this.tempMax,
      this.umidMax,
      this.dataCadastro,
      this.dataAlteracao,
      this.dataExclusao);
}
