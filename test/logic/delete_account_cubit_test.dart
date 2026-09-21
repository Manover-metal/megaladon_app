import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/delete_account/delete_account_cubit.dart';

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository({this.shouldThrow = false});
  final bool shouldThrow;

  @override
  Future deleteAccount(String password) async {
    if (shouldThrow) {
      throw DioException(
        requestOptions: RequestOptions(path: '/user/delete-account'),
        response: Response(
          requestOptions: RequestOptions(path: '/user/delete-account'),
          statusCode: 401,
        ),
      );
    }
    return {'success': true};
  }
}

void main() {
  // AuthBloc в конструкторе подписывается на ApiService.auth.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  group('DeleteAccountCubit', () {
    test('success path emits success', () async {
      final cubit = DeleteAccountCubit(
        AuthBloc(),
        repository: _FakeUserRepository(),
      );
      await cubit.deleteAccount('secret123');
      expect(cubit.state.status, DeleteAccountStatus.success);
    });

    test('error path emits error', () async {
      final cubit = DeleteAccountCubit(
        AuthBloc(),
        repository: _FakeUserRepository(shouldThrow: true),
      );
      await cubit.deleteAccount('wrong');
      expect(cubit.state.status, DeleteAccountStatus.error);
      expect(cubit.state.error, isNotNull);
    });
  });
}
