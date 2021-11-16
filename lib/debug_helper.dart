import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class DebugHelper {
  static Future<UserCredential?> createFirebaseUser(
      String email, String password) async {
    UserCredential? userCredential;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'create-example-users', options: Firebase.app().options);
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    await app.delete();
    return Future.sync(() => userCredential);
  }

  static Future<String> createFirebaseExampleUser(
      String email, String password) async {
    UserCredential? userCredential =
        await DebugHelper.createFirebaseUser(email, password);
    if (userCredential != null && userCredential.user != null) {
      return userCredential.user!.uid;
    }
    return 'error-creating-example-user';
  }

  static Future<Activity> getRandomActivity(
      AppUserRepository appUserRepository) async {
    Random random = new Random();
    List<Activity> activityList = await appUserRepository.loadActivityList();
    int randomActivityListIndex = random.nextInt(activityList.length);
    return activityList[randomActivityListIndex];
  }

  static Future<List<Activity>> getRandomActivityList(
      int size, AppUserRepository appUserRepository) async {
    List<Activity>? discoverActivities = [];

    for (int i = 0; i < size; i++) {
      Activity newActivity = await getRandomActivity(appUserRepository);
      if (!discoverActivities.contains(newActivity))
        discoverActivities.add(newActivity);
    }
    return discoverActivities;
  }

  static Future<void> createExampleUsers(
      {required AppUserRepository appUserRepository,
      required String emailBase,
      required String password}) async {
    Random random = new Random();
    int randomAge = 0;
    int activityCount = 0;
    var uid = 'example-user';
    List<CommunicationType>? discoverCommunicationPreferences = [];

    var peerPALUser = PeerPALUser();

    discoverCommunicationPreferences = [
      CommunicationType.phone,
      CommunicationType.chat,
    ];
    uid = await createFirebaseExampleUser(
        "${emailBase}01@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Emilia',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 20,
      discoverToAge: 40,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Weiden'), Location(place: 'Mainz')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}02@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Hanna',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 18,
      discoverToAge: 35,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Weiden'),
        Location(place: 'Mainz'),
        Location(place: 'München'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}03@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Emma',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      discoverFromAge: 12,
      discoverToAge: 50,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Weiden'),
        Location(place: 'Mainz'),
        Location(place: 'München'),
        Location(place: 'Berlin'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}04@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Sofia',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath:
          'https://cdn-icons.flaticon.com/png/512/2202/premium/2202112.png?token=exp=1636566272~hmac=433bcb6c8c75cb2d761d3c1098e66b21',
      discoverFromAge: 16,
      discoverToAge: 25,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Weiden')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}05@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Mia',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath:
          'https://cdn-icons.flaticon.com/png/512/1785/premium/1785896.png?token=exp=1636566272~hmac=c8690172cf07774d84fc60f6918425b6',
      discoverFromAge: 25,
      discoverToAge: 60,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Weiden'), Location(place: 'Berlin')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}06@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Lina',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 30,
      discoverToAge: 70,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'München'),
        Location(place: 'Berlin')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}07@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Mila',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 50,
      discoverToAge: 90,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Köln'), Location(place: 'Mainz')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}08@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Ella',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 45,
      discoverToAge: 98,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Köln'),
        Location(place: 'Mainz'),
        Location(place: 'Weiden'),
        Location(place: 'Berlin'),
        Location(place: 'München'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}09@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Lea',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 27,
      discoverToAge: 36,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Köln'),
        Location(place: 'Weiden'),
        Location(place: 'Berlin'),
        Location(place: 'München'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}10@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Klara',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 22,
      discoverToAge: 52,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Köln'),
        Location(place: 'Berlin'),
        Location(place: 'München'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}11@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Noa',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 15,
      discoverToAge: 27,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Köln'), Location(place: 'Berlin')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}12@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Leon',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 20,
      discoverToAge: 35,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Köln')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}13@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Paul',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 10,
      discoverToAge: 57,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [Location(place: 'Köln'), Location(place: 'Berlin')],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}14@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Matteo',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 12,
      discoverToAge: 62,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Köln'),
        Location(place: 'Berlin'),
        Location(place: 'Berlin')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}15@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Ben',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 12,
      discoverToAge: 62,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Köln'),
        Location(place: 'Berlin'),
        Location(place: 'Berlin')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}16@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Elias',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 33,
      discoverToAge: 75,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Berlin'),
        Location(place: 'Köln'),
        Location(place: 'Weiden')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}17@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Finn',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 50,
      discoverToAge: 80,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Berlin'),
        Location(place: 'Weiden'),
        Location(place: 'Köln')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}18@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Felix',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 50,
      discoverToAge: 80,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Berlin'),
        Location(place: 'Weiden'),
        Location(place: 'Köln')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}19@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Henri',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 54,
      discoverToAge: 93,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Weiden'),
        Location(place: 'Köln'),
        Location(place: 'Mainz')
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);

    uid = await createFirebaseExampleUser(
        "${emailBase}20@peerpaltest.de", password);
    randomAge = random.nextInt(90) + 10;
    activityCount = random.nextInt(5);
    discoverCommunicationPreferences = [
      CommunicationType.chat,
      CommunicationType.phone,
    ];
    peerPALUser = PeerPALUser(
      id: uid,
      name: 'Luis',
      age: randomAge,
      phoneNumber: '0123456789',
      imagePath: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
      discoverFromAge: 12,
      discoverToAge: 25,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities:
          await getRandomActivityList(activityCount, appUserRepository),
      discoverLocations: [
        Location(place: 'Weiden'),
        Location(place: 'Köln'),
        Location(place: 'Mainz'),
        Location(place: 'Berlin'),
        Location(place: 'München'),
      ],
    );
    appUserRepository.updateUserInformation(peerPALUser, id: uid);
  }
}
