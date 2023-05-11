class TimeslotsModel {
  Status? status;
  Result? result;

  TimeslotsModel({this.status, this.result});

  TimeslotsModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Status {
  String? code;
  String? msg;

  Status({this.code, this.msg});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    return data;
  }
}

class Result {
  String? status;
  List<Timeslots>? timeslots;
  SelectedValues? selectedValues;
  List<Questionnaire>? questionnaire;
  String? timezone;

  Result(
      {this.status,
      this.timeslots,
      this.selectedValues,
      this.questionnaire,
      this.timezone});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['timeslots'] != null) {
      timeslots = <Timeslots>[];
      json['timeslots'].forEach((v) {
        timeslots!.add(new Timeslots.fromJson(v));
      });
    }
    selectedValues = json['selected_values'] != null
        ? new SelectedValues.fromJson(json['selected_values'])
        : null;
    if (json['questionnaire'] != null) {
      questionnaire = <Questionnaire>[];
      json['questionnaire'].forEach((v) {
        questionnaire!.add(new Questionnaire.fromJson(v));
      });
    }
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.timeslots != null) {
      data['timeslots'] = this.timeslots!.map((v) => v.toJson()).toList();
    }
    if (this.selectedValues != null) {
      data['selected_values'] = this.selectedValues!.toJson();
    }
    if (this.questionnaire != null) {
      data['questionnaire'] =
          this.questionnaire!.map((v) => v.toJson()).toList();
    }
    data['timezone'] = this.timezone;
    return data;
  }
}

class Timeslots {
  int? time;
  bool? waitlist;
  String? note;

  Timeslots({this.time, this.waitlist, this.note});

  Timeslots.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    waitlist = json['waitlist'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['waitlist'] = this.waitlist;
    data['note'] = this.note;
    return data;
  }
}

class SelectedValues {
  String? selectedAdults;
  String? selectedChildren;
  String? selectedDateTime;

  SelectedValues(
      {this.selectedAdults, this.selectedChildren, this.selectedDateTime});

  SelectedValues.fromJson(Map<String, dynamic> json) {
    selectedAdults = json['selected_adults'];
    selectedChildren = json['selected_children'];
    selectedDateTime = json['selected_date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selected_adults'] = this.selectedAdults;
    data['selected_children'] = this.selectedChildren;
    data['selected_date_time'] = this.selectedDateTime;
    return data;
  }
}

class Questionnaire {
  String? id;
  List<String>? answerKeyword;
  String? questionText;
  String? mandatory;
  String? inputType;
  String? questionOrder;
  List<SubQuestions>? subQuestions;

  Questionnaire(
      {this.id,
      this.answerKeyword,
      this.questionText,
      this.mandatory,
      this.inputType,
      this.questionOrder,
      this.subQuestions});

  Questionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerKeyword = json['answer_keyword'].cast<String>();
    questionText = json['question_text'];
    mandatory = json['mandatory'];
    inputType = json['input_type'];
    questionOrder = json['question_order'];
    if (json['sub_questions'] != null) {
      subQuestions = <SubQuestions>[];
      json['sub_questions'].forEach((v) {
        subQuestions!.add(new SubQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer_keyword'] = this.answerKeyword;
    data['question_text'] = this.questionText;
    data['mandatory'] = this.mandatory;
    data['input_type'] = this.inputType;
    data['question_order'] = this.questionOrder;
    if (this.subQuestions != null) {
      data['sub_questions'] =
          this.subQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubQuestions {
  String? parentAnswerTrigger;
  String? id;
  List<String>? answerKeyword;
  String? questionText;
  String? mandatory;
  String? inputType;
  String? questionOrder;

  SubQuestions(
      {this.parentAnswerTrigger,
      this.id,
      this.answerKeyword,
      this.questionText,
      this.mandatory,
      this.inputType,
      this.questionOrder});

  SubQuestions.fromJson(Map<String, dynamic> json) {
    parentAnswerTrigger = json['parent_answer_trigger'];
    id = json['id'];
    answerKeyword = json['answer_keyword'].cast<String>();
    questionText = json['question_text'];
    mandatory = json['mandatory'];
    inputType = json['input_type'];
    questionOrder = json['question_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_answer_trigger'] = this.parentAnswerTrigger;
    data['id'] = this.id;
    data['answer_keyword'] = this.answerKeyword;
    data['question_text'] = this.questionText;
    data['mandatory'] = this.mandatory;
    data['input_type'] = this.inputType;
    data['question_order'] = this.questionOrder;
    return data;
  }
}