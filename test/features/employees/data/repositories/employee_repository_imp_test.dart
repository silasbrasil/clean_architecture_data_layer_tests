
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_arch_articles/core/network_info.dart';
import 'package:tdd_clean_arch_articles/features/employees/data/models/employee_model.dart';
import 'package:tdd_clean_arch_articles/features/employees/data/datasourses/employee_local_datasource.dart';
import 'package:tdd_clean_arch_articles/features/employees/data/datasourses/employee_remote_datasource.dart';
import 'package:tdd_clean_arch_articles/features/employees/data/repositories/employee_repository_imp.dart';

class NetworkInfoMock extends Mock implements NetworkInfoI {}
class EmployeeLocalDataSourceMock extends Mock implements EmployeeLocalDataSourceI {}
class EmployeeRemoteDataSourceMock extends Mock implements EmployeeRemoteDataSourceI {}

void main() {
  EmployeeRepositoryImp repository;
  NetworkInfoMock networkInfo;
  EmployeeLocalDataSourceMock localDataSource;
  EmployeeRemoteDataSourceMock remoteDataSource;

  setUp(() {
    networkInfo = NetworkInfoMock();
    localDataSource = EmployeeLocalDataSourceMock();
    remoteDataSource = EmployeeRemoteDataSourceMock();

    repository = EmployeeRepositoryImp(
      networkInfo: networkInfo,
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource
    );
  });

  final tEmployeeModelList2 = <EmployeeModel>[
    EmployeeModel(id: 1, name: 'João das Neves', salary: 1500.0, age: 24),
    EmployeeModel(id: 2, name: 'Maria das Neves', salary: 900.0, age: 22),
  ];

  final tEmployeeModelList4 = <EmployeeModel>[
    EmployeeModel(id: 1, name: 'João das Neves', salary: 1500.0, age: 24),
    EmployeeModel(id: 2, name: 'Maria das Neves', salary: 900.0, age: 22),
    EmployeeModel(id: 3, name: 'Geraldo', salary: 1200.0, age: 30),
    EmployeeModel(id: 4, name: '', salary: 1600.0, age: 55)
  ];

  final verifyInterationsDependences = () {
    verify(networkInfo.isConnected);
    verify(localDataSource.getAllEmployees());
    verify(remoteDataSource.getAllEmployees());
    verifyNoMoreInteractions(networkInfo);
    verifyNoMoreInteractions(localDataSource);
    verifyNoMoreInteractions(remoteDataSource);
  };

  group('Testes do EmployeeRepositoryImp', () {

    test('-> sem cache e com conexão', () async {
      // arranges
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(localDataSource.getAllEmployees()).thenAnswer((_) async => null);
      when(remoteDataSource.getAllEmployees())
        .thenAnswer((_) async => <EmployeeModel>[
          EmployeeModel(id: 1, name: 'João das Neves', salary: 1500.0, age: 24),
          EmployeeModel(id: 2, name: 'Maria das Neves', salary: 900.0, age: 22),
        ]);

      // acts
      final stream = repository.getAllEmployees();

      //asserts
      await expectLater(stream, emitsInOrder([ tEmployeeModelList2, emitsDone ]));
      verifyInterationsDependences();
    });

    test('Test with cache and connection', () async {
      // arranges
      when(networkInfo.isConnected)
        .thenAnswer((_) async => true);
      when(localDataSource.getAllEmployees())
        .thenAnswer((_) async => tEmployeeModelList2);
      when(remoteDataSource.getAllEmployees())
        .thenAnswer((_) async => tEmployeeModelList4);

      final expetedResponse = [
        tEmployeeModelList2,
        tEmployeeModelList4,
        emitsDone
      ];

      // acts
      final stream = repository.getAllEmployees();

      //asserts
      await expectLater(stream, emitsInOrder(expetedResponse));
      verifyInterationsDependences();
    });

    test('Test with cache and no connection', () async {
      // arranges
      when(networkInfo.isConnected)
        .thenAnswer((_) async => false);
      when(localDataSource.getAllEmployees())
        .thenAnswer((_) async => tEmployeeModelList2);
      when(remoteDataSource.getAllEmployees())
        .thenAnswer((_) async => tEmployeeModelList4);

      final expetedResponse = [
        tEmployeeModelList2,
        emitsDone
      ];

      // acts
      final stream = repository.getAllEmployees();

      //asserts
      await expectLater(stream, emitsInOrder(expetedResponse));
      verify(networkInfo.isConnected);
      verify(localDataSource.getAllEmployees());
      verifyNever(remoteDataSource.getAllEmployees());
      verifyNoMoreInteractions(networkInfo);
      verifyNoMoreInteractions(localDataSource);
      verifyZeroInteractions(remoteDataSource);
    });

    test('Test no cache and no connection', () async {
      // arranges
      when(networkInfo.isConnected)
        .thenAnswer((_) async => false);
      when(localDataSource.getAllEmployees())
        .thenAnswer((_) async => null);
      when(remoteDataSource.getAllEmployees())
        .thenAnswer((_) async => tEmployeeModelList4);

      final expetedResponse = [ emitsDone ];

      // acts
      final stream = repository.getAllEmployees();

      //asserts
      await expectLater(stream, emitsInOrder(expetedResponse));

      verify(networkInfo.isConnected);
      verify(localDataSource.getAllEmployees());
      verifyNever(remoteDataSource.getAllEmployees());
      verifyNoMoreInteractions(networkInfo);
      verifyNoMoreInteractions(localDataSource);
      verifyZeroInteractions(remoteDataSource);
    });
  });
}

