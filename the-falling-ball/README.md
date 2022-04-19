# The falling ball

## Problem description
Imagine an arcade game with the action taking place on a rectangular board of unit-size squares. All squares are either completely empty or completely full.

Quite specific laws of physics have been defined in this world. Suppose a small ball is placed and released freely in a certain empty square. Then, at the beginning of each discrete unit of time, it always completely occupies one empty square. During the unit of time, the ball moves according to the following rules:

- A ball in an empty square with no full square directly below always moves down one square.
- A ball in an empty square with a full square directly below, chooses, with equal probability, to move one square to the left or one square to the right. However, the selected move is not carried out, i.e., the ball stays put, if the target square is full.

When moving, the ball may fall off the board - all squares around the board should be treated as empty.

Knowing the board used in the game and the initial position of the ball, determine the probability that the ball's path will pass through the indicated empty squares.

## Input

The input starts with two integers y x separated by a space, defining the dimensions of the board (1 <= x, y <= 100). In each of the following y lines comes the description of the rows of the board (starting from the top), consisting of exactly x characters each, determining the filling of the individual squares of the row. An occupied square is always represented as the character 'x', and an empty square as one of the characters' {'', '1', '2', '3', '.'}. Each of the characters {'', '1', '2', '3'} appears exactly once throughout the board, and the character '*' describes the starting position of the ball.

It can be assumed that in a single row of the board, full squares are never directly adjacent to each other.

## Output

The output consists of exactly three lines, in which the probability of the ball passing through the empty squares marked '1', '2', '3' should be given in turn. The probability value should be accurate to at least 7 decimal digits.

## Examples

- ##### Example 1

```
Input:

> 9 7
> .......
> ...*...
> .......
> ...x...
> .......
> ..x.x..
> .......
> .1.2.3.
> .......

Output:

>> 0.25
>> 0.5
>> 0.25
```



- ##### Example 2

```
Input:

> 5 5
> ..*.3
> ..x..
> .x.x2
> .....
> x1...

Output:

>> 0.25
>> 0.5
>> 0
```

