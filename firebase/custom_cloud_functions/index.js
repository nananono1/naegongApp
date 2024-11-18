const admin = require("firebase-admin/app");
admin.initializeApp();

const updatePointsOnAdminCheck = require("./update_points_on_admin_check.js");
exports.updatePointsOnAdminCheck =
  updatePointsOnAdminCheck.updatePointsOnAdminCheck;
const calculateWeeklyRanking = require("./calculate_weekly_ranking.js");
exports.calculateWeeklyRanking = calculateWeeklyRanking.calculateWeeklyRanking;
const calculateMonthlyRanking = require("./calculate_monthly_ranking.js");
exports.calculateMonthlyRanking =
  calculateMonthlyRanking.calculateMonthlyRanking;
const sendNotificationOnNewCall = require("./send_notification_on_new_call.js");
exports.sendNotificationOnNewCall =
  sendNotificationOnNewCall.sendNotificationOnNewCall;
