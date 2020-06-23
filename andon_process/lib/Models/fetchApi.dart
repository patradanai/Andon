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

class ModelRequest {
  final String machine;
  final String request;

  ModelRequest({this.machine, this.request});

  factory ModelRequest.fromJson(Map<String, dynamic> json) {
    return ModelRequest(
      machine: json['machine'],
      request: json['request'],
    );
  }
}
