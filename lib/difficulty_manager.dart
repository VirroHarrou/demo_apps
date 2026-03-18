class DifficultyManager {
  final double startSpawnInterval = 1.6;
  final double minSpawnInterval = 0.8;

  final double startShootInterval = 1.2;
  final double minShootInterval = 0.7;

  final double startBalloonSpeed = 150.0;
  final double maxBalloonSpeed = 400.0;

  final int maxDifficultyScore = 40;

  double getSpawnInterval(int score) {
    if (score >= maxDifficultyScore) return minSpawnInterval;
    double progress = score / maxDifficultyScore;
    return startSpawnInterval -
        (startSpawnInterval - minSpawnInterval) * progress;
  }

  double getShootInterval(int score) {
    if (score >= maxDifficultyScore) return minShootInterval;
    double progress = score / maxDifficultyScore;
    return startShootInterval -
        (startShootInterval - minShootInterval) * progress;
  }

  double getBalloonSpeed(int score) {
    if (score >= maxDifficultyScore) return maxBalloonSpeed;
    double progress = score / maxDifficultyScore;
    return startBalloonSpeed + (maxBalloonSpeed - startBalloonSpeed) * progress;
  }
}
