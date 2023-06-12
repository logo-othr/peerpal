import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

class MockNotificationService extends Mock implements NotificationService {
  Future<bool> hasPermission() {
    return super.noSuchMethod(Invocation.method(#hasPermission, null),
        returnValue: Future.value(true));
  }
}

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
      // Force the platform to be iOS
      TestWidgetsFlutterBinding.ensureInitialized();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      when(mockNotificationService.hasPermission())
          .thenAnswer((_) async => true);

      expect(await hasIOSPermission.call(), true);

      // Reset the platform after the test
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
