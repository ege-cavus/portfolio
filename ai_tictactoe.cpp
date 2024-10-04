#include <iostream>
#include <vector>

using namespace std;

const char PLAYER = 'O';  
const char AI = 'X';      
const int BOARD_SIZE = 3; 

const int MAX_VAL = 1000;
const int MIN_VAL = -1000;

void printBoard(const vector<vector<char>>& board);
bool isMovesLeft(const vector<vector<char>>& board);
int evaluate(const vector<vector<char>>& board);
int minimax(vector<vector<char>>& board, int depth, bool isMaximizing, int alpha, int beta);
pair<int, int> findBestMove(vector<vector<char>>& board);
bool checkWin(const vector<vector<char>>& board, char player);
bool isFull(const vector<vector<char>>& board);

void printBoard(const vector<vector<char>>& board) {
    cout << "Current Board:\n";
    for (int row = 0; row < BOARD_SIZE; row++) {
        for (int col = 0; col < BOARD_SIZE; col++) {
            cout << board[row][col] << " ";
        }
        cout << endl;
    }
}

bool isMovesLeft(const vector<vector<char>>& board) {
    for (int row = 0; row < BOARD_SIZE; row++) {
        for (int col = 0; col < BOARD_SIZE; col++) {
            if (board[row][col] == '_') {
                return true;
            }
        }
    }
    return false;
}


int evaluate(const vector<vector<char>>& board) {
    if (checkWin(board, AI)) return 10;
    if (checkWin(board, PLAYER)) return -10;
    return 0;
}


int minimax(vector<vector<char>>& board, int depth, bool isMaximizing, int alpha, int beta) {
    int score = evaluate(board);
    

    if (score == 10 || score == -10) return score;


    if (!isMovesLeft(board)) return 0;


    if (isMaximizing) {
        int best = MIN_VAL;

        for (int row = 0; row < BOARD_SIZE; row++) {
            for (int col = 0; col < BOARD_SIZE; col++) {
                // Check if the cell is empty
                if (board[row][col] == '_') {
                    // Make the move
                    board[row][col] = AI;

                    // Call minimax recursively and choose the maximum value
                    best = max(best, minimax(board, depth + 1, !isMaximizing, alpha, beta));

                    // Undo the move
                    board[row][col] = '_';

                    // Alpha-beta pruning
                    alpha = max(alpha, best);
                    if (beta <= alpha) break;
                }
            }
        }
        return best;
    }

    else {
        int best = MAX_VAL;

        for (int row = 0; row < BOARD_SIZE; row++) {
            for (int col = 0; col < BOARD_SIZE; col++) {
                
                if (board[row][col] == '_') {
                    board[row][col] = PLAYER;
                    best = min(best, minimax(board, depth + 1, !isMaximizing, alpha, beta));
                    board[row][col] = '_';
                    beta = min(beta, best);
                    if (beta <= alpha) break;
                }
            }
        }
        return best;
    }
}


pair<int, int> findBestMove(vector<vector<char>>& board) {
    int bestVal = MIN_VAL;
    pair<int, int> bestMove = {-1, -1};


    for (int row = 0; row < BOARD_SIZE; row++) {
        for (int col = 0; col < BOARD_SIZE; col++) {
            if (board[row][col] == '_') {
                // Make the move
                board[row][col] = AI;
                int moveVal = minimax(board, 0, false, MIN_VAL, MAX_VAL);
                board[row][col] = '_';
                if (moveVal > bestVal) {
                    bestMove.first = row;
                    bestMove.second = col;
                    bestVal = moveVal;
                }
            }
        }
    }
    return bestMove;
}


bool checkWin(const vector<vector<char>>& board, char player) {
    for (int row = 0; row < BOARD_SIZE; row++) {
        if (board[row][0] == player && board[row][1] == player && board[row][2] == player)
            return true;
    }
    for (int col = 0; col < BOARD_SIZE; col++) {
        if (board[0][col] == player && board[1][col] == player && board[2][col] == player)
            return true;
    }
    if (board[0][0] == player && board[1][1] == player && board[2][2] == player)
        return true;
    if (board[0][2] == player && board[1][1] == player && board[2][0] == player)
        return true;
    
    return false;
}

bool isFull(const vector<vector<char>>& board) {
    for (int row = 0; row < BOARD_SIZE; row++) {
        for (int col = 0; col < BOARD_SIZE; col++) {
            if (board[row][col] == '_') return false;
        }
    }
    return true;
}


int main() {
    vector<vector<char>> board = {
        {'_', '_', '_'},
        {'_', '_', '_'},
        {'_', '_', '_'}
    };

    cout << "Tic-Tac-Toe: You are 'O' and the computer is 'X'.\n";

    while (true) {
        int row, col;
        printBoard(board);
        cout << "Enter your move (row and column: 0, 1, or 2): ";
        cin >> row >> col;

        if (board[row][col] == '_') {
            board[row][col] = PLAYER;
        } else {
            cout << "Invalid move. Try again.\n";
            continue;
        }

        if (checkWin(board, PLAYER)) {
            printBoard(board);
            cout << "You win!\n";
            break;
        }
        if (isFull(board)) {
            printBoard(board);
            cout << "It's a draw!\n";
            break;
        }


        pair<int, int> bestMove = findBestMove(board);
        board[bestMove.first][bestMove.second] = AI;


        if (checkWin(board, AI)) {
            printBoard(board);
            cout << "AI wins!\n";
            break;
        }
        if (isFull(board)) {
            printBoard(board);
            cout << "It's a draw!\n";
            break;
        }
    }

    return 0;
}

