class TaskNotification {
  final int id;
  final String taskId;
  final String taskName;   // e.g. "consume_file", "train_classifier"
  final String? taskFileName;
  final DateTime dateCreated;
  final DateTime? dateDone;
  final String type;       // "auto_task" | "scheduled_task" | "manual_task"
  final String status;     // "PENDING" | "STARTED" | "SUCCESS" | "FAILURE" | "REVOKED"
  final String? result;
  final bool acknowledged;
  final String? relatedDocument; // document ID created by this task, if any

  const TaskNotification({
    required this.id,
    required this.taskId,
    required this.taskName,
    this.taskFileName,
    required this.dateCreated,
    this.dateDone,
    required this.type,
    required this.status,
    this.result,
    required this.acknowledged,
    this.relatedDocument,
  });

  bool get isFileTask => taskName == 'consume_file';

  factory TaskNotification.fromJson(Map<String, dynamic> json) {
    return TaskNotification(
      id: json['id'] as int,
      taskId: json['task_id'] as String,
      taskName: json['task_name'] as String? ?? '',
      taskFileName: json['task_file_name'] as String?,
      dateCreated: DateTime.parse(json['date_created'] as String).toLocal(),
      dateDone: json['date_done'] == null
          ? null
          : DateTime.parse(json['date_done'] as String).toLocal(),
      type: json['type'] as String? ?? '',
      status: json['status'] as String,
      result: json['result'] as String?,
      acknowledged: json['acknowledged'] as bool? ?? false,
      relatedDocument: json['related_document']?.toString(),
    );
  }

  TaskNotification copyWith({bool? acknowledged}) {
    return TaskNotification(
      id: id,
      taskId: taskId,
      taskName: taskName,
      taskFileName: taskFileName,
      dateCreated: dateCreated,
      dateDone: dateDone,
      type: type,
      status: status,
      result: result,
      acknowledged: acknowledged ?? this.acknowledged,
      relatedDocument: relatedDocument,
    );
  }
}
