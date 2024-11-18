const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code
// Firebase Functions 라이브러리 호출

// Database Trigger 설정: `calls/{spot}/{docs}` 경로에 새로운 문서 추가 시 작동
exports.sendNotificationOnNewCall = functions.database
  .ref("/calls/{spot}/{docId}")
  .onCreate(async (snapshot, context) => {
    const spot = context.params.spot; // spot 이름
    const docId = context.params.docId; // 새로 추가된 문서 ID
    const callData = snapshot.val(); // 새로 추가된 데이터 가져오기

    try {
      // `fcmtokens` 경로에서 해당 spot의 토큰 가져오기
      const fcmTokenSnapshot = await admin
        .database()
        .ref(`/calls/${spot}/fcmtokens`)
        .once("value");
      const fcmToken = fcmTokenSnapshot.val(); // fcmtokens 값 가져오기

      if (!fcmToken) {
        console.log(`FCM 토큰이 ${spot}에 설정되어 있지 않습니다.`);
        return;
      }

      // 알림 제목과 메시지 설정
      const payload = {
        notification: {
          title: "call", // 제목을 "call"로 고정
          body: `${callData.seatno} - ${callData.callreason}`, // body를 "seatno - callreason" 형식으로 설정
          sound: "default", // 기본 소리 설정
        },
        data: {
          spot: spot,
          docId: docId,
          ...callData, // 추가적으로 전달할 데이터
        },
      };

      // FCM 토큰으로 알림 전송
      await admin.messaging().sendToDevice(fcmToken, payload);
      console.log(`FCM 알림 전송 성공: ${spot}/${docId}`);
    } catch (error) {
      console.error("FCM 알림 전송 실패:", error);
    }
  });
