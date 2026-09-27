enum SkillLevel { beginner, intermediate, advanced, expert }
extension SkillLevelX on SkillLevel {
  String get arabicName {
    switch (this) {
      case SkillLevel.beginner: return 'مبتدئ';
      case SkillLevel.intermediate: return 'متوسط';
      case SkillLevel.advanced: return 'متقدم';
      case SkillLevel.expert: return 'خبير';
    }
  }
}
class FreelancerSkill {
  final String name;
  final SkillLevel level;
  const FreelancerSkill({required this.name, required this.level});
}
