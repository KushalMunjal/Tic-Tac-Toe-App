import 'package:flutter/material.dart';
import '/model/color.dart';
import '/model/game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void updatePlayerPoints(String lastValue) {
    setState(() {
      if (lastValue == Player.x) {
        player1Points++;
      } else {
        player2Points++;
      }
    });
  }

  String lastValue = Player.x;
  bool gameOver = false;
  int turn = 0;
  String result = "";
  int player1Points = 0;
  int player2Points = 0;
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  Game game = Game();
  //let's initi the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tic Tac Toe",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Player 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      player1Points.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Player 2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      player2Points.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            //now we will make the game board
            //but first we will create a Game class that will contains all the data and method that we will need
            Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardLength ~/
                    3, // the ~/ operator allows you to evide to integer and return an Int as a result
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardLength, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            //when we click we need to add the new value to the board and refrech the screen
                            //we need also to toggle the player
                            //now we need to apply the click only if the field is empty
                            //now let's create a button to repeat the game

                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);

                                if (gameOver) {
                                  if (lastValue == Player.x) {
                                    result = "Player 1 is the Winner";
                                  } else {
                                    result = "Player 2 is the Winner";
                                  }
                                  updatePlayerPoints(
                                      lastValue); // Call the method to update points
                                }
                                if (lastValue == "X")
                                  lastValue = "O";
                                else
                                  lastValue = "X";
                              });
                            }
                          },
                    child: Container(
                      width: Game.blockSize,
                      height: Game.blockSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Color.fromARGB(255, 113, 255, 191)
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  //erase the board
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MainColor.primaryColor),
              ),
              icon: Icon(Icons.replay),
              label: Text(
                "Repeat the Game",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "Turn of ${lastValue}".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
        ));
    //the first step is organise our project folder structure
  }
}
