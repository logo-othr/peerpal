console.log("Executing contracts.js")

/**
 * contracts.js serves as a centralized configuration file that defines constants
 * for various document types, observer names, collection names, push notification 
 * use cases, and other frequently used strings. This approach ensures consistency 
 * across the application, facilitates easy updates, and improves code maintainability.
 */

//General
const DOCUMENT_TYPE = 'added';
const IS_ALREADY_EVALUATED_FROM_SERVER = 'isAlreadyEvaluatedFromServer';
const CHAT_REQUEST_ACCEPTED = 'chatRequestAccepted';
const EQUAL = '==';
const ID = 'id';
const CREATOR_ID = 'creatorId';
const CREATOR_NAME = 'creatorName';
const DATE = 'date';
const DESCRIPTION = 'description';
const LOCATION = 'location';
const PUBLIC = 'public';
const ATTENDEE_IDS = 'attendeeIds';
const INVITATION_IDS = 'invitationIds';
const FROM_ID = 'fromId';
const TO_ID = 'toId';
const STARTED_BY = 'startedBy';
const UIDS = 'uids';
const ARRAY_CONTAINS = 'array-contains';
const CHAT_ID = 'chatId';
const DEFAULT_STRING = '';
const LAST_UPDATED = 'lastUpdated';
const TYPE = 'type';
const USER_ID = 'userId';
const LEAVING_ID = 'leavingId';
const JOINING_ID = 'joiningId';
const TIMESTAMP = 'timestamp';
const MESSAGE = 'message';
const DEVICE_TOKEN = 'pushToken';
const CODE = 'code';
const NAME = 'name';
const NO_ID_SPECIFIED = 'No ID has been specified.';
const NO_TYPE_SPECIFIED = 'No TYPE has been specified.';
const FLUTTER_NOTIFICATION_CLICK = 'FLUTTER_NOTIFICATION_CLICK';

//Observer
const DELETE_FRIEND_OBSERVER = 'deleteFriendObserver'
const UPDATE_NAME_OBSERVER = 'updateNameObserver';
const FRIEND_REQUEST_NOTIFICATION_OBSERVER = 'friendRequestNotificationObserver';
const FRIEND_REQUEST_RESPONSE_OBSERVER = 'friendRequestResponseObserver';
const CANCELED_FRIEND_REQUESTS_OBSERVER = 'canceledFriendRequestsObserver';
const DELETE_DEVICE_TOKEN_OBSERVER = 'deleteDeviceTokenObserver';
const UPDATE_DEVICE_TOKEN_OBSERVER = 'updateDeviceTokenObserver';
const CHAT_NOTIFICATION_OBSERVER = 'chatNotificationObserver';
const CHAT_REQUEST_RESPONSE_OBSERVER = 'chatRequestResponseObserver';
const ACTIVITY_NOTIFICATION_OBSERVER = 'activityNotificactionObserver';
const UPDATE_ACTIVITY_OBSERVER = 'updateActivityObserver';
const JOIN_ACTIVITY_OBSERVER = 'joinActivityObserver';
const LEAVE_ACTIVITY_OBSERVER = 'leaveActivityObserver';
const DELETE_ACTIVITY_OBSERVER = 'deleteActivityObserver';
const DELETE_USER_FROM_FIREBASE_OBSERVER = 'deleteUserFromFirebaseObserver';

//Document names
const DELETE_FRIEND_DOCUMENT = 'deleteFriendDocument';
const CHATS_DOCUMENT = 'chatsDocument';
const FRIENDS_DOCUMENT = 'FriendsDocument';
const UPDATE_NAME_AT_SERVER_DOCUMENT = 'updateNameAtServerDocument';
const ACTIVITY_NOTIFICATION_DOCUMENT = 'activityNotificactionDocument';
const NEW_ACTIVITY_NOTIFICATION_DOCUMENT = 'newActivityDocument'
const UPDATE_DEVICE_TOKEN_DOCUMENT = 'updateDeviceTokenDocument';
const DELETE_DEVICE_TOKEN_DOCUMENT = 'deleteDeviceTokenDocument';
const FRIEND_REQUEST_NOTIFICATIONS_DOCUMENT = 'friendRequestNotificationDocument';
const FRIEND_REQUEST_RESPONSE_DOCUMENT = 'friendRequestResponseDocument';
const CANCELED_FRIEND_REQUESTS_DOCUMENT = 'canceledFriendRequestsDocument';

//Collection names
const UPDATE_NAME_AT_SERVER_COLLECTION = `updateNameAtServer`;
const ACTIVITIES_COLLECTION = `activities`;
const STATISTIC_CREATED_ACTIVITIES_COLLECTION = `statisticCreatedActivities`;
const UPDATE_ACTIVITY_COLLECTION = `updateActivity`;
const STATISTIC_UPDATE_ACTIVITY_COLLECTION = `statisticUpdateActivity`;
const JOIN_ACTIVITY_COLLECTION = `joinActivity`;
const STATISTIC_JOIN_ACTIVITY_COLLECTION = `statisticJoinActivity`;
const LEAVE_ACTIVITY_COLLECTION = `leaveActivity`;
const STATISTIC_LEAVE_ACTIVITY_COLLECTION = `statisticLeaveActivity`;
const DELETE_ACTIVITY_COLLECTION = `deleteActivity`;
const STATISTIC_DELETE_ACTIVITY_COLLECTION = `statisticDeleteActivity`;
const STATISTIC_SENT_CHAT_REQUESTS_COLLECTION = `statisticSentChatRequests`;
const CHAT_NOTIFICATIONS_COLLECTION = `chatNotifications`;
const CHAT_REQUEST_RESPONSE_COLLECTION = `chatRequestResponse`;
const STATISTIC_CHAT_REQUEST_RESPONSE_COLLECTION = `statisticChatRequestResponse`;
const CHATS_COLLECTION = `chats`;
const FRIENDS_COLLECTION = `friends`;
const DELETE_FRIEND_COLLECTION = `deleteFriend`
const MESSAGES_COLLECTION = 'messages';
const DELETE_DEVICE_TOKEN_FROM_SERVER_COLLECTION = `deleteDeviceTokenFromServer`;
const UPDATE_DEVICE_TOKEN_AT_SEREVER_COLLECTION = `updateDeviceTokenAtServer`;
const PRIVATE_USER_DATA_COLLECTION = 'privateUserData';
const PUBLIC_USER_DATA_COLLECTION = 'publicUserData';
const FRIEND_REQUEST_NOTIFICATIONS_COLLECTION = `friendRequestNotifications`;
const FRIEND_REQUESTS_COLLECTION = `friendRequests`;
const FRIEND_REQUEST_RESPONSE_COLLECTION = `friendRequestResponse`;
const CANCELED_FRIEND_REQUESTS_COLLECTION = `canceledFriendRequests`;
const STATISTIC_FRIEND_REQUEST_COLLECTION = `statisticFriendRequestNotifications`;
const STATISTIC_FRIEND_REQUEST_RESPONSE_COLLECTION = `statisticFriendRequestResponse`
const STATISTIC_CANCELED_FRIEND_REQUESTS_COLLECTION = `statisticCanceledFriendRequests`
const DELETE_USER_COLLECTION = `deleteUser`;

//Push Notification Usecases
const ACTIVITY_INVITATION_USECASE = 'activityInvitation';
const ACTIVITY_REMINDER_USERCASE = 'activityReminder';
const CHAT_MESSAGE_USECASE = 'chatMessage';
const CHAT_REQUEST_USECASE = 'chatRequest';
const FRIEND_REQUEST_USECASE = `friendRequest`;

//Type of push notification
const TYPE_CHAT = 'chat';
const TYPE_CHAT_REQUEST = 'chatRequest';
const TYPE_FRIEND_REQUEST = 'freindRequest';
const TYPE_ACTIVITY_INVITATION = 'activityInvitation'
const TYPE_ACTIVITY_REMINDER = 'activityReminder'

//Output informations
const SET = 'set';
const SETTING = 'setting';
const UPDATED = 'updated';
const UPDATING = 'updating';
const DELETED = 'deleted';
const DELETING = 'deleting';
const DELETE = 'delete';
const REMOVED = 'removed';
const REMOVING = 'removing';
const ADDED = 'added';
const ADDING = 'adding';
const READ_AND_UPDATE = 'read and update';
const READING_AND_UPDATING = 'reading and updating';
const READ = 'read';
const READING = 'reading';
const SENDING = 'sending';
const SENT = 'sent';
const GETTING = 'getting';

//Push-Notifications
const ACTIVITY_REMINDER_TITLE = 'Aktivitätenerinnerung';
const ACTIVITY_INVITE_TITLE = 'Aktivitäteneinladung';
const FRIEND_REQUEST_NOTIFICATION_TITLE = 'Freundschaftsanfrage';
const CHAT_REQUEST_TITLE = `Nachrichtenanfrage`;

function getActivityReminderBody(activityName, activityDate) {
    const ACTIVITY_REMINDER_BODY = `${activityName} wurde auf den ${activityDate} Uhr verschoben`;
    console.log(`${activityName} wurde auf den ${activityDate} Uhr verschoben.`);

    return ACTIVITY_REMINDER_BODY;
}

function getChatNotificationTitle(userName) {
    const CHAT_NOTIFICATION_TITLE = `Neue Nachricht von ${userName}`;
    return CHAT_NOTIFICATION_TITLE;
}

function getChatRequestBody(userName) {
    const CHAT_REQUEST_BODY = `Neue Nachrichtenanfrage von ${userName}`;
    return CHAT_REQUEST_BODY;
}

function getFriendRequestBody(userName) {
    const FRIEND_REQUEST_BODY = `Neue Freundschaftsanfrage von ${userName}`;
    return FRIEND_REQUEST_BODY;
}

function getActivityInviteBody(userName) {
    const ACTIVITY_INVITE_BODY = `Neue Aktivitäteneinladung von ${userName}`;
    return ACTIVITY_INVITE_BODY;
}

module.exports = {
    TYPE_CHAT,
    TYPE_CHAT_REQUEST,
    TYPE_FRIEND_REQUEST,
    TYPE_ACTIVITY_INVITATION,
    TYPE_ACTIVITY_REMINDER,
    LEAVING_ID,
    JOINING_ID,
    ACTIVITY_REMINDER_TITLE,
    ACTIVITY_INVITE_TITLE,
    FRIEND_REQUEST_NOTIFICATION_TITLE,
    CHAT_REQUEST_TITLE,
    getActivityInviteBody,
    getActivityReminderBody,
    getFriendRequestBody,
    getChatRequestBody,
    getChatNotificationTitle,
    FLUTTER_NOTIFICATION_CLICK,
    NO_ID_SPECIFIED,
    NO_TYPE_SPECIFIED,
    CHAT_NOTIFICATION_OBSERVER,
    CHAT_REQUEST_RESPONSE_OBSERVER,
    ACTIVITY_NOTIFICATION_OBSERVER,
    UPDATE_ACTIVITY_OBSERVER,
    JOIN_ACTIVITY_OBSERVER,
    LEAVE_ACTIVITY_OBSERVER,
    DELETE_ACTIVITY_OBSERVER,
    UPDATE_NAME_OBSERVER,
    FRIEND_REQUEST_NOTIFICATION_OBSERVER,
    FRIEND_REQUEST_RESPONSE_OBSERVER,
    CANCELED_FRIEND_REQUESTS_OBSERVER,
    DELETE_DEVICE_TOKEN_OBSERVER,
    UPDATE_DEVICE_TOKEN_OBSERVER,
    DELETE_USER_FROM_FIREBASE_OBSERVER,
    DELETE_FRIEND_OBSERVER,
    TYPE,
    LAST_UPDATED,
    MESSAGE,
    DEVICE_TOKEN,
    CODE,
    NAME,
    TIMESTAMP,
    USER_ID,
    DEFAULT_STRING,
    CREATOR_NAME,
    DATE,
    DESCRIPTION,
    LOCATION,
    PUBLIC,
    SET,
    SETTING,
    UPDATED,
    UPDATING,
    READ,
    READING,
    SENDING,
    SENT,
    DELETED,
    DELETING,
    DELETE,
    GETTING,
    REMOVED,
    REMOVING,
    READ_AND_UPDATE,
    READING_AND_UPDATING,
    ADDED,
    ADDING,
    PUBLIC_USER_DATA_COLLECTION,
    FRIEND_REQUEST_NOTIFICATIONS_COLLECTION,
    DELETE_FRIEND_COLLECTION,
    FRIEND_REQUEST_NOTIFICATIONS_DOCUMENT,
    FRIEND_REQUEST_RESPONSE_DOCUMENT,
    FRIEND_REQUESTS_COLLECTION,
    DELETE_FRIEND_DOCUMENT,
    FRIEND_REQUEST_RESPONSE_COLLECTION,
    CANCELED_FRIEND_REQUESTS_COLLECTION,
    STATISTIC_FRIEND_REQUEST_COLLECTION,
    STATISTIC_FRIEND_REQUEST_RESPONSE_COLLECTION,
    STATISTIC_CANCELED_FRIEND_REQUESTS_COLLECTION,
    FRIEND_REQUEST_USECASE,
    CANCELED_FRIEND_REQUESTS_DOCUMENT,
    DELETE_DEVICE_TOKEN_FROM_SERVER_COLLECTION,
    UPDATE_DEVICE_TOKEN_AT_SEREVER_COLLECTION,
    DELETE_DEVICE_TOKEN_DOCUMENT,
    PRIVATE_USER_DATA_COLLECTION,
    DELETE_USER_COLLECTION,
    UPDATE_DEVICE_TOKEN_DOCUMENT,
    CHATS_DOCUMENT,
    FRIENDS_DOCUMENT,
    UPDATE_NAME_AT_SERVER_COLLECTION,
    UPDATE_NAME_AT_SERVER_DOCUMENT,
    DOCUMENT_TYPE,
    IS_ALREADY_EVALUATED_FROM_SERVER,
    EQUAL,
    ACTIVITIES_COLLECTION,
    ACTIVITY_NOTIFICATION_DOCUMENT,
    NEW_ACTIVITY_NOTIFICATION_DOCUMENT,
    STATISTIC_CREATED_ACTIVITIES_COLLECTION,
    ACTIVITY_INVITATION_USECASE,
    ID,
    CREATOR_ID,
    UPDATE_ACTIVITY_COLLECTION,
    STATISTIC_UPDATE_ACTIVITY_COLLECTION,
    ACTIVITY_REMINDER_USERCASE,
    JOIN_ACTIVITY_COLLECTION,
    STATISTIC_JOIN_ACTIVITY_COLLECTION,
    ATTENDEE_IDS,
    INVITATION_IDS,
    LEAVE_ACTIVITY_COLLECTION,
    STATISTIC_LEAVE_ACTIVITY_COLLECTION,
    DELETE_ACTIVITY_COLLECTION,
    STATISTIC_DELETE_ACTIVITY_COLLECTION,
    FROM_ID,
    TO_ID,
    STARTED_BY,
    UIDS,
    ARRAY_CONTAINS,
    CHAT_ID,
    STATISTIC_SENT_CHAT_REQUESTS_COLLECTION,
    CHAT_NOTIFICATIONS_COLLECTION,
    CHAT_REQUEST_RESPONSE_COLLECTION,
    STATISTIC_CHAT_REQUEST_RESPONSE_COLLECTION,
    CHAT_REQUEST_ACCEPTED,
    CHAT_MESSAGE_USECASE,
    CHATS_COLLECTION,
    FRIENDS_COLLECTION,
    CHAT_REQUEST_USECASE,
    MESSAGES_COLLECTION,
};
