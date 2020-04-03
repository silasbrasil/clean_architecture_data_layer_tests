
import '../entities/employee.dart';

abstract class EmployeeRepositoryI {
  Stream<List<Employee>> getAllEmployees();
}

