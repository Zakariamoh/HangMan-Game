# Hangman

A terminal hangman game written in Racket, in the *Advanced Student* language used in teaching (HtDP).

A secret fruit or vegetable is chosen at random. You propose uppercase letters one at a time until you reveal the word or run out of allowed mistakes.

## How to play

1. Install [Racket](https://racket-lang.org/), which includes DrRacket.
2. Open `main.rkt` in DrRacket and click **Run**.
3. In the interactions window, type:

   ```racket
   (start-game)
   ```

4. Type one **uppercase** letter at each prompt (`A`–`Z`). At the end, answer `Y` to play again.

```text
--- NEW GAME ---
A secret word has been chosen.
Based on word complexity, you have 9 allowed errors.

Word to guess: ------
Errors committed: 0
Propose a letter, letters already proposed: () > A
```

## How it works

- **Adaptive difficulty:** the number of allowed mistakes is 1.5 × the number of distinct letters in the word, kept between 5 and 12.
- **Pure recursion:** the game loop, the sorted list of proposed letters (`insert`) and the string updates (`replace-chars`, `find-indices`) are all written recursively, with no mutation.
- **Input validation:** lowercase letters, symbols and letters already proposed are rejected, and you are asked again.

The file is organised in four sections:

1. letter input and memory
2. string manipulation
3. game logic
4. execution

## Known issues

- Words that contain a hyphen (e.g. `BROAD-BEAN`) can't be won: the hyphen is masked like a letter, but only `A`–`Z` can be proposed.
- A few words appear twice in the list (`CRANBERRY`, `CHESTNUT`, `PUMPKIN`). `TOMATE` and `REDCURRI-SQUASH` are typos.

## License

MIT — see [LICENSE](LICENSE).
