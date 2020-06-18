class ModelMachine {
  final int id;
  final String name;

  ModelMachine({this.id, this.name});

  factory ModelMachine.fromJson(Map<String, dynamic> json) {
    return ModelMachine(
      id: json["machineId"],
      name: json["machine"],
    );
  }
}
