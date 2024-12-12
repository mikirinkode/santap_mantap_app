
enum DailyReminderType { breakfast, lunch, dinner }

class DailyReminderModel {
  final String title;
  final String body;
  final DailyReminderType type;

  DailyReminderModel({
    required this.title,
    required this.body,
    required this.type,
  });

  static final List<DailyReminderModel> reminders = [
    DailyReminderModel(
      title: 'Sarapan',
      body:
          "Selamat pagi! waktunya isi perutmu agar siap menghadapi aktivitas hari ini..",
      type: DailyReminderType.breakfast,
    ),
    DailyReminderModel(
      title: 'Makan Siang',
      body:
          'Halo sobat SantapMantap, jangan lupa untuk take a break dan isi perutmu ya.',
      type: DailyReminderType.lunch,
    ),
    DailyReminderModel(
      title: 'Makan Malam',
      body:
          'Hai udah waktunya untuk makan nih, pastikan jangan makan terlarut malam ya.',
      type: DailyReminderType.dinner,
    ),
  ];
}