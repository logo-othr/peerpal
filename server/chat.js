console.log("Executing chat.js")

const admin = require('firebase-admin');
const db = admin.firestore();
const pushNotifications = require("./push_notifications");
const statistic = require("./statistic");
const firebaseFunctions = require("./firebase_functions");
const outputs = require("./outputs");
const contracts = require("./contracts");

const {
  v4: uuidv4,
} = require('uuid');

/**
 * The `chats` variable is a cache map. Each entry contains the following key-value pairs:
 * 
 * <chatId: String>
 * {
 *    fromId: String,
 *    toId: String,
 *    startedBy: String,
 *    chatRequestAccepted: Boolean
 * }
 * 
 */
var chats = new Map();

/**
 * Observes the chatRequestResponse collection in the database. 
 * Triggers on any change detected.
 * Processes the changes, validates the chatId and retrieves chat properties from the cache and updates the chat entry in the database.
 * 
 * chatNotifications document:
 * 
 * <random-id: String>
 * {
 *    chatId: String
 *    message: String
 *    type: String
 *    timestamp: String
 *    fromId: String
 *    toId: String
 * }
 * 
 */
async function chatNotificationObserver() {

  outputs.startObserverInformation(contracts.CHAT_NOTIFICATION_OBSERVER);

  db.collection(contracts.CHAT_NOTIFICATIONS_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === contracts.DOCUMENT_TYPE) {

          var chatNotificationDoc = change.doc;
          var chatNotificationData = chatNotificationDoc.data();

          outputs.userDocumentInformation(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id, change.doc.data());
          var chatIdExists = checkIfChatIdExistsInCache(chatNotificationData.chatId);

          if (chatIdExists == false) {
            validateChatId(change, chatNotificationData, chatNotificationDoc);
          }
          else {
            getChatPropertiesFromCache(chatNotificationData, chatNotificationDoc, change);
          }
        }
      });
    });
}

/**
 * Observes the chatRequestResponse collection in the database. 
 * Triggers on any change detected.
 * Processes responses, moves data to statistics, deletes processed documents, and validates responses.
 * 
 * chatRequestResponse document:
 * 
 * <random-id: String>
 * {
 *    chatId: String
 *    response: String
 *    timestamp: String
 *    fromId: String
 *    toId: String
 * }
 * 
 */
async function chatRequestResponseObserver() {

  outputs.startObserverInformation(contracts.CHAT_REQUEST_RESPONSE_OBSERVER);

  db.collection(contracts.CHAT_REQUEST_RESPONSE_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === contracts.DOCUMENT_TYPE) {

          var chatRequestResponseDoc = change.doc;
          var chatRequestResponseData = chatRequestResponseDoc.data();

          outputs.userDocumentInformation(contracts.CHAT_REQUEST_RESPONSE_COLLECTION, chatRequestResponseDoc.id, chatRequestResponseData);
          statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_CHAT_REQUEST_RESPONSE_COLLECTION, chatRequestResponseData)
          firebaseFunctions.deleteDocument(contracts.CHAT_REQUEST_RESPONSE_COLLECTION, chatRequestResponseDoc.id);
          validateChatRequestResponse(chatRequestResponseData);
        }
      });
    })
}

/**
 * Retrieves chat properties from the cache and updates the chat entry in the database.
 * If the user is a member of the chat, updates the chat in the database and sends notifications.
 * 
 * @param {Object} chatNotificationData
 * @param {Object} chatNotificationDoc
 * @param {Object} change
 */
function getChatPropertiesFromCache(chatNotificationData, chatNotificationDoc, change) {

  var chatIdProperties = chats.get(chatNotificationData.chatId);
  var chatRequestAccepted = chatIdProperties[contracts.CHAT_REQUEST_ACCEPTED];
  var fromId = chatIdProperties[contracts.FROM_ID];
  var toId = chatIdProperties[contracts.TO_ID];

    // Security measure: Only chat members can write messages
    if (fromId == chatNotificationData.fromId || toId == chatNotificationData.fromId) {
    updateExistingChatEntryInDatabase(chatNotificationData.chatId, chatNotificationData, chatNotificationDoc);

    // Notifications are sent only once for a chat request.
    // No new notifications for pending requests.
    if (chatRequestAccepted == true) {
      pushNotifications.pushNotificationHandler(contracts.CHAT_MESSAGE_USECASE, change);
    }
  }
}

/**
 * Validates the chatId and determines if a new chat should be created or if the existing chat should be updated.
 * Searches for the chatId in the cache and database, and processes the chat accordingly.
 * 
 * @param {Object} change 
 * @param {Object} chatNotificationData 
 * @param {Object} chatNotificationDoc 
 * 
 */
function validateChatId(change, chatNotificationData, chatNotificationDoc) {
  var chatIdIsNull = checkIfChatIdIsNull(chatNotificationData.chatId);
  if (chatIdIsNull) {
    var chatId = searchForChatIdInCache(chatNotificationData);
    var chatIdIsNull = checkIfChatIdIsNull(chatId);
    if (chatIdIsNull) {
      var chatExists = checkIfChatExistsInDatabase(change);
      if (!chatExists) {
        setNewChatEntryInDatabase(change, chatNotificationData, chatNotificationDoc);
      }
    }
    else {
      updateExistingChatEntryInDatabase(chatId, chatNotificationData, chatNotificationDoc);
      var chatIdExists = checkIfChatIdExistsInCache(chatId);
      checkIfChatIsChatRequest(chatIdExists, chatId, change);
    }
  }
  if (chatNotificationData.chatId != null) {
    checkIfChatIdExistsInDatabase(chatNotificationData, chatNotificationDoc, change);
  }
}

/**
 * Checks if the chat exists in the database. If the chat does not exist, it returns false.
 * 
 * @param {Object} change 
 * @returns Boolean
 */
function checkIfChatExistsInDatabase(change) {

  var chatNotificationDoc = change.doc;
  var chatNotificationData = chatNotificationDoc.data();

  db.collection(contracts.CHATS_COLLECTION).where(contracts.STARTED_BY, contracts.EQUAL, chatNotificationData.fromId).where(contracts.UIDS, contracts.ARRAY_CONTAINS, chatNotificationData.toId).get()
    .then((documentQuerySnapshot) => {
      if (documentQuerySnapshot.empty) {
        firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
        return false;
      }
      else {
        outputs.forgedChatDocumentInformation();
        firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
        return true;
      }
    }).catch(error => {
      outputs.databaseErrorInformationForDocument(contracts.GETTING, contracts.CHATS_DOCUMENT, arrayName = contracts.DEFAULT_STRING, error)
    });
}

/**
 * Checks if the chatId exists in the database. If it does, the chat is updated and added to the local cache.
 * If the chat does not exist, the chatNotificationDocument is deleted.
 * 
 * @param {Object} chatNotificationData 
 * @param {Object} chatNotificationDoc 
 * @param {Object} change 
 * 
 */
function checkIfChatIdExistsInDatabase(chatNotificationData, chatNotificationDoc, change) {
  db.collection(contracts.CHATS_COLLECTION).where(contracts.CHAT_ID, contracts.EQUAL, chatNotificationData.chatId).get()
    .then((documentQuerySnapshot) => {
      if (documentQuerySnapshot.empty) {
        outputs.forgedChatDocumentInformation();
        firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
        return;
      }
      else {
        documentQuerySnapshot.forEach(doc => {
          var chatDoc = doc;
          var chatData = chatDoc.data();

          setChatDocumentInCache(chatDoc.id, chatNotificationData, chatData.chatRequestAccepted);
          updateExistingChatEntryInDatabase(chatDoc.id, chatNotificationData, chatNotificationDoc);
          pushNotifications.pushNotificationHandler(contracts.CHAT_MESSAGE_USECASE, change);
          firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
        });
      }
    }).catch(error => {
      outputs.databaseErrorInformationForDocument(contracts.GETTING, contracts.CHATS_DOCUMENT, arrayName = contracts.DEFAULT_STRING, error)
    });
}

/**
 * Checks if the chat is a valid chat request. If it is, a push notification is sent.
 * 
 * @param {Boolean} chatIdExists 
 * @param {String} chatId 
 * @param {Object} change 
 * 
 */
function checkIfChatIsChatRequest(chatIdExists, chatId, change) {
  if (chatIdExists) {
    var chatIdProperties = getChatProperties(chatId);
    var chatRequestAccepted = chatIdProperties[contracts.CHAT_REQUEST_ACCEPTED];
    if (chatRequestAccepted == true) {
      pushNotifications.pushNotificationHandler(contracts.CHAT_MESSAGE_USECASE, change);
    }
  }
}

/**
 * Gets the properties of a chat from the cache.
 * 
 * @param {String} chatId 
 * @returns Boolean
 * 
 */
function getChatProperties(chatId) {
  var chatProperties = chats.get(chatId);
  return chatProperties;
}

/**
 * Checks if the chatId is null.
 * 
 * @param {String} chatId 
 * @returns Boolean
 * 
 */
function checkIfChatIdIsNull(chatId) {
  if (chatId == null) {
    return true;
  }
  else {
    return false;
  }
}

/**
 * Checks if the chatId exists in the cache.
 * 
 * @param {String} chatId 
 * @returns Boolean
 * 
 */
function checkIfChatIdExistsInCache(chatId) {
  if (chats.has(chatId)) {
    return true;
  }
  else {
    return false;
  }
}

/**
 * Checks if the chat already exists in the cache to prevent creating duplicate chats.
 * This method handles cases where a user sends a message before the chat is loaded or 
 * when an attacker sends a null chatId. It searches for an existing chatId in the cache 
 * based on chatNotificationData and returns the chatId if found; otherwise, it returns null.
 * 
 * @param {Object} chatNotificationData 
 * @returns String
 * 
 */
function searchForChatIdInCache(chatNotificationData) {

  var breakForEach = false;

  chats.forEach((ids, existingChatId) => {
    if (breakForEach) {
      outputs.noChatExistsInformation();
      return;
    }
    if (ids[contracts.FROM_ID] == chatNotificationData.fromId && ids[contracts.TO_ID] == chatNotificationData.toId) {
      chatNotificationData.chatId = existingChatId;
      breakForEach = true;
    }
  });
  return chatNotificationData.chatId;
}

/**
 * Creates a new chat entry in the database. If the users are friends, the chatRequestAccepted is set to true.
 * Otherwise, it is set to false. Updates the cache and triggers a notification.
 * 
 * @param {Object} change 
 * @param {Object} chatNotificationData 
 * @param {Object} chatNotificationDoc 
 * 
 */
function setNewChatEntryInDatabase(change, chatNotificationData, chatNotificationDoc) {

  var newChatId = uuidv4();

  db.collection(contracts.FRIENDS_COLLECTION).where(contracts.FROM_ID, contracts.EQUAL, chatNotificationData.fromId).where(contracts.TO_ID, contracts.EQUAL, chatNotificationData.toId).get()
    .then((documentQuerySnapshot) => {
      if (documentQuerySnapshot.empty) {
        var chatRequestAccepted = false;
        setChatDocumentInCache(newChatId, chatNotificationData, chatRequestAccepted);
        pushNotifications.pushNotificationHandler(contracts.CHAT_REQUEST_USECASE, change);
        createChatCollectionInDatabase(newChatId, chatNotificationData, chatNotificationDoc, chatRequestAccepted);
        return;
      }
      else {
        var chatRequestAccepted = true;
        setChatDocumentInCache(newChatId, chatNotificationData, chatRequestAccepted);
        pushNotifications.pushNotificationHandler(contracts.CHAT_MESSAGE_USECASE, change);
        createChatCollectionInDatabase(newChatId, chatNotificationData, chatNotificationDoc, chatRequestAccepted);
      }
    }).catch(error => {
      outputs.databaseErrorInformationForDocument(contracts.GETTING, contracts.FRIENDS_DOCUMENT, arrayName = contracts.DEFAULT_STRING, error)
    })
}

/**
 * Adds a chat document to the cache.
 * 
 * @param {String} chatId 
 * @param {Object} chatData 
 * @param {Boolean} chatRequestAccepted 
 * 
 */
function setChatDocumentInCache(chatId, chatData, chatRequestAccepted) {
  chats.set(chatId,
    {
      [contracts.FROM_ID]: chatData.fromId,
      [contracts.TO_ID]: chatData.toId,
      [contracts.STARTED_BY]: chatData.fromId,
      [contracts.CHAT_REQUEST_ACCEPTED]: chatRequestAccepted
    }
  );
}

/**
 * Creates a chat collection in the database with the specified newChatId.
 * Also creates a corresponding message entry and updates the statistics.
 * 
 * @param {String} newChatId 
 * @param {Object} chatNotificationData 
 * @param {Object} chatNotificationDoc 
 * @param {Boolean} chatRequestAccepted 
 * 
 */
function createChatCollectionInDatabase(newChatId, chatNotificationData, chatNotificationDoc, chatRequestAccepted) {
  firebaseFunctions.setDocumentWithSpecificId(contracts.CHATS_COLLECTION, newChatId,
    {
      uids: [
        chatNotificationData.fromId,
        chatNotificationData.toId,
      ],
      lastMessage: {
        [contracts.USER_ID]: chatNotificationData.fromId,
        [contracts.TIMESTAMP]: chatNotificationData.timestamp,
        [contracts.MESSAGE]: chatNotificationData.message,
        [contracts.TYPE]: chatNotificationData.type,
      },
      [contracts.LAST_UPDATED]: chatNotificationData.timestamp,
      [contracts.STARTED_BY]: chatNotificationData.fromId,
      [contracts.CHAT_ID]: newChatId,
      [contracts.CHAT_REQUEST_ACCEPTED]: chatRequestAccepted,
    }
  );

  firebaseFunctions.setDocumentWithSpecificId(`/${contracts.CHATS_COLLECTION}/${newChatId}/${contracts.MESSAGES_COLLECTION}`, chatNotificationDoc.id,
    {
      [contracts.USER_ID]: chatNotificationData.fromId,
      [contracts.TIMESTAMP]: chatNotificationData.timestamp,
      [contracts.MESSAGE]: chatNotificationData.message,
      [contracts.TYPE]: chatNotificationData.type,
      uids: [
        chatNotificationData.fromId,
        chatNotificationData.toId,
      ],
    }
  );
  statistic.moveSentChatRequestDocumentInStatisticCollection(contracts.STATISTIC_SENT_CHAT_REQUESTS_COLLECTION, chatNotificationData, chatRequestAccepted, newChatId)
  firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
}

/**
 * Updates an existing chat entry in the database with the specified chatId.
 * Also updates the last message information in the chat collection and creates a message entry.
 * 
 * @param {String} chatId 
 * @param {Object} chatNotificationData 
 * @param {Object} chatNotificationDoc 
 * 
 */
function updateExistingChatEntryInDatabase(chatId, chatNotificationData, chatNotificationDoc) {
  firebaseFunctions.updateDocumentWithSpecificId(contracts.CHATS_COLLECTION, chatId,
    {
      lastMessage: {
        [contracts.USER_ID]: chatNotificationData.fromId,
        [contracts.TIMESTAMP]: chatNotificationData.timestamp,
        [contracts.MESSAGE]: chatNotificationData.message,
        [contracts.TYPE]: chatNotificationData.type,
      },
      [contracts.LAST_UPDATED]: chatNotificationData.timestamp,
    }
  );

  firebaseFunctions.setDocumentWithSpecificId(`/${contracts.CHATS_COLLECTION}/${chatId}/${contracts.MESSAGES_COLLECTION}`, chatNotificationDoc.id,
    {
      [contracts.USER_ID]: chatNotificationData.fromId,
      [contracts.TIMESTAMP]: chatNotificationData.timestamp,
      [contracts.MESSAGE]: chatNotificationData.message,
      [contracts.TYPE]: chatNotificationData.type,
      uids: [
        chatNotificationData.fromId,
        chatNotificationData.toId,
      ],
    }
  );
  firebaseFunctions.deleteDocument(contracts.CHAT_NOTIFICATIONS_COLLECTION, chatNotificationDoc.id);
}

/**
 * Validates the chat request response and updates the chatRequestAccepted variable in both the chat cache and the database.
 * Retrieves the chat from the database if not found in the cache and updates the chat accordingly.
 * 
 * @param {Object} chatRequestResponseDocData 
 * 
 */
function validateChatRequestResponse(chatRequestResponseDocData) {

  if (chatRequestResponseDocData.response) {
    var incomingChatId = chatRequestResponseDocData.chatId;
    var chatIdExists = checkIfChatIdExistsInCache(incomingChatId);
    if (chatIdExists) {
      var chatIdProperties = getChatIdProperties(incomingChatId);
      var chatPropertiesExistsInCache = checkIfChatPropertiesExistsInCache(chatIdProperties, chatRequestResponseDocData);
      if (chatPropertiesExistsInCache) {
        var chatId = chatRequestResponseDocData.chatId;
        updateChatRequestAcceptedInDatabase(chatId);
        updateChatRequestAcceptedInCache(chatId);
      }
    }
    else {
      getChatFromDatabase(chatRequestResponseDocData);
    }
  }
  else {
    deleteMessageRequest(chatRequestResponseDocData.chatId);
  }
}

/**
 * Retrieves a chat from the database and updates the chatRequestAccepted variable.
 * If the chat exists, sets the chat document in the cache.
 * 
 * @param {Object} chatRequestResponseData 
 * 
 */
function getChatFromDatabase(chatRequestResponseData) {
  db.collection(contracts.CHATS_COLLECTION).where(contracts.UIDS, contracts.ARRAY_CONTAINS, chatRequestResponseData.fromId).where(contracts.STARTED_BY, contracts.EQUAL, chatRequestResponseData.toId).get()
    .then((documentQuerySnapshot) => {
      if (documentQuerySnapshot.empty) {
        outputs.forgedChatDocumentInformation();
        return;
      }
      else {
        updateChatRequestAcceptedInDatabase(chatRequestResponseData.chatId);
        setChatDocumentInCache(chatRequestResponseData.chatId, chatRequestResponseData, true);
      }
    })
}

/**
 * Updates the chatRequestAccepted variable in the cache.
 * Ensures that the chatId exists in the cache before updating.
 * 
 * @param {String} chatId 
 * 
 */
function updateChatRequestAcceptedInCache(chatId) {

  var chatIdExists = checkIfChatIdExistsInCache(chatId);
  if (chatIdExists) {
    var chatIdProperties = chats.get(chatId);
    chatIdProperties[contracts.CHAT_REQUEST_ACCEPTED] = true;
    chats.set(chatId, chatIdProperties);
  }
}

/**
 * Updates the chatRequestAccepted variable in the database.
 * Sets the chatRequestAccepted field to true for the specified chatId.
 * 
 * @param {String} chatId 
 * 
 */
function updateChatRequestAcceptedInDatabase(chatId) {
  firebaseFunctions.updateDocumentWithSpecificId(contracts.CHATS_COLLECTION, chatId,
    {
      [contracts.CHAT_REQUEST_ACCEPTED]: true,
    }
  );
}

/**
 * Checks if the chat properties exist in the cache based on the chat request response data.
 * Validates if the chat request originated from the correct users.
 * 
 * @param {Object} chatIdProperties 
 * @param {Object} chatRequestResponseDocData 
 * @returns Boolean
 * 
 */
function checkIfChatPropertiesExistsInCache(chatIdProperties, chatRequestResponseDocData) {
  if (chatIdProperties[contracts.STARTED_BY] == chatRequestResponseDocData.toId && chatIdProperties[contracts.FROM_ID] == chatRequestResponseDocData.fromId
    || chatIdProperties[contracts.STARTED_BY] == chatRequestResponseDocData.toId && chatIdProperties[contracts.TO_ID] == chatRequestResponseDocData.fromId) {
    return true;
  } else {
    return false;
  }
}

/**
 * Retrieves the properties of a chatId from the cache.
 *
 * @param {String} chatId 
 * @returns Object
 * 
 */
function getChatIdProperties(chatId) {
  var chatIdProperties = chats.get(chatId);
  return chatIdProperties;
}

/**
 * Deletes the message request associated with a chatId.
 * Removes the message collection and the chat document from the database.
 * 
 * @param {String} chatId
 * 
 */
function deleteMessageRequest(chatId) {
  var killrequest_query = db.collection(contracts.CHATS_COLLECTION).doc(chatId);
  outputs.databaseSuccessInformationForCollection(contracts.DELETE, killrequest_query.collection(contracts.MESSAGES_COLLECTION).path, response = null);
  deleteCollection(killrequest_query.collection(contracts.MESSAGES_COLLECTION).path)
  firebaseFunctions.deleteDocument(contracts.CHATS_COLLECTION, chatId);
  deleteChatIdInLocalMap(chatId);
}

/**
 * Deletes a chatId from the local cache.
 * 
 * @param {String} chatId 
 * 
 */
function deleteChatIdInLocalMap(chatId) {
  chats.delete(chatId);
}

/**
 * Deletes a collection from the database.
 * Iterates through documents in the collection and deletes them.
 * 
 * @param {String} path
 *  
 */
function deleteCollection(path) {
  db.collection(path).listDocuments().then(val => {
    val.map((val) => {
      val.delete()
    })
  }).then(response => { outputs.databaseSuccessInformationForCollection(contracts.DELETE, collectionPath = null, response) })
    .catch(error => { outputs.databaseErrorInformationForCollection(contracts.DELETING, error) });
}

module.exports = {
  chatRequestResponseObserver,
  chatNotificationObserver,
};
