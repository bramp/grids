# Analytics

The game uses Firebase Analytics to capture gameplay events. All analytics calls are fire-and-forget (unawaited) and are only sent when Firebase is initialized (`Firebase.apps.isNotEmpty`) **and** the user has given consent via the in-app consent banner. Errors are caught and logged to `debugPrint` without affecting gameplay.

## Consent

On first launch a banner explains that:

- **Local storage** (game saves, unlocks) is strictly necessary and always active.
- **Analytics** is optional and requires explicit opt-in.

The user's choice is persisted in `SharedPreferences` (`analytics_consent` key) and applied to `FirebaseAnalytics.setAnalyticsCollectionEnabled`. Analytics events in `LevelProvider` are gated on `ConsentService.analyticsAllowed`.

See [lib/services/consent_service.dart](../lib/services/consent_service.dart) and [lib/ui/widgets/consent_banner.dart](../lib/ui/widgets/consent_banner.dart).

## Events

### `level_solve_attempt`

Fired every time the player taps **Check Answer**, regardless of outcome.

| Parameter        | Type    | Description                                      |
|------------------|---------|--------------------------------------------------|
| `level_id`       | String  | Unique identifier of the level                   |
| `is_correct`     | int     | `1` if the answer is correct, `0` otherwise      |
| `attempt_number` | int     | Number of attempts made on this level (1-based)   |
| `time_ms`        | int     | Milliseconds elapsed since the level was loaded   |

### `level_complete`

Fired when a player successfully solves a level (correct answer + timing data available).

| Parameter        | Type   | Description                                          |
|------------------|--------|------------------------------------------------------|
| `level_id`       | String | Unique identifier of the level                       |
| `time_ms`        | int    | Milliseconds elapsed since the level was loaded       |
| `attempt_number` | int    | Total number of Check Answer attempts before solving  |

## Implementation

All analytics logic lives in `LevelProvider.checkAnswer()` in [lib/providers/level_provider.dart](../lib/providers/level_provider.dart). The solve timer starts when a level is loaded (`_levelStartTime`) and the attempt counter resets each time a new level is loaded.
