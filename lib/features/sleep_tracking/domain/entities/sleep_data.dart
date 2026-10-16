// Sleep entry and goal for one day.
class SleepData {
  final String date;
  final DateTime? bedtime;
  final DateTime? wakeUpTime;
  final double duration; // in hours
  final double goalHours; // in hours

  const SleepData({
    required this.date,
    this.bedtime,
    this.wakeUpTime,
    required this.duration,
    required this.goalHours,
  });
}
