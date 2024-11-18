const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.updatePointsOnAdminCheck = functions.firestore
  .document("users/{userId}/plannerVariableList/{plannerId}")
  .onUpdate((change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if adminChecked was changed from false to true
    if (beforeData.adminChecked === false && afterData.adminChecked === true) {
      const inputList = afterData.inputList;
      let totalStudyMinutes = 0;

      inputList.forEach((item) => {
        // inNaegong이 true인 항목만 처리
        if (item.inNaegong === true) {
          item.studyStartTime.forEach((startTime, index) => {
            const endTime = item.studyEndTime[index];

            // startTime과 endTime을 타임스탬프에서 Date 객체로 변환
            const startDate = startTime ? startTime.toDate() : null;
            const endDate = endTime ? endTime.toDate() : null;

            // 두 시간의 차이를 계산하여 공부 시간을 분 단위로 환산
            if (startDate && endDate) {
              const studyDuration = (endDate - startDate) / (1000 * 60); // 밀리초를 분 단위로 변환
              totalStudyMinutes += studyDuration;
            }
          });
        }
      });

      // 공부한 총 시간을 포인트로 변환하고 반올림 후 정수로 변환 (예: 1분 = 1 포인트)
      const pointsEarned = isNaN(totalStudyMinutes)
        ? 0
        : parseInt(Math.round(Number(totalStudyMinutes)), 10);
      const userId = context.params.userId;
      const teachersQuote = afterData.teachersQuote;
      const submittedDate = afterData.submittedDate;

      // pointListEach 업데이트
      return admin
        .firestore()
        .collection("users")
        .doc(userId)
        .update({
          pointListEach: admin.firestore.FieldValue.arrayUnion({
            pointGet: pointsEarned,
            getDate: admin.firestore.Timestamp.now(),
            reasonWhy: "공부기록",
          }),
          latestTeachersQuote: teachersQuote,
          latestSubmittedDate: submittedDate,
        })
        .then(() => {
          // totalPoint 업데이트 (계산된 포인트 추가)
          return admin
            .firestore()
            .collection("users")
            .doc(userId)
            .update({
              totalPoint: admin.firestore.FieldValue.increment(pointsEarned),
            });
        })
        .then(() => {
          // FCM 토큰을 가져와 푸시 알림 발송
          return admin.firestore().collection("users").doc(userId).get();
        })
        .then((userDoc) => {
          const userData = userDoc.data();
          const fcmToken = userData.fcmToken;

          if (fcmToken) {
            const message = {
              notification: {
                title: "플래너 확인 완료",
                body: `제출하신 플래너가 확인되었습니다. ${pointsEarned}포인트 획득하셨습니다.`,
              },
              token: fcmToken,
              data: {
                latestTeachersQuote: teachersQuote || "",
                latestSubmittedDate: submittedDate
                  ? submittedDate.toDate().toISOString()
                  : "",
              },
            };

            // FCM을 통해 푸시 알림 전송
            return admin.messaging().send(message);
          }

          console.log("FCM 토큰이 없습니다.");
          return null;
        })
        .catch((error) => {
          console.error("오류 발생:", error);
          return null;
        });
    }

    return null;
  });
