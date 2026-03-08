import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/settings/data/datasources/settings_datasource.dart';
import 'package:sociaanet/features/settings/data/repositories/settings_repository.dart';

@GenerateNiceMocks([MockSpec<SettingsRemoteDatasource>()])
import 'settings_usecase_test.mocks.dart';

void main() {
  late SettingsRepository repository;
  late MockSettingsRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSettingsRemoteDatasource();
    repository = SettingsRepository(datasource: mockDatasource);
  });

  test('getSettings should return UserSettings on success', () async {
    when(mockDatasource.getSettings()).thenAnswer((_) async => {
          'privacy': {
            'private_account': false,
            'show_activity_status': true,
            'show_read_receipts': true,
            'allow_messages_from': 'everyone',
            'allow_comments_from': 'everyone',
            'blocked_users': <Map<String, dynamic>>[],
          },
          'notifications': {
            'likes': true,
            'comments': true,
            'mentions': true,
            'follows': true,
            'messages': true,
            'push_enabled': true,
            'email_enabled': false,
          },
          'appearance': {
            'theme': 'system',
            'font_size': 'medium',
            'reduced_motion': false,
          },
          'feed': {
            'mode': 'algorithmic',
            'show_suggested_posts': true,
            'autoplay_videos': true,
          },
          'security': {
            'sessions': <Map<String, dynamic>>[],
          },
        });

    final result = await repository.getSettings();

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (settings) {
        expect(settings.privacy.privateAccount, false);
        expect(settings.notifications.likes, true);
      },
    );
  });
}
