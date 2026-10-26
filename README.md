# Guessing Game

<!-- TODO (you): 2–3 sentences. What the game does now: secret number 1–100, higher/lower hints, 7 guesses, games won. -->

## How to play

1. Open **GuessingGame.xcodeproj** in Xcode, make sure the device menu says **My Mac**, and press **Command-R**.
2. Use **-10**, **-1**, **+1** and **+10** to set your guess, then click **Guess**.
3. The game tells you whether to go higher or lower, and how close you are. You have 7 guesses.
4. When the game ends, click **Play Again**.

## What I added

<!-- TODO (you): one line per idea, in your own words. Example shape: -->
- **Warm / cold hints:** …
- **Best score:** …

## How it works

<!-- TODO (you): explain ONE idea so a classmate could rebuild it. Name the variables and their types, and say why the Hot check comes before the Warm check. -->

## Testing

The secret number was fixed at **42** while testing (`// FOR TESTING ONLY`), then the random line was put back.

| Test | Chosen input | Should happen | Did happen |
|---|---|---|---|
| Hot hint | guess 45 | "too high… Hot!" — distance 3 is within 5 | |
| Warm hint, edge | guess 57 | "too high… Warm" — distance 15 is the last warm value | |
| Cold hint, edge | guess 58 | "too high… Cold" — distance 16 is just past warm | |
| Hot hint, low side | guess 40 | "too low… Hot!" — works below the secret too | |
| Best score, first win | win in 3 guesses | Best shows 3 | |
| Best score only improves | then win in 5 | Best still shows 3 | |
| Best score improves | then win in 2 | Best shows 2 | |
| Out of guesses | 7 wrong guesses | "Out of guesses! My number was 42." and Play Again appears | |

## Credits

- Starter game: Mr. Gordon, ICS3U
- Class changes (higher/lower hints, player name, games won, guess limit, `changeGuess(by:)`): from the ICS3U lessons.
- <!-- TODO (you), when true: --> Warm/cold hints and best score: Claude (AI, in Obsidian) suggested the lines; I checked them, typed them in, and tested them.
