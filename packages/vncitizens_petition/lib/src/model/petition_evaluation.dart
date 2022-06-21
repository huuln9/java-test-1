class PetitionEvaluation {
  final String? evaluator;
  final int? evaluatorType;
  final int? evaluatorValue;

  PetitionEvaluation({this.evaluator, this.evaluatorType, this.evaluatorValue});

  Map<String, String> toJson() {
    final _data = <String, String>{};
    _data['evaluator'] = evaluator.toString();
    _data['evaluatorType'] = evaluatorType.toString();
    _data['evaluatorValue'] = evaluatorValue.toString();
    return _data;
  }
}
