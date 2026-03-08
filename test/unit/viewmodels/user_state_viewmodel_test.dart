import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/features/auth/presentation/state/user_state.dart';

void main() {
  test('CurrentUserNotifier initial state is null', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(currentUserProvider);
    expect(state, isNull);
  });
}
