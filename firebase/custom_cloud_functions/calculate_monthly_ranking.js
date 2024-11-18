const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Firestore 초기화
const db = admin.firestore();

// 매월 1일 새벽 2시에 월간 랭킹을 계산하는 Cloud Function
exports.calculateMonthlyRanking = functions.pubsub
  .schedule("0 2 1 * *")
  .onRun(async (context) => {
    // Firestore에서 seatNo가 0보다 큰 유저 데이터를 가져옴
    const usersSnapshot = await db
      .collection("users")
      .where("seatNo", ">", 0)
      .get();

    const monthlyRankings = []; // 월간 랭킹 리스트

    // 현재 날짜 가져오기
    const now = new Date();

    // 지난 달의 시작일과 마지막 날 구하기
    const startOfMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const endOfMonth = new Date(
      now.getFullYear(),
      now.getMonth(),
      0,
      23,
      59,
      59,
    );

    // 각 유저의 월간 포인트를 계산
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();

      // 유저의 포인트 중, 지난 달에 해당하는 것만 필터링
      const monthlyPoints = userData.pointListEach
        .filter((point) => {
          const pointDate = point.getDate.toDate();
          return pointDate >= startOfMonth && pointDate <= endOfMonth; // 월간 포인트 필터링
        })
        .reduce((acc, point) => acc + point.pointGet, 0); // 월간 포인트 총합 계산

      // 각 유저의 랭킹 정보를 monthlyRankings 배열에 추가
      monthlyRankings.push({
        RankUserName: userData.display_name,
        pointInDuration: monthlyPoints,
        schoolNameRank: userData.school,
        seatNoRank: userData.seatNo,
      });
    });

    // 포인트 기준으로 내림차순 정렬
    monthlyRankings.sort((a, b) => b.pointInDuration - a.pointInDuration);

    // 현재 날짜 (함수 실행 시점) 기록
    const dateMade = new Date();

    // Firestore에 월간 랭킹을 업데이트 (monthlyRankInfo 필드로 저장, 기존 데이터 덮어쓰기)
    await db
      .collection("monthlyRank")
      .doc("w2yDNRrmECdjPI5TstDZ")
      .set({
        dateMade: admin.firestore.Timestamp.fromDate(dateMade), // 함수 실행 시점 기록
        toggleOnOff: true, // 스키마 일관성 유지
        monthlyRankInfo: monthlyRankings, // 월간 랭킹 정보를 저장
      });

    return null;
  });
