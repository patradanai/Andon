class CategoryModel {
  int id;
  String machine;
  String zone;

  CategoryModel({this.id, this.machine, this.zone});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'], machine: json['processName'], zone: json['zoneName']);
  }
}

class EventProcess {
  int id;
  String machine;
  String operation;
  String date;
  String process;

  EventProcess({
    this.id,
    this.machine,
    this.operation,
    this.date,
    this.process,
  });

  factory EventProcess.fromJson(Map<String, dynamic> json) {
    return EventProcess(
      id: json['id'],
      machine: json['machine'],
      operation: json['operation'],
      date: json['timedate'],
      process: json['process'],
    );
  }
}
