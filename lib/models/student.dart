class Student{
  final int id;
  final String name;
  final int age;

  /// create a constructor that takes three params i.e. id, name, age
  Student({
    required this.id,
    required this.name,
    required this.age});

  /// convert from json to object
  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
        id: json['id'],
        name: json['name'],
        age: json['age']
    );
  }

  /// convert from object to json
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
  };


}