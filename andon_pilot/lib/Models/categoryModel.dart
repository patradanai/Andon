class CategoryModel {
  String machine;
  String zone;

  CategoryModel({this.machine, this.zone});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(machine: json['machine'], zone: json['zone']);
  }
}

class EventProcess {
  int id;
  String machine;
  String operation;
  String date;
  String process;
  String zone;
  String operatorCode;
  String timecreated;

  EventProcess(
      {this.id,
      this.machine,
      this.operation,
      this.date,
      this.process,
      this.zone,
      this.operatorCode,
      this.timecreated});

  factory EventProcess.fromJson(Map<String, dynamic> json) {
    return EventProcess(
      id: json['eventId'],
      machine: json['name'],
      operation: json['request'],
      date: json['created'],
      process: json['status'],
      zone: json['zoneName'],
      operatorCode: json['operatorCode'],
      timecreated: json['created'],
    );
  }
}

class AppState {
  final List<CategoryModel> category;
  final List<EventProcess> process;
  final String status;

  AppState({this.category, this.process, this.status});

  factory AppState.initialState() => AppState(
        category: List.unmodifiable(<CategoryModel>[]),
        process: List.unmodifiable(
          <EventProcess>[],
        ),
        status: "",
      );
}
