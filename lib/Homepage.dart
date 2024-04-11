import 'package:flutter/material.dart';
import 'package:minesweeeper/Bomb.dart';
import 'package:minesweeeper/MyNumberbox.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Variables
  int numberofSquares = 9 * 9;
  int numberInEachRow = 9;
  final List<int> bombLocation = [20, 40, 80, 67, 56];
  late List<List<dynamic>> squareStatus;
  int unrevealedBoxes = 0;

  bool bombRevealed = false;

  @override
  void initState() {
    super.initState();
    squareStatus = List.generate(numberofSquares, (index) => [0, false]);
    scanBombs();
  }

  void restartGame() {
    setState(() {
      bombRevealed = false;
      unrevealedBoxes = numberofSquares;
      for (int i = 0; i < numberofSquares; i++) {
        squareStatus[i][1] = false;
      }
    });
  }

  void revealBoxNumber(int index) {
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
        unrevealedBoxes--;
      });
    } else {
      setState(() {
        squareStatus[index][1] = true;
        unrevealedBoxes--;
      });
      if (index % numberInEachRow != 0) {
        revealBoxNumber(index - 1);
      }
      if (index % numberInEachRow != numberInEachRow - 1) {
        revealBoxNumber(index + 1);
      }
      if (index >= numberInEachRow) {
        revealBoxNumber(index - numberInEachRow);
      }
      if (index < numberofSquares - numberInEachRow) {
        revealBoxNumber(index + numberInEachRow);
      }
    }
    checkWinner(); // Check if the player has won after each box reveal
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Center(child: Text("Congratulations! You Won!")),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                restartGame(); // Call the restart game function
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void checkWinner() {
    // If all non-bomb boxes are revealed, the player wins
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  void playerLost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Center(child: Text("You Lost!")),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                restartGame(); // Call the restart game function
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void scanBombs() {
    for (int i = 0; i < numberofSquares; i++) {
      int numberofBombsAround = 0;

      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberofBombsAround++;
      }
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberofBombsAround++;
      }
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberofBombsAround++;
      }
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberofSquares - numberInEachRow) {
        numberofBombsAround++;
      }

      setState(() {
        squareStatus[i][0] = numberofBombsAround;
      });
    }
    unrevealedBoxes = numberofSquares - bombLocation.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        children: [
          // Game stats and menu
          Container(
            height: 150,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocation.length
                          .toString(), // Assuming this is the number of bombs remaining
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('B.O.M.B'), // Added comma
                  ],
                ),
                // Button to refresh the game
                GestureDetector(
                  onTap: () {
                    restartGame(); // Restart the game when tapped
                  },
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white),
                    color: Colors.grey,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0', // Assuming this is the time taken
                      style: TextStyle(fontSize: 40),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInEachRow,
              ),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return Bomb(
                    number: squareStatus[index][0],
                    reveal: bombRevealed,
                    function: () {
                      setState(() {
                        bombRevealed = true;
                      });
                      // Player tapped on bomb so loses
                      revealBoxNumber(index);
                    },
                  );
                } else {
                  return Number(
                    number: squareStatus[index][0],
                    reveal: squareStatus[index][1],
                    function: () {
                      // Reveal current box
                      revealBoxNumber(index);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text("CREATED BY TURRELL"),
          ),
        ],
      ),
    );
  }
}
