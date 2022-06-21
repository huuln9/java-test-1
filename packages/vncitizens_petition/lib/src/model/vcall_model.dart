class VCallModel {
  String avatarReceiver;
  Map<String, dynamic> dataOptions;
  String tokenCustomer;
  List<String> dest;
  String desName;

  VCallModel({
    required this.avatarReceiver,
    required this.dataOptions,
    required this.tokenCustomer,
    required this.dest,
    required this.desName,
  });

  Map<String, dynamic> toMap() {
    return {
      'avatarReceiver': avatarReceiver,
      'dataOptions': dataOptions,
      'tokenCustomer': tokenCustomer,
      'dest': dest,
      'desName': desName,
    };
  }

  factory VCallModel.fromMap(Map<String, dynamic> map) {
    return VCallModel(
      avatarReceiver: map['avatarReceiver'] as String,
      dataOptions: map['dataOptions'] as Map<String, dynamic>,
      tokenCustomer: map['tokenCustomer'] as String,
      dest: _castListDynToListStr(map["dest"] as List<dynamic>),
      desName: map['desName'] as String,
    );
  }

  static _castListDynToListStr(List<dynamic> list) {
    return list.map((e) => e as String).toList();
  }
}