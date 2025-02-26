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

## Notes:
- I updated the data so that it was more recent since in a real world situation most exercise data would be within the past year.

## Ideation Phase:
<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="40%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/ideation.jpg">
  </div>
</div>

## Screenshots:

Here are some screenshots showcasing the app's features:

<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/listview_dark.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/listview_light.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/nogoals_dark.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/nogoals_light.png">
  </div>
</div>

<br><br> 

<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/editsheet_dark.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/editsheet_light.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/nodataCharts_dark.png">
    `<img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/nodatacharts_light.png">
  </div>
</div>

<br><br>

<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/withgoals_dark.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/withgoals_light.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/restofscreenwithgoals_dark.png">
    <img width="20%" src="https://raw.githubusercontent.com/Pearljam66/Workout/main/screenshots/restofscreenwithgoals_light.png">    
  </div>
</div>

## If I had more time I would have:

- Used MVVM architecture for better separation of code and easier testing.
- Used Core Data to save all of the model-related data and goals, rather than having to fetch and iterate through the raw JSON each time and rely on AppStorage for saving goals.
- Added unit and UI tests.
- Refactored the code so there isn’t duplicate functionality throughout the chart code.
- Fixed the runtime Swift Charts warning.
- Fixed some minor UI bugs (for example: the GoalGaugeSection not stretching across the screen properly in landscape mode and values on charts being slightly to the left).
- Added a description for each exercise on the ExerciseDetails screen since some of the lesser known exercises aren't as obvious as to what they are.
- Added better preview data code, perhaps using more realistic data similar to the json data provided.

