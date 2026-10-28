# Guessing Game

The app thinks of a whole number from 1 to 100. You have seven guesses to find it. After each guess it tells you to go higher or lower, and how close you are: hot, warm or cold, each with its own symbol and colour. A Hint button will tell you whether the number is even or odd, but it costs a guess. The game keeps your fewest-guesses record and tells you when you beat it.

## How to play

1. Open **GuessingGame.xcodeproj** in Xcode, make sure the device menu says **My Mac**, and press **Command-R**.
2. Use **-10**, **-1**, **+1** and **+10** to set your guess, then click **Guess**. A button greys out when it would push the guess outside 1 to 100.
3. Read the message: which way to go, and whether you are hot (within 5), warm (within 15) or cold.
4. Stuck? Click **Hint** to learn whether the number is even or odd. It costs one guess, works once per game, and is not offered when you are down to your last guess.
5. The counter under the buttons shows how many guesses you have left. It turns red at two.
6. When the game ends, click **Play Again**. Games won and your best score carry over.

## What I added

- **Warm and cold hints, with their own symbol and colour.** The distance from the secret number decides the word (Hot! / Warm. / Cold.), the symbol (flame / sun / snowflake) and the colour (orange / yellow / cyan). Exactly 5 away counts as hot.
- **Best score and "New record!"** The fewest guesses in any win is kept across games. The first win starts the record quietly; beating it adds "New record!" to the win message.
- **Running low.** The counter shows guesses *left* instead of guesses used, and turns red at two or fewer. The message symbol bounces on every guess. The four guess buttons grey out when they would take the guess past 1 or 100.
- **Even-or-odd hint.** A Hint button charges one guess and says whether the secret number is even or odd. It can be bought once per game and never with the last guess.

## How it works

<!-- TODO (you, in your own words — the rubric says so and the teacher may ask you to explain it live).
Pick ONE idea. Suggested: the even-or-odd hint, because it touches every tool.
Facts to use:
  constants: hintCost: Int = 1 (top of file) — a constant because the price never changes while the app runs.
  variable:  @State var hintUsed: Bool = false — a variable because it flips to true when bought and back to false in startNewGame().
  decision:  evenOrOdd(_ number: Int) -> String uses number % 2 == 0 — remainder 0 means even — with if / else.
  decision:  canBuyHint() -> Bool returns !hintUsed && guessesLeft() > hintCost — NOT and AND in one line instead of two nested ifs.
  screen:    .disabled(!canBuyHint()) on the Hint button; buyEvenOddHint() changes message, messageSymbol, messageColor and guessCount.
  why a function for canBuyHint: the rule lives in one named place; the button just asks the question.
Write 6–8 sentences. Delete this comment when done. -->

## Design choice

The hint is never offered when only one guess is left. Spending the last guess on "it's even" would end the game without the player ever guessing, which feels like a trap rather than a hint. So `canBuyHint()` requires `guessesLeft() > hintCost`, not `>=`. The same function also handles "already bought", so the button has one question to ask instead of two.

## Testing

The secret number was fixed at **42** while testing (`// FOR TESTING ONLY`), then the random line was put back. The guess starts at 50 in every new game.

| Test | Chosen input | Should happen | Did happen |
|---|---|---|---|
| Hot, high side | guess 45 | "45 is too high. Go lower. Hot!" — flame symbol, orange card | |
| Hot, exactly 5 away (edge) | guess 47 | "Hot!" — distance 5 still counts as hot | |
| Warm begins (other side of the edge) | guess 48 | "Warm." — distance 6, sun symbol, yellow card | |
| Warm, exactly 15 away (edge) | guess 57 | "Warm." — distance 15 is the last warm value | |
| Cold begins (other side of the edge) | guess 58 | "Cold." — distance 16, snowflake symbol, cyan card | |
| Hot, low side | guess 40 | "40 is too low. Go higher. Hot!" — flame symbol | |
| First win | new game, win in 3 guesses | "Yes, friend! 42 is my number." with no "New record!" · Best: 3 guesses | |
| Slower win keeps record | then win in 5 guesses | no "New record!" · Best still 3 guesses | |
| Faster win beats record | then win in 2 guesses | message ends "New record!" · Best: 2 guesses | |
| Counter still grey | 4 wrong guesses | "Guesses left: 3" in grey | |
| Counter turns red (edge) | 5th wrong guess | "Guesses left: 2" in red | |
| Out of guesses | 7 wrong guesses | "Out of guesses! My number was 42." · Play Again appears · guess buttons greyed | |
| +10 greys out | set guess to 95 | +10 greyed, +1 still active | |
| +1 greys out at the top (edge) | set guess to 100 | +1 and +10 greyed | |
| −10 greys out | set guess to 5 | −10 greyed, −1 still active | |
| −1 greys out at the bottom (edge) | set guess to 1 | −1 and −10 greyed | |
| Hint, even | new game, click Hint | "Hint: my number is even. That cost you 1 guess." · bulb, purple · Guesses left: 6 · Hint greyed | |
| Hint, odd | secret fixed at **41**, click Hint | "Hint: my number is odd. …" | |
| Hint allowed with two left (edge) | new game, 5 wrong guesses | Hint still active | |
| Hint refused with one left (other side) | 6th wrong guess | Hint greyed | |
| Hint then run out | new game, Hint, then 6 wrong guesses | "Out of guesses!" on the 6th wrong guess (7 used in total) | |
| Hint comes back | Play Again | Hint active again | |

## Credits

- Starter game: Mr. Gordon, ICS3U.
- Class changes (higher/lower hints, player name, games won, guess limit, `changeGuess(by:)`): from the ICS3U lessons.
- Warm and cold hints, best score and "New record!": Claude (AI, in Obsidian) suggested the code; I reviewed it, ran the tests above, and can explain every line.
- Running-low warning and edge-safe buttons: Claude suggested the code; reviewed and tested by me.
- Even-or-odd hint: Claude suggested the code; reviewed and tested by me.
- README: drafted with Claude. *How it works* and the test results are my own.
- Symbols: SF Symbols (Apple).
