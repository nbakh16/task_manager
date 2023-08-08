class TaskModel {
  String? status;
  List<TaskData>? taskData;

  TaskModel({this.status, this.taskData});

  TaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskData = <TaskData>[];
      json['data'].forEach((v) {
        taskData!.add(TaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskData != null) {
      data['data'] = taskData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskData {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  TaskData({this.sId, this.title, this.description, this.status, this.createdDate});

  TaskData.fromJson(Map<String, dynamic> json) {
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
