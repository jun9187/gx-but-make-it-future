class GoalProgress {
  const GoalProgress({
    required this.label,
    required this.current,
    required this.target,
  });

  final String label;
  final double current;
  final double target;

  double get progress => target == 0 ? 0 : current / target;
}
