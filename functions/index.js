const functions = require('firebase-functions'); 
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const ALGOLIA_APP_ID = functions.config().algolia.app;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.key;
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex('users');

exports.onUsersCreated = functions.firestore.document('users/{userId}').onCreate((snap, context) => {
  // Get the note document
  const note = snap.data();

  // Add an 'objectID' field which Algolia requires
  note.objectID = context.params.noteId;

  // Write to the algolia index
  const index = client.initIndex('users');
  return index.saveObject(note);
});



