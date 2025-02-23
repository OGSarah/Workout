<div align="center">
  <img src="https://raw.githubusercontent.com/Pearljam66/Workout/805402c2580b8cdea6aec8a7e9722b9676289345/Workout/Workout/Assets.xcassets/AppIcon.appiconset/workout_any.png" width="150" style="border: 3px solid white; border-radius: 15px; vertical-align: middle; margin-right: 20px;">
  <h1 style="display: inline-block; vertical-align: middle;">Workout</h1>
</div>

A simple SwiftUI app that shows a client's workout performance over time.

## Requirements:
- Shows a single client their progress over time for each exercise.
- Data must be glancable, could be in table format but must have an additional format to quickly indicate to the client what their progress is.
- List of exercises.
- Progress will be derived from comparing ExerciseSetSummaries for an Exercise over time, instead of comparing it to the Exercise Set.
- Use the WorkoutsController to load in the WorkoutSummaries.

## Ideation Phase:
<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="40%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/ideation.jpg">
  </div>
</div>

## Screenshots (to be added):

Here are some screenshots showcasing the app's features:

<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/recipelistdarkmode.png">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/recipelistlightmode.png">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/recipedetaildarkmode.png">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/recipedetaillightmode.png">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/searchfunctionality.png">
    <img width="16%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/webview.png">
  </div>
</div>

## Recorded Demo (to be added):

[Watch the Recorded Demo](https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/WorkoutVideo.mov)

## If I had more time I would have:
- Used MVVM architecture for better separate of code and easier testing.
- Used Core Data to save all of the model related data, rather than having to fetch and iterate through the raw json each time.
- Added unit and UI tests.

