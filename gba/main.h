#ifndef MAIN_H
#define MAIN_H

#include "gba.h"

// TODO: Create any necessary structs

/*
* For example, for a Snake game, one could be:
*
* struct snake {
*   int heading;
*   int length;
*   int row;
*   int col;
* };
*
* Example of a struct to hold state machine data:
*
* struct state {
*   int currentState;
*   int nextState;
* };
*
*/
struct player {
    int row;
    int column;
    int width;
    int height;
    int temp1;
    int temp2;
    unsigned short color;
};

struct object {
    int row;
    int column;
    int temp1;
    int temp2;
};

struct state {
    int playerHeight;
    int playerWidth;
    int objHeight;
    int objWidth;
    struct player player1;
    struct object obj1;
};

#endif
