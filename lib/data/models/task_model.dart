class TaskModel {
  String? status;
  List<Task>? task;

  TaskModel({this.status, this.task});

  TaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      task = <Task>[];
      json['data'].forEach((v) {
        task!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (task != null) {
      data['data'] = task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  Task({this.sId, this.title, this.description, this.status, this.createdDate});

  Task.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['createdDate'] = createdDate;
    return data;
  }
}
