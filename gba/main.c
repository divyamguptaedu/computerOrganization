#include "main.h"
#include <stdio.h>
#include <stdlib.h>
#include "images/startBackground.h"
#include "images/pacman.h"
#include "images/winBackground.h"
#include "images/loseBackground.h"
#include "gba.h"

enum gba_state {
  START,
  PLAY,
  PAUSE,
  WIN,
  LOSE,
};

int main(void) {
  REG_DISPCNT = MODE3 | BG2_ENABLE;

  int timer = 10;
  int converter = 0;
  int hold_timer = 5;
  int hold_timer_converter = 0;
  int level = 1;
  
  u32 previousButtons = BUTTONS;
  u32 currentButtons = BUTTONS;

  struct player *l, *ll;
  struct state currentState, previousState;
  struct object *x, *ox;

  currentState.objHeight = 30;
  currentState.objWidth = 50;
  currentState.playerHeight = 5;
  currentState.playerWidth = 5;

  enum gba_state state = START;

  while (1) {
    currentButtons = BUTTONS;
    waitForVBlank();

    switch (state) {
      case START:
        x = &currentState.obj1;
        x->row = rand() % HEIGHT;
        x->column = rand() % WIDTH;
        x->temp1 = 1;
        x->temp2 = 1;
        l = &currentState.player1;
        l->row = rand() % HEIGHT;
        l->column = rand() % WIDTH;
        l->color = MAGENTA;
        l->temp1 = 2;
        l->temp2 = 2;
        drawFullScreenImageDMA(startBackground);
        drawString(HEIGHT - 10, WIDTH, "LET'S START", WHITE);
        if (KEY_DOWN(BUTTON_START, currentButtons)) {
          timer = 5;
          hold_timer = 3;
          state = PLAY;
        }
        break;

      case PLAY:
        fillScreenDMA(BLACK);
        if (KEY_DOWN(BUTTON_SELECT, currentButtons)) {
          timer = 5;
          hold_timer = 3;
          level = 1;
          state = START;
        }

        converter++;
        if ((converter % 60) == 0) {
            timer--;
        }
        if (timer <= 0) {
            state = PAUSE;
        }

        previousState = currentState;
        x = &currentState.obj1;
        x->row = x->row + x->temp1;
        x->column += x->temp2;
        l = &currentState.player1;

        if(KEY_DOWN(BUTTON_UP, currentButtons)) {
            l->row = l->row - 1;
        }
        if(KEY_DOWN(BUTTON_DOWN, currentButtons)) {
            l->row = l->row + 1;
        }
        if(KEY_DOWN(BUTTON_LEFT, currentButtons)) {
            l->column = l->column - 1;
        }
        if(KEY_DOWN(BUTTON_RIGHT, currentButtons)) {
            l->column = l->column + 1;
        }
        if(KEY_DOWN(BUTTON_SELECT, currentButtons)) {
            timer = 5;
            hold_timer = 3;
            level = 1;
            state = START;
        }
        if(x->row < 0) {
            x->row = 0;
            x->temp1 = -x->temp1;
        }
        if(x->row > HEIGHT -currentState.objHeight) {
            x->row = HEIGHT - currentState.objHeight;
            x->temp1 = -x->temp1;
        }
        if(x->column < 0) {
            x->column = 0;
            x->temp2 = -x->temp2;
        }
        if(x->column > WIDTH -currentState.objWidth) {
            x->column = WIDTH - currentState.objWidth;
            x->temp2 = -x->temp2;
        }
        if(l->row < 0) {
            l->row = 0;
            l->temp1 = -l->temp1;
        }
        if(l->row > HEIGHT -currentState.playerHeight) {
            l->row = HEIGHT - currentState.playerHeight;
            l->temp1 = -l->temp1;
        }
        if(l->column < 0) {
            l->column = 0;
            l->temp2 = -l->temp2;
        }
        if(l->column > WIDTH -currentState.playerWidth) {
            l->column = WIDTH - currentState.playerWidth;
            l->temp2 = -l->temp2;
        }
        ox = &previousState.obj1;
        drawRectDMA(ox->row, ox->column, previousState.objWidth, previousState.objHeight, BLACK);
        ll = &previousState.player1;
        drawRectDMA(ll->row, ll->column, previousState.playerWidth, previousState.playerHeight, BLACK);
        x = &currentState.obj1;
        drawImageDMA(x->row, x->column, currentState.objWidth, currentState.objHeight, pacman);
        l = &currentState.player1;
        drawRectDMA(l->row, l->column, currentState.playerWidth, currentState.playerHeight, MAGENTA);
        for (int i = 0; i < currentState.objWidth; i++) {
            for (int k = 0; k < currentState.objHeight; k++) {
                if ((x->column + i == l->column) && (x->row + k == l->row)) {
                    state = LOSE;
                }
            }
        }

        break;

      case PAUSE:
        if (KEY_DOWN(BUTTON_SELECT, currentButtons)) {
          timer = 5;
          hold_timer = 3;
          level = 1;
          state = START;
        }
        hold_timer_converter++;
        if ((hold_timer_converter % 60) == 0) {
            hold_timer--;
        }
        if (hold_timer <= 0) {
            level++;
            if (level > 3) {
              state = WIN;
            } else {
              timer = 5;
              hold_timer = 3;
              state = PLAY;
            }
        }
        char hold_timer_space[50];
        sprintf(hold_timer_space, "TIMER: %d", hold_timer);
        drawRectDMA(150, 80, 80, 10, BLACK);
        drawString(150, 80, hold_timer_space, BLUE);
        char levelSpace[50];
        sprintf(levelSpace, "LEVEL: %d", level);
        drawString(150, 5, levelSpace, WHITE);
        break;

      case WIN:
        drawFullScreenImageDMA(winBackground);
        drawString(HEIGHT/2, 100, "WINNER!!!", BLACK);
        if (KEY_DOWN(BUTTON_SELECT, currentButtons)) {
          timer = 5;
          hold_timer = 3;
          level = 1;
          state = START;
        }
        break;

      case LOSE:
        drawFullScreenImageDMA(loseBackground);
        drawString(HEIGHT/2, 45, "YOU LOST!!!", WHITE);
        if (KEY_DOWN(BUTTON_SELECT, currentButtons)) {
          timer = 5;
          hold_timer = 3;
          level = 1;
          state = START;
        }
        break;
    }
    previousButtons = currentButtons;
  }
  UNUSED(previousButtons);
  return 0;
}
