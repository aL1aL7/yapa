class TaskNotification {
  final int id;
  final String taskId;
  final String? taskFileName;
  final DateTime dateCreated;
  final DateTime? dateDone;
  final String type;
  final String status;
  final String? result;
  final bool acknowledged;

  const TaskNotification({
    required this.id,
    required this.taskId,
    this.taskFileName,
    required this.dateCreated,
    this.dateDone,
    required this.type,
    required this.status,
    this.result,
    required this.acknowledged,
  });

  factory TaskNotification.fromJson(Map<String, dynamic> json) {
    return TaskNotification(
      id: json['id'] as int,
      taskId: json['task_id'] as String,
      taskFileName: json['task_file_name'] as String?,
      dateCreated: DateTime.parse(json['date_created'] as String).toLocal(),
      dateDone: json['date_done'] == null
          ? null
          : DateTime.parse(json['date_done'] as String).toLocal(),
      type: json['type'] as String? ?? 'file',
      status: json['status'] as String,
      result: json['result'] as String?,
      acknowledged: json['acknowledged'] as bool? ?? false,
    );
  }

  TaskNotification copyWith({bool? acknowledged}) {
    return TaskNotification(
      id: id,
      taskId: taskId,
      taskFileName: taskFileName,
      dateCreated: dateCreated,
      dateDone: dateDone,
      type: type,
      status: status,
      result: result,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }
}
