import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
import 'has_ios_notification_permission_usecase_test.mocks.dart';

void main() {
  late HasIOSNotificationPermissionUseCase hasIOSPermission;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockNotificationService = MockNotificationService();
    hasIOSPermission =
        HasIOSNotificationPermissionUseCase(mockNotificationService);
  });

  group('HasIOSNotificationPermissionUseCase Tests', () {
    test('returns true when platform is iOS and has permission', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      when(mockNotificationService.hasPermission())
          .thenAnswer((_) async => true);

      expect(await hasIOSPermission.call(), true);

      debugDefaultTargetPlatformOverride = null;
    });

    test('returns false when platform is iOS and has no permission', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      when(mockNotificationService.hasPermission())
          .thenAnswer((_) async => false);

      expect(await hasIOSPermission.call(), false);

      debugDefaultTargetPlatformOverride = null;
    });

    test('returns false when platform is not iOS', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(await hasIOSPermission.call(), false);

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
