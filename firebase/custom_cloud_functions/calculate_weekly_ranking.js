const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Firestore 초기화
const db = admin.firestore();

// 주간 랭킹을 매주 일요일 오후 6시에 계산하여 Firestore에 저장하는 Cloud Function
exports.calculateWeeklyRanking = functions.pubsub
  .schedule("every sunday	 18:20")
  .onRun(async (context) => {
    // 유저들의 정보를 가져옵니다.
    const usersSnapshot = await db
      .collection("users")
      .where("seatNo", ">", 0)
      .get();

    const weeklyRankings = [];

    // 각 유저의 주간 포인트를 계산합니다.
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();

      // 유저의 포인트 중, 이번 주에 해당하는 것만 필터링
      const weeklyPoints = userData.pointListEach
        .filter((point) => {
          const pointDate = point.getDate.toDate();
          const now = new Date();
          const startOfWeek = new Date(
            now.setDate(now.getDate() - now.getDay()),
          ); // 이번 주 시작 날짜 계산
          return pointDate >= startOfWeek; // 주간 포인트 필터링
        })
        .reduce((acc, point) => acc + point.pointGet, 0); // 주간 포인트 총합 계산

      // 각 유저의 랭킹 정보를 weeklyRankings 배열에 추가
      weeklyRankings.push({
        RankUserName: userData.display_name,
        pointInDuration: weeklyPoints,
        schoolNameRank: userData.school,
        seatNoRank: userData.seatNo,
      });
    });

    // 포인트 기준으로 내림차순 정렬
    weeklyRankings.sort((a, b) => b.pointInDuration - a.pointInDuration);

    // 현재 날짜 (함수 실행 시점) 기록
    const dateMade = new Date();

    // Firestore에 주간 랭킹을 업데이트 (weeklyRankInfo 필드로 저장, 기존 데이터 덮어쓰기)
    await db
      .collection("weeklyRank")
      .doc("e3PvWGjRF1fF4gFTnU8N")
      .set({
        dateMade: admin.firestore.Timestamp.fromDate(dateMade), // 함수 실행 시점 기록
        toggleOnOff: true, // 현재 스키마에 정의된 필드
        weeklyRankInfo: weeklyRankings, // weeklyRankInfo 배열로 랭킹 저장 (기존 데이터 삭제 후 덮어쓰기)
      });

    return null;
  });
