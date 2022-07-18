class UserDatabaseContract {
  static const publicUsers = 'publicUserData';
  static const privateUsers = 'privateUserData';
  static const uid = 'id';
  static const userId = 'userId';
  static const userAge = 'age';
  static const userName = 'name';
  static const userPhoneNumber = 'phone_number';
  static const userProfilePicturePath = 'avatar_path';
  static const discoverFromAge = 'discoverFromAge';
  static const discoverToAge = 'discoverToAge';
  static const chatPreference = 'hasChatCommunicationPreference';
  static const phonePreference = 'hasPhoneCommunicationPreference';
  static const discoverActivities = 'discoverActivities';
  static const discoverLocations = 'discoverLocations';
  static const chat = 'chats';
  static const chatUids = 'uids';
  static const friendsCollection = 'friends';
  static const chatMessages = 'messages';
  static const chatTimestamp = 'lastUpdated';
  static const deviceToken = 'pushToken';
  static const serverDeleteDeviceTokenQueue = 'deleteDeviceTokenFromServer';
  static const serverUpdateDeviceTokenQueue = 'updateDeviceTokenAtServer';
}
