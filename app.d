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
                if (this.inputArray[column][row] == 0)
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
                    return false;
            }
        }

        //foreach(row; this.inputArray)
        //{
        //    for(int i; i < 10; ++i)
        //    {
        //        if (!row.canFind(i))
        //        {
        //            writeln("invalid rows");
        //            return false;
        //        }
        //    }
        //}

        //for (int i; i < 10; ++i)
        //{
        //    int[] tempArray;

        //    foreach (row; this.inputArray)
        //    {
        //        tempArray ~= row[i];
        //    }

        //    if (!tempArray.canFind(i))
        //    {
        //        writeln("invalid invalid columns");
        //        return false;
        //    }
        //}

        //check each row has ints 1-9
        //check each column has ints 1-9
        //check each "bucket" has ints 1-9

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
                options = options.remove(
                    options.countUntil(guessRow[column])
                );
            }
        }

        foreach (guessColumn; this.guessMatrix[row])
        {
            if (options.canFind(guessColumn))
                options = options.remove(
                    options.countUntil(guessColumn)
                );
        }

        // add in logic for "chunk"

        if (options.length == 1)
        {
            this.guessMatrix[row][column] = options[0];
            this.getBoardOptions();
        }

        return options;
    }

    void getBoardOptions()
    {
        for (int row; row < 9; ++row)
        {
            for (int column; column < 9; ++column)
            {
                getCellOptions(row, column);
            }
        }
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
    //writeln(board.countUnknowns());
    auto boolArray = board.createBoolMatrix(board.guessMatrix);
    //writeln(board.checkSolved());

    board.getBoardOptions();

    foreach(row; board.guessMatrix)
    {
        writeln(row);
    }

    int counter;

    foreach(row; board.guessMatrix)
    {
        foreach(column; row)
        {
            if (column == 0)
                ++counter;
        }
    }

    writeln(counter);
}