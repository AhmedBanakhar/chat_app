const functions= require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
exports.sendNotificationOnMessage=functions.firestore
.document('chat_rooms/{chatRoomID}/messages{messageId}')
.onCreate(async(snapshot,context)=>{
    const message =snapshot.data();
    try{
        const receiverDoc = await admin.firestore().collection('Users').doc(message.receiverId).get();
        if(!receiverDoc.exists){
            console.log('Receiver does not exist');
            return null;
        }

        const receiverData= receiverDoc.data();
         token = receiverData.fcmToken;

        if(!token){
            console.log('Token does not exist, con not send Notification');
            return null;
        }
        
        //? upload message pay load for 'send' method
        const messagePayLoad = {
            token: token,
            notification: {
                title: 'New Message',
                body: '${message.senderEmail} says: ${message.message}'
            },
            android:{
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            },
            apns: {
                payload: {
                    aps: {
                        category: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                }
            }
        };

        //? send notification
        const response = await admin.messaging().send(messagePayLoad);
        console.log('Notification sent successfully', response);
        return response;

    }catch (e){
        console.log('Error sending notification', e);
        if(e.code && e.message){
            console.log('Error sending notification', e.code);
            console.log('Error sending notification', e.message);

        }
        throw new Error('Failed to send Notification');
    }
})