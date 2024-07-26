import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/app/data/location/dto/location.dart';
import 'package:peerpal/chat/domain/usecases/get_user.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';

import 'get_user_test.mocks.dart';

@GenerateMocks([AppUserRepository])
void main() {
  late GetUser usecase;
  late MockAppUserRepository mockAppUserRepository;

  setUp(() {
    mockAppUserRepository = MockAppUserRepository();
    usecase = GetUser(mockAppUserRepository);
  });

  final String userId = '1';
  final PeerPALUser testUser = PeerPALUser(
      id: '1',
      name: 'John Doe',
      age: 30,
      phoneNumber: '1234567890',
      imagePath: 'path/to/image.jpg',
      discoverFromAge: 18,
      discoverToAge: 35,
      discoverCommunicationPreferences: [CommunicationType.chat],
      discoverActivitiesCodes: ['code1', 'code2'],
      discoverLocations: [Location(place: 'Regensburg')],
      pushToken: 'token123');

  test(
    'should get a PeerPALUser object for the userId from the repository',
    () async {
      // Arrange
      when(mockAppUserRepository.getUser(any))
          .thenAnswer((_) async => testUser);

      // Act
      final resultUser = await usecase(userId);

      // Assert
      expect(resultUser, equals(testUser));
      verify(mockAppUserRepository.getUser(userId)).called(1);
      verifyNoMoreInteractions(mockAppUserRepository);
    },
  );
}
