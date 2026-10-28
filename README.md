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

Idea: Even or odd hint. 
- Player sees the Hint button besides the Guess button.
Clicking the hint button will cost a guess, and the hint will tell if whether the number is even or odd. The hint button is usable only once, and will be grey and uninteractable after the first use 
- For the constant, hintcost: Int = 1 is a constant. This is let: because the hint price never changes.
-  For the variable, @state var hintUsed: Bool = false is a variable. This is var: because it flips to true when it is bought, and it goes back to false when a new game is started. @State is also here because the button greys out and becomes uninteractable once the hint is used. 
- What I decided: hint button is enabled by .disabled(!canBuyHint()), and canBuyHint() returns !hintUsed && guessesLetf() > hintCost so paying would still leave a guess. With the same logic, > should not be >= as one guess left 1 > 1 is false, so that the last guess is not spended on the hint.
- Tool choice: instead of two ifs I fixed the code to && and ! in one line as it reads in one sentence instead of two checks in different places.
- Operator: secretNumber % 2 == 0 inside evenOrOdd(\_:). This way, there are only 2 possibilities; 1 as a remainder and not having a remainder. This is to identify if the number is even or odd. 

## Design choice

The hint is never offered when only one guess is left. Spending the last guess on "it's even" would end the game without the player ever guessing, So `canBuyHint()` requires `guessesLeft() > hintCost`, not `>=`. The same function also handles "already bought", so the button has one question to ask instead of two.

## Testing

The secret number was fixed at **42** while testing (`// FOR TESTING ONLY`), then the random line was put back. The guess starts at 50 in every new game.

All 22 tests were run on 2026-10-28 and every one matched.

| Test | Chosen input | Should happen | Did happen |
|---|---|---|---|
| Hot, high side | guess 45 | "45 is too high. Go lower. Hot!" — flame symbol, orange card | Exactly that: too high, Hot!, flame, orange card |
| Hot, exactly 5 away (edge) | guess 47 | "Hot!" — distance 5 still counts as hot | Hot! — 5 away counts as hot |
| Warm begins (other side of the edge) | guess 48 | "Warm." — distance 6, sun symbol, yellow card | Warm., sun, yellow card |
| Warm, exactly 15 away (edge) | guess 57 | "Warm." — distance 15 is the last warm value | Warm. at 15 away |
| Cold begins (other side of the edge) | guess 58 | "Cold." — distance 16, snowflake symbol, cyan card | Cold., snowflake, cyan card |
| Hot, low side | guess 40 | "40 is too low. Go higher. Hot!" — flame symbol | too low, Go higher, Hot!, flame |
| First win | new game, win in 3 guesses | "Yes, friend! 42 is my number." with no "New record!" · Best: 3 guesses | Win message, no "New record!", Best: 3 guesses |
| Slower win keeps record | then win in 5 guesses | no "New record!" · Best still 3 guesses | No "New record!", Best stayed at 3 guesses |
| Faster win beats record | then win in 2 guesses | message ends "New record!" · Best: 2 guesses | "New record!" shown, Best: 2 guesses |
| Counter still grey | 4 wrong guesses | "Guesses left: 3" in grey | Guesses left: 3, grey |
| Counter turns red (edge) | 5th wrong guess | "Guesses left: 2" in red | Guesses left: 2, red |
| Out of guesses | 7 wrong guesses | "Out of guesses! My number was 42." · Play Again appears · guess buttons greyed | Out of guesses! My number was 42. Play Again shown, ± buttons greyed |
| +10 greys out | set guess to 95 | +10 greyed, +1 still active | +10 greyed, +1 live |
| +1 greys out at the top (edge) | set guess to 100 | +1 and +10 greyed | +1 and +10 greyed |
| −10 greys out | set guess to 5 | −10 greyed, −1 still active | −10 greyed, −1 live |
| −1 greys out at the bottom (edge) | set guess to 1 | −1 and −10 greyed | −1 and −10 greyed |
| Hint, even | new game, click Hint | "Hint: my number is even. That cost you 1 guess." · bulb, purple · Guesses left: 6 · Hint greyed | Hint: my number is even. That cost you 1 guess. Bulb, purple, Guesses left: 6, Hint greyed |
| Hint, odd | secret fixed at **41**, click Hint | "Hint: my number is odd. …" | Hint: my number is odd. |
| Hint allowed with two left (edge) | new game, 5 wrong guesses | Hint still active | Hint live with 2 left |
| Hint refused with one left (other side) | 6th wrong guess | Hint greyed | Hint greyed with 1 left |
| Hint then run out | new game, Hint, then 6 wrong guesses | "Out of guesses!" on the 6th wrong guess (7 used in total) | Out of guesses! on the 6th guess after the hint |
| Hint comes back | Play Again | Hint active again | Hint live again after Play Again |

## Credits

- Starter game: Mr. Gordon, ICS3U.
- Class changes (higher/lower hints, player name, games won, guess limit, `changeGuess(by:)`): from the ICS3U lessons.
- Warm and cold hints, best score and "New record!": Claude (AI, in Obsidian) suggested the code; I reviewed it, ran the tests above, and can explain every line.
- Running-low warning and edge-safe buttons: Claude suggested the code; reviewed and tested by me.
- Even-or-odd hint: Claude suggested the code; reviewed and tested by me.
- README: drafted with Claude. *How it works* and the test results are my own.
- Symbols: SF Symbols (Apple).
