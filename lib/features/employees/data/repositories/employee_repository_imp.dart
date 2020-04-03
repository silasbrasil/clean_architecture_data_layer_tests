
import 'package:meta/meta.dart';

import '../../../../core/network_info.dart';
import '../../domain/repositories/employee_repository_i.dart';
import '../datasourses/employee_local_datasource.dart';
import '../datasourses/employee_remote_datasource.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImp implements EmployeeRepositoryI {

  final NetworkInfoI networkInfo;
  final EmployeeLocalDataSourceI localDataSource;
  final EmployeeRemoteDataSourceI remoteDataSource;

  EmployeeRepositoryImp({
    @required this.networkInfo,
    @required this.localDataSource,
    @required this.remoteDataSource
  });

  @override
  Stream<List<EmployeeModel>> getAllEmployees() async* {
    final localEmployees = await localDataSource.getAllEmployees();

    if (localEmployees != null) yield localEmployees;

    if (await networkInfo.isConnected) {
      final remoteEmployees = await remoteDataSource.getAllEmployees();
      if (remoteEmployees != null) yield remoteEmployees;
    }
  }
}

