import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/logic/screens/auth/password_recovery/password_recovery_cubit.dart';

void main() {
  group('PasswordRecoveryCubit.checkStep1', () {
    test('valid phone returns true and marks phone valid', () {
      final cubit = PasswordRecoveryCubit();
      expect(cubit.checkStep1(phone: '+77001234567'), isTrue);
      expect(cubit.state.phone.isValid, isTrue);
      expect(cubit.state.status, PasswordRecoveryStatus.initial);
    });

    test('empty phone returns false and marks phone invalid', () {
      final cubit = PasswordRecoveryCubit();
      expect(cubit.checkStep1(phone: ''), isFalse);
      expect(cubit.state.phone.isValid, isFalse);
    });
  });

  group('PasswordRecoveryCubit.checkStep2', () {
    test('valid code and matching passwords return true', () {
      final cubit = PasswordRecoveryCubit();
      expect(
        cubit.checkStep2(
          code: '101010',
          password: 'password1',
          passwordConfirmation: 'password1',
        ),
        isTrue,
      );
      expect(cubit.state.status, PasswordRecoveryStatus.initial2);
    });

    test('mismatched confirmation returns false', () {
      final cubit = PasswordRecoveryCubit();
      expect(
        cubit.checkStep2(
          code: '101010',
          password: 'password1',
          passwordConfirmation: 'password2',
        ),
        isFalse,
      );
      expect(cubit.state.passwordConfirmation.isValid, isFalse);
    });

    test('short code returns false', () {
      final cubit = PasswordRecoveryCubit();
      expect(
        cubit.checkStep2(
          code: '123',
          password: 'password1',
          passwordConfirmation: 'password1',
        ),
        isFalse,
      );
      expect(cubit.state.code.isValid, isFalse);
    });
  });
}
