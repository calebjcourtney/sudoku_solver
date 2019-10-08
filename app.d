import std.array;
import std.stdio;
import std.algorithm;


/**
 * Board
 */
class Board
{
    immutable int[9][9] inputArray;
    immutable bool[9][9] initBoolArray;
    bool boardSolved = false;
    int[9][9] guessMatrix;

    this(int[9][9] inputArray)
    {
        this.inputArray = inputArray;
        this.guessMatrix = inputArray;
        this.initBoolArray = this.createBoolMatrix(inputArray);

        int counter = this.countUnknowns();

        writeln("Unknowns at time of init: ", counter);
    }

    int countUnknowns()
    {
        int counter;
        foreach(row; this.inputArray)
        {
            foreach(column; row)
            {
                if (column == 0)
                    ++counter;
            }
        }

        return counter;
    }

    bool[9][9] createBoolMatrix(int[9][9] matrix)
    {
        bool[9][9] boolArray;
        for (int row; row < 9; ++row)
        {
            for (int column; column < 9; ++column)
            {
                if (matrix[column][row] == 0)
                    boolArray[column][row] = false;
                else
                    boolArray[column][row] = true;
            }
        }

        return boolArray;
    }

    bool checkSolved()
    {
        // if there are values still 0, then it isn't solved
        auto boolArray = this.createBoolMatrix(this.guessMatrix);
        foreach (row; boolArray)
        {
            foreach (column; row)
            {
                if (!column)
                {
                    writeln("found 0s");
                    return false;
                }
            }
        }

        // check that each row has values 1-9 in it
        foreach(row; this.guessMatrix)
        {
            int[] testRow = row;
            for(int i = 1; i < 10; ++i)
            {
                if (!testRow.canFind(i))
                {
                    writeln("invalid rows");
                    return false;
                }
            }
        }

        //check each column has ints 1-9
        //check each "chunk" has ints 1-9

        return true;
    }

    /**
    1. loop through each cell and get all available options
    2. fill any cells that only have one option (return to step 1)

    3. If we're stuck we need to add more logic
    4. Make an assumption and see if it works?
    **/
    int[] getCellOptions(int row, int column)
    {
        if (this.guessMatrix[row][column] != 0)
        {
            return [this.guessMatrix[row][column]];
        }
        int[] options = [1, 2, 3, 4, 5, 6, 7, 8, 9];

        foreach(guessRow; this.guessMatrix)
        {
            if (options.canFind(guessRow[column]))
            {
                options = options.remove(options.countUntil(guessRow[column]));
            }
        }

        foreach (guessColumn; this.guessMatrix[row])
        {
            if (options.canFind(guessColumn))
                options = options.remove(options.countUntil(guessColumn));
        }

        // add in logic for "chunk"
        int[3][3] chunk = getChunk(row, column);
        foreach (guessRow; chunk)
        {
            foreach (guessColumn; guessRow)
            {
                if (options.canFind(guessColumn))
                    options = options.remove(options.countUntil(guessColumn));
            }
        }

        if (options.length == 1)
        {
            this.guessMatrix[row][column] = options[0];
            this.solve();
        }

        return options;
    }

    void solve()
    {
        for (int row; row < 9; ++row)
        {
            for (int column; column < 9; ++column)
            {
                getCellOptions(row, column);
            }
        }
    }

    private:
    int[3][3] getChunk(int row, int column)
    {
        int startRow;
        if (row < 3)
            startRow = 0;
        else if (row < 6)
            startRow = 3;
        else
            startRow = 6;

        int startColumn;
        if (column < 3)
            startColumn = 0;
        else if (column < 6)
            startColumn = 3;
        else
            startColumn = 6;

        int[3][3] output;
        for (int guessRow = startRow; guessRow < startRow + 3; ++guessRow)
        {
            for (int guessColumn = startColumn; guessColumn < startColumn + 3; ++guessColumn)
                output[guessRow % 3][guessColumn % 3] = this.guessMatrix[guessRow][guessColumn];
        }

        return output;
    }
}


void main()
{
    int[9][9] inputArray = [
        [0, 0, 0, 0, 2, 0, 5, 7, 0],
        [0, 0, 0, 4, 0, 6, 0, 0, 0],
        [0, 5, 0, 0, 7, 0, 0, 1, 2],
        [0, 0, 9, 5, 0, 0, 7, 6, 3],
        [5, 0, 6, 9, 0, 7, 2, 0, 1],
        [3, 1, 7, 0, 0, 8, 9, 0, 0],
        [7, 2, 0, 0, 4, 0, 0, 3, 0],
        [0, 0, 0, 6, 0, 2, 0, 0, 0],
        [0, 6, 5, 0, 8, 0, 0, 0, 0]
    ];

    Board board = new Board(inputArray);
    writeln(board.checkSolved());

    board.solve();

    foreach(row; board.guessMatrix)
    {
        writeln(row);
    }

    writeln(board.checkSolved());
}
