
import 'package:meta/meta.dart';

import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  final int id;
  final String name;
  final double salary;
  final int age;

  EmployeeModel({
    @required this.id,
    @required this.name,
    @required this.salary,
    this.age
  }) : super(
    id: id,
    name: name,
    salary: salary,
    age: age
  );

  factory EmployeeModel.fromJson(Map<String, dynamic> mapJson) {
    return EmployeeModel(
      id: mapJson['id'],
      name: mapJson['name'],
      salary: mapJson['salary'],
      age: mapJson['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'salary': this.salary,
      'age': this.age,
    };
  }
}


