import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSourceI {
  Future<List<EmployeeModel>> getAllEmployees();
}
