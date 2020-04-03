import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final double salary;
  final int age;

  Employee({
    @required this.id,
    @required this.name,
    @required this.salary,
    this.age
  });

  @override
  List<Object> get props => [id, name, salary, age];
}
