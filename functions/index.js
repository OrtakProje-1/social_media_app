const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.bildirimler = functions.firestore.document("Users/{userUid}/notifications/{notificationId}").onCreate((snap, context) => {
  console.log("---------Bildirim İşlemi Başladı--------------")
  const doc = snap.data();
  const mesaj = doc.nMessage;
  const receiver = doc.nReceiver;
  if (receiver !== null) {
    console.log("receiver != null");
    const receiverToken = receiver.rToken;
    if (receiverToken !== null) {
      console.log("receivertoken = ", receiverToken)
      const payload = {
        notification: {
          title: mesaj,
          body: mesaj,
          badge: '1',
          sound: 'default',
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data:{
          uid:doc.nSender.uid,
          displayName:doc.nSender.displayName,
          photoURL:doc.nSender.photoURL,
          nType:doc.nType,
          recUid:receiver.rUid
        }
      }
      admin.messaging().sendToDevice(receiverToken, payload).then(as => {
        console.log(payload, " kullanıcısına bildirim gönderildi")
      }).catch(hata => {
        console.log("hata oluştu ", hata)
      })
    }
  }
  return "işlem bitti";
});

exports.badwords=functions.firestore.document("Posts/{postId}").onCreate(async(snap,context)=>{

  var myBadWords= require("./my_bad_words.json").myBadWords;
  
  var Filter = require("bad-words"),filter=new Filter();
  myBadWords.forEach((e)=>{
    filter.addWords(String(e));
  });
  const doc=snap.data();
  const mesaj=doc.message;
  console.log("Mesaj= ",mesaj);
  
  if(mesaj!==null||mesaj!==""){
    console.log("Mesaj = ",mesaj);
      const newMesaj=filter.clean(mesaj);
      if(mesaj!==newMesaj){
        console.log("NewMesaj= ",newMesaj);
        doc.message=newMesaj;
        snap.ref.update({
          message:newMesaj,
        });
      }
    
  } 
  return "badwords bitti";

});

exports.messageNotification = functions.firestore.document("Messages/{docId}/messages/{messageId}").onCreate( async(snap,context)=>{
  const doc=snap.data();
  const mesaj=doc.recCryptedText;
  var title=(doc.sender.displayName)+" Kullanıcısı size "+getStringFromType(doc.messageType)+" gönderdi."
  var body;
  if(doc.receiver.rToken!=null){
    if(String(mesaj).length>0){
      console.log("Mesaj= ",mesaj);
      body=mesaj;
    }else{
      body=getStringFromType(doc.messageType);
    }
  
    const payload = {
      notification: {
        title: title,
        body: String(body),
        badge: '1',
        sound: 'default',
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
      data:{
        recUid:String(doc.receiver.rUid),
        uid:String(doc.sender.uid),
        displayName:String(doc.sender.displayName),
        photoURL:String(doc.sender.photoURL),
        nType:String(doc.messageType),
      }
    }
  
    admin.messaging().sendToDevice(doc.receiver.rToken,payload).then(as=>{
      console.log(doc.receiver.rUid, " kullanıcısına bildirim gönderildi");
    }).catch(hata => {
      console.log("hata oluştu= ", hata,"payload= ",payload);
    })
  }

  function getStringFromType(type){
    if(type==0){
      return "Mesaj";
    }else if(type==1){
      return "Ses";
    }else if(type==2){
      return "Resim";
    }else if(type==3){
      return "Video";
    }else if(type==4){
      return "Dosya";
    }
  }
  
});