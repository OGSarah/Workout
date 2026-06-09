<div align="center">
  <img src="screenshots/AppIcon.png" width="300" style="border-radius: 22px;" alt="Workout app icon">
  <h1>Workout</h1>
  <p><strong>Track a client's strength, reps, and endurance progress over time — at a glance.</strong></p>
</div>

Workout is a SwiftUI app for iOS 27 that turns a client's raw workout history into clear, glanceable progress. It surfaces each exercise the client has performed, lets a coach set per-exercise goals, and visualises progress toward those goals with circular gauges and time-series charts across multiple time ranges.

## Features

- **Exercise catalogue** — a searchable, alphabetically sorted list of every exercise the client has performed, derived from their workout history.
- **Performance goals** — set weight, reps, and duration goals per exercise. Progress toward each goal is shown with a circular gauge, so a coach can see at a glance how close the client is.
- **Progress charts** — weight, reps, and duration plotted over time, with a dashed goal reference line, across Week / Month / 6 Months / Year ranges.
- **Glanceable empty states** — clear, friendly states when an exercise has no goals set or no data in the selected time range.
- **Liquid Glass UI** — cards and controls use the iOS 27 Liquid Glass material, with full light and dark mode support.
- **Persistent goals** — goals are saved with SwiftData and restored on relaunch.

## Screenshots

| Exercise list | No goals set | Edit goals |
| :---: | :---: | :---: |
| ![Exercise list](screenshots/listview_light.png) | ![No goals set](screenshots/nogoals_light.png) | ![Edit goals](screenshots/editsheet_light.png) |

| Goal gauges | Progress charts | Empty chart state |
| :---: | :---: | :---: |
| ![Goal gauges](screenshots/withgoals_light.png) | ![Progress charts](screenshots/restofscreenwithgoals_light.png) | ![Empty chart state](screenshots/nodatacharts_light.png) |

<details>
<summary>Dark mode</summary>

| Exercise list | No goals set | Edit goals |
| :---: | :---: | :---: |
| ![Exercise list](screenshots/listview_dark.png) | ![No goals set](screenshots/nogoals_dark.png) | ![Edit goals](screenshots/editsheet_dark.png) |

| Goal gauges | Progress charts | Empty chart state |
| :---: | :---: | :---: |
| ![Goal gauges](screenshots/withgoals_dark.png) | ![Progress charts](screenshots/restofscreenwithgoals_dark.png) | ![Empty chart state](screenshots/nodataCharts_dark.png) |

</details>

## Architecture

The app follows MVVM with a clear separation between a concurrency-agnostic domain core and a `@MainActor` UI layer.

| Layer | Responsibility | Key types |
| :--- | :--- | :--- |
| **Models** | `Codable` value types decoded from the workout JSON | `WorkoutSummary`, `ExerciseSetSummary`, `ExerciseSet`, `Exercise` |
| **Domain logic** | Pure, deterministic functions for all progress math | `ExerciseAggregation`, `TimeWindow`, `ChartData`, `GoalProgress` |
| **Data** | Loads workout summaries asynchronously, off the main thread | `WorkoutDataLoading`, `BundleWorkoutLoader`, `WorkoutRepository` |
| **Persistence** | Stores per-exercise goals | `ExerciseGoal` (SwiftData `@Model`), `GoalStore` |
| **View models** | Observable state and presentation logic | `ExerciseListViewModel`, `ExerciseDetailViewModel` |
| **Views** | SwiftUI screens and reusable components | `ExerciseListView`, `ExerciseDetailView`, `ProgressChart`, `GlassCard` |

Design highlights:

- **Testable core.** Aggregation, time-window filtering, chart-series building, and goal math live in pure functions that take the current date as a parameter, so they're fully deterministic and unit-tested without a running app.
- **Off-main loading.** Workout JSON is read and decoded inside a detached task; the UI shows a loading state and never blocks.
- **One chart, not three.** A single reusable `ProgressChart` renders the weight, reps, and duration series, replacing what used to be three near-identical chart files.
- **Swift 6 concurrency.** The app builds in the Swift 6 language mode with complete strict concurrency checking. The domain core is nonisolated; view models, the repository, and the goal store are `@MainActor`.

## Testing

- **Unit tests** ([Swift Testing](https://developer.apple.com/documentation/testing/)) cover JSON decoding, exercise de-duplication and sorting, max-value calculation, goal-progress math, deterministic time-window filtering and axis generation, chart-series building, and SwiftData goal persistence (against an in-memory store).
- **UI test** (XCUIAutomation) launches the app, opens an exercise, adds a goal, and verifies the gauges replace the empty state. The app accepts a `--uitesting` launch argument that keeps goals in memory so each run starts clean.

## License

Released under the [MIT License](LICENSE). © 2026 SarahUniverse
