console.log("Executing statistic.js")

const admin = require('firebase-admin');
const db = admin.firestore();
const outputs = require("./outputs");
const contracts = require("./contracts");

/**
 * Moves a document with arbitrary data into the specified Firestore collection.
 *
 * @param {String} collectionName 
 * @param {Object} documentData 
 * 
 */
function moveDocumentInStatisticCollection(collectionName, documentData) {
  db.collection(collectionName).doc().set(documentData)
    .then(response => { outputs.databaseSuccessInformationForDocument(contracts.SET, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
    .catch(error => { outputs.databaseErrorInformationForDocument(contracts.SETTING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Moves and updates an activity document into the Firestore collection.
 * 
 * documentData:
   {
      id: String;
      timestamp: String;
      name: String;
      code: String;
      description: String;
      creatorId: String;
      creatorName: String;
      date: Integer;
      location: Location;
      attendeeIds: List<String>;
      invitationIds: List<String>;
      public: Boolean;
      isAlreadyEvaluatedFromServer: Boolean;
   }
 * 
 * @param {String} collectionName 
 * @param {Object} documentData 
 * @param {Array<String>} updatedInvitationIdsArray 
 * 
 */
function moveUpdateActivityDocumentInStatisticCollection(collectionName, documentData, updatedInvitationIdsArray) {
  db.collection(collectionName).doc().set(
    {
      [contracts.ATTENDEE_IDS]: documentData.attendeeIds,
      [contracts.CODE]: documentData.code,
      [contracts.CREATOR_ID]: documentData.creatorId,
      [contracts.ID]: documentData.id,
      [contracts.NAME]: documentData.name,
      [contracts.INVITATION_IDS]: updatedInvitationIdsArray,
      [contracts.CREATOR_NAME]: documentData.creatorName,
      [contracts.DATE]: documentData.date,
      [contracts.DESCRIPTION]: documentData.description,
      [contracts.LOCATION]: documentData.location,
      [contracts.PUBLIC]: documentData.public,
    }
  )
    .then(response => { outputs.databaseSuccessInformationForDocument(contracts.SET, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
    .catch(error => { outputs.databaseErrorInformationForDocument(contracts.SETTING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Moves a chat request document into the Firestore collection.
 * 
 * documentData:
   {
      chatId: String;
      lastUpdated: String;
      chatRequestAccepted: Boolean;
      startedBy: String;
      uids: List<String>;
      lastMessage: Map<String> {
          message: String
          timestamp: String
          type: String
          userId: String
      };
   }  
 * 
 * @param {String} collectionName 
 * @param {Object} documentData 
 * @param {Boolean} chatRequestAccepted 
 * @param {String} newChatId 
 * 
 */
function moveSentChatRequestDocumentInStatisticCollection(collectionName, documentData, chatRequestAccepted, newChatId) {
  db.collection(collectionName).doc().set(
    {
      uids: [
        documentData.fromId,
        documentData.toId,
      ],
      lastMessage: {
        [contracts.USER_ID]: documentData.fromId,
        [contracts.TIMESTAMP]: documentData.timestamp,
        [contracts.MESSAGE]: documentData.message,
        [contracts.TYPE]: documentData.type,
      },
      [contracts.LAST_UPDATED]: documentData.timestamp,
      [contracts.STARTED_BY]: documentData.fromId,
      [contracts.CHAT_ID]: newChatId,
      [contracts.CHAT_REQUEST_ACCEPTED]: chatRequestAccepted,
    }
  )
    .then(response => { outputs.databaseSuccessInformationForDocument(contracts.SET, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
    .catch(error => { outputs.databaseErrorInformationForDocument(contracts.SETTING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

module.exports = {
  moveDocumentInStatisticCollection,
  moveUpdateActivityDocumentInStatisticCollection,
  moveSentChatRequestDocumentInStatisticCollection
};