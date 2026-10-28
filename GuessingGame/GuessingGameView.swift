//
//  GuessingGameView.swift
//  GuessingGame
//
//  WHAT THIS GAME DOES NOW
//  The app picks a secret whole number from 1 to 100.
//  You choose a guess with the buttons and click Guess.
//  The app tells you if your guess is too low, too high, or right,
//  and how close you are: hot, warm or cold, each with its own symbol and colour.
//  It counts your guesses and ends the game after seven misses.
//  When you find the number, you can play again. The fewest guesses you have
//  ever needed is kept as your best score, and the game says so when you beat it.
//

import SwiftUI

// The game's settings. They sit up here, outside the game,
// so that every part of the game below can use them.
let lowestNumber: Int = 1
let highestNumber: Int = 100

// The name the game uses to greet the player. It never changes while the game runs.
let playerName: String = "friend"

// How many guesses the player gets before the game is over.
let maximumGuesses: Int = 7

// How close a guess must be to count as hot, and as warm.
// Named here so the same numbers are not typed again in each function that needs them.
let hotDistance: Int = 5
let warmDistance: Int = 15

// The game itself: what it remembers, what it shows on the screen,
// and what it does when you click a button.
struct GuessingGameView: View {

    // MARK: - Stored properties

    // Each @State variable is something the game remembers.
    // When one of them changes, the screen updates by itself.

    // The number the player is trying to find. The app picks it at random.
    @State var secretNumber: Int = Int.random(in: lowestNumber...highestNumber)

    // The guess the player is about to make. It starts in the middle.
    @State var guess: Int = (lowestNumber + highestNumber) / 2

    // How many guesses the player has made in this game.
    @State var guessCount: Int = 0

    // How many games the player has won since the app opened.
    // A new game does not reset this, because it counts across games.
    @State var gamesWon: Int = 0

    // The message shown to the player, with a symbol and a colour to match it.
    @State var message: String = "I'm thinking of a number from \(lowestNumber) to \(highestNumber)."
    @State var messageSymbol: String = "questionmark.circle.fill"
    @State var messageColor: Color = Color.indigo

    // Becomes true when the player finds the secret number or runs out of guesses.
    @State var gameIsOver: Bool = false

    // The fewest guesses the player has ever needed to win. 0 means no win yet.
    // Like gamesWon, a new game does not reset this.
    @State var bestScore: Int = 0

    // MARK: - Computed properties

    var body: some View {
        VStack(spacing: 20) {

            // The title at the top of the screen.
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                Text("Guessing Game")
            }
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color.indigo)
            // Shrink the title a little if it does not fit on one line.
            .lineLimit(1)
            .minimumScaleFactor(0.5)

            Spacer()

            // The message card: what the game has to say to you.
            VStack(spacing: 12) {
                Image(systemName: messageSymbol)
                    .font(.system(size: 60))
                    .foregroundStyle(messageColor)
                Text(message)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(messageColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Spacer()

            // The guess you are about to make, shown nice and big.
            Text("\(guess)")
                .font(.system(size: 96, weight: .bold))
                .monospacedDigit()

            // Four buttons to change the guess.
            // Each one calls the same function with a different amount.
            HStack(spacing: 8) {
                Button("-10") {
                    changeGuess(by: -10)
                }
                Button("-1") {
                    changeGuess(by: -1)
                }
                Button("+1") {
                    changeGuess(by: 1)
                }
                Button("+10") {
                    changeGuess(by: 10)
                }
            }
            .buttonStyle(.bordered)
            .font(.title3)
            .bold()
            .monospacedDigit()
            .disabled(gameIsOver)

            // Show the Guess button while the game is on,
            // and the Play Again button once the game is over.
            if gameIsOver {
                Button("Play Again", systemImage: "arrow.clockwise") {
                    startNewGame()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
            } else {
                Button("Guess", systemImage: "hand.point.up.left.fill") {
                    checkGuess()
                }
                .buttonStyle(.borderedProminent)
            }

            Text("Guesses: \(guessCount) of \(maximumGuesses)    Games won: \(gamesWon)")
                .font(.headline)
                .foregroundStyle(Color.secondary)

            // The best score only means something once there has been a win.
            Text("Best: \(bestScoreText())")
                .font(.headline)
                .foregroundStyle(Color.secondary)
        }
        .padding(32)
        .font(.title2)
        .fontDesign(.rounded)
        .controlSize(.large)
        .tint(Color.indigo)
        // How big the game's window is on the Mac. It can be made taller or wider.
        .frame(minWidth: 420, minHeight: 640)
    }

    // MARK: - Functions

    // Checks the player's guess against the secret number
    // and tells the player which way to go, and how close they are.
    func checkGuess() {

        // One more guess has been made.
        guessCount += 1

        // How far the guess is from the secret number, as a positive number.
        // It is worked out once per guess and never changes after, so it is a constant.
        let distance: Int = distanceBetween(guess, and: secretNumber)

        if guess == secretNumber {
            message = "Yes, \(playerName)! \(secretNumber) is my number."
            messageSymbol = "star.circle.fill"
            messageColor = Color.green
            gamesWon += 1
            gameIsOver = true
            recordBestScore()
        } else if guess < secretNumber {
            message = "\(guess) is too low. Go higher. \(temperatureHint(distance: distance))"
        } else {
            message = "\(guess) is too high. Go lower. \(temperatureHint(distance: distance))"
        }

        // A wrong guess gets its symbol and colour from how close it is, not from which
        // way to go, so both wrong branches above share these two lines instead of repeating them.
        if guess != secretNumber {
            messageSymbol = temperatureSymbol(distance: distance)
            messageColor = temperatureColor(distance: distance)
        }

        // Out of guesses, and still not right? Then the game is over.
        if guess != secretNumber && guessCount >= maximumGuesses {
            message = "Out of guesses! My number was \(secretNumber)."
            messageSymbol = "xmark.octagon.fill"
            messageColor = Color.gray
            gameIsOver = true
        }
    }

    // Keeps the fewest guesses ever needed to win, and says so when the record is beaten.
    // The first win starts the record quietly, because there was nothing to beat yet.
    func recordBestScore() {
        if bestScore == 0 {
            bestScore = guessCount
        } else if guessCount < bestScore {
            bestScore = guessCount
            message += " New record!"
        }
    }

    // Hands back how far apart two numbers are, always as a positive number.
    func distanceBetween(_ firstNumber: Int, and secondNumber: Int) -> Int {
        if firstNumber > secondNumber {
            return firstNumber - secondNumber
        } else {
            return secondNumber - firstNumber
        }
    }

    // Hands back a one-word hint based on how far the guess is from the secret number.
    // Hot is checked first on purpose: a distance of 3 is also within warmDistance,
    // and Swift stops at the first condition that is true.
    func temperatureHint(distance: Int) -> String {
        if distance <= hotDistance {
            return "Hot!"
        } else if distance <= warmDistance {
            return "Warm."
        } else {
            return "Cold."
        }
    }

    // Hands back the symbol that matches the hint. Same checks, in the same order,
    // as temperatureHint, so the word and the picture can never disagree.
    func temperatureSymbol(distance: Int) -> String {
        if distance <= hotDistance {
            return "flame.fill"
        } else if distance <= warmDistance {
            return "sun.max.fill"
        } else {
            return "snowflake"
        }
    }

    // Hands back the colour that matches the hint, in the same order again.
    func temperatureColor(distance: Int) -> Color {
        if distance <= hotDistance {
            return Color.orange
        } else if distance <= warmDistance {
            return Color.yellow
        } else {
            return Color.cyan
        }
    }

    // Hands back the best score as text, or a dash when there is no win yet.
    func bestScoreText() -> String {
        if bestScore == 0 {
            return "—"
        } else {
            return "\(bestScore) guesses"
        }
    }

    // Changes the guess by the amount given, but keeps it inside the range.
    // A negative amount makes the guess smaller.
    func changeGuess(by amount: Int) {
        guess += amount
        if guess < lowestNumber {
            guess = lowestNumber
        }
        if guess > highestNumber {
            guess = highestNumber
        }
    }

    // Picks a new secret number and resets everything that belongs to one game.
    // gamesWon and bestScore are not reset, because they count across games.
    func startNewGame() {
        secretNumber = Int.random(in: lowestNumber...highestNumber)
        guess = (lowestNumber + highestNumber) / 2
        guessCount = 0
        message = "I'm thinking of a new number from \(lowestNumber) to \(highestNumber)."
        messageSymbol = "questionmark.circle.fill"
        messageColor = Color.indigo
        gameIsOver = false
    }
}

#Preview {
    GuessingGameView()
}
