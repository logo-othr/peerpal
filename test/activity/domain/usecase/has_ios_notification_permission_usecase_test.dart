import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

import 'has_ios_notification_permission_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
void main() {
  late IsIOSWithoutNotificationPermissionUseCase
      isIOSWithoutNotificationPermission;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockNotificationService = MockNotificationService();
    isIOSWithoutNotificationPermission =
        IsIOSWithoutNotificationPermissionUseCase(mockNotificationService);
  });

  group('IsIOSWithoutNotificationPermissionUseCase Tests', () {
    test('returns false when platform is iOS and has permission', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      when(mockNotificationService.hasPermission())
          .thenAnswer((_) async => true);

      expect(await isIOSWithoutNotificationPermission(), false);

      debugDefaultTargetPlatformOverride = null;
    });

    test('returns true when platform is iOS and has no permission', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      when(mockNotificationService.hasPermission())
          .thenAnswer((_) async => false);

      expect(await isIOSWithoutNotificationPermission(), true);

      debugDefaultTargetPlatformOverride = null;
    });

    test('returns false when platform is not iOS', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(await isIOSWithoutNotificationPermission(), false);

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
