import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/features/settings/data/repositories/settings_repository.dart';
import 'package:sociaanet/features/settings/presentation/viewmodel/settings_viewmodel.dart';

@GenerateNiceMocks([MockSpec<SettingsRepository>()])
import 'settings_viewmodel_test.mocks.dart';

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
  });

  test('initial state is correct', () {
    when(mockRepository.getSettings()).thenAnswer((_) async => Left(ApiFailure(message: 'not called')));

    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final state = container.read(settingsViewModelProvider);
    expect(state.isLoading, false);
    expect(state.settings, isNull);
  });
}
