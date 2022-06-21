class TagModel {
  String id;
  int order;
  String name;

  TagModel({
    required this.id,
    required this.order,
    required this.name,
  });

  @override
  String toString() {
    return 'TagModel{' ' id: $id,' ' order: $order,' ' name: $name,' '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'name': name,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] as String,
      order: map['order'] as int,
      name: map['name'] as String,
    );
  }
}