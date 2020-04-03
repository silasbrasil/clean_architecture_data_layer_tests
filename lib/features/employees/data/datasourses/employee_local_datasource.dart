import '../models/employee_model.dart';

abstract class EmployeeLocalDataSourceI {
  Future<List<EmployeeModel>> getAllEmployees();
}
