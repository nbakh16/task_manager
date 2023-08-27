class TaskStatusCountModel {
  String? status;
  List<TaskCountModel>? taskCountModel;

  TaskStatusCountModel({this.status, this.taskCountModel});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskCountModel = <TaskCountModel>[];
      json['data'].forEach((v) {
        taskCountModel!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskCountModel != null) {
      data['data'] = taskCountModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskCountModel {
  String? sId;
  int? sum;

  TaskCountModel({this.sId, this.sum});

  TaskCountModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sum'] = sum;
    return data;
  }
}
