// generate by  https://chat.forefront.ai/

// prompt
// 1) generate a python program that display a bouncing ball
// 2) can you change the bouncing ball equation to emulate a gravity field
// 3) can you translate this code for android platform



// This Java code creates an Android app with a `BouncingBallView` class that extends `SurfaceView` and implements the `Runnable` interface. The `BouncingBallView` class handles the drawing and animation of the bouncing ball, and the `BouncingBallActivity` class sets up the app and manages the lifecycle of the `BouncingBallView`. The code uses a `Canvas` object to draw the ball on the screen, and a `SurfaceHolder` object to manage the surface of the `SurfaceView`. The `gravity` variable is a `float` instead of an `int` to allow for more precise calculations.

import android.app.Activity;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class BouncingBallActivity extends Activity {

    private BouncingBallView bouncingBallView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        bouncingBallView = new BouncingBallView(this);
        setContentView(bouncingBallView);
    }

    @Override
    protected void onResume() {
        super.onResume();
        bouncingBallView.resume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        bouncingBallView.pause();
    }

    private class BouncingBallView extends SurfaceView implements Runnable {

        private Thread thread = null;
        private SurfaceHolder surfaceHolder;
        private volatile boolean running = false;

        private int screen_width;
        private int screen_height;

        private int ball_radius = 20;
        private int ball_x;
        private int ball_y;
        private int ball_speed_x = 5;
        private int ball_speed_y = 0;

        private Paint paint;

        private float gravity = 0.5f;

        public BouncingBallView(Context context) {
            super(context);
            surfaceHolder = getHolder();
            paint = new Paint();
            paint.setColor(Color.BLACK);
        }

        @Override
        public void run() {
            while (running) {
                if (surfaceHolder.getSurface().isValid()) {
                    Canvas canvas = surfaceHolder.lockCanvas();
                    canvas.drawColor(Color.WHITE);

                    // Apply gravity to the ball
                    ball_speed_y += gravity;

                    // Move the ball
                    ball_x += ball_speed_x;
                    ball_y += ball_speed_y;

                    // Bounce the ball off the walls
                    if (ball_x + ball_radius > screen_width) {
                        ball_x = screen_width - ball_radius;
                        ball_speed_x = -ball_speed_x;
                    } else if (ball_x - ball_radius < 0) {
                        ball_x = ball_radius;
                        ball_speed_x = -ball_speed_x;
                    }
                    if (ball_y + ball_radius > screen_height) {
                        ball_y = screen_height - ball_radius;
                        ball_speed_y = -(int) (ball_speed_y * 0.9f);
                    } else if (ball_y - ball_radius < 0) {
                        ball_y = ball_radius;
                        ball_speed_y = -ball_speed_y;
                    }

                    // Draw the ball
                    canvas.drawCircle(ball_x, ball_y, ball_radius, paint);

                    // Unlock the canvas and update the screen
                    surfaceHolder.unlockCanvasAndPost(canvas);
                }
            }
        }

        public void resume() {
            running = true;
            thread = new Thread(this);
            thread.start();
        }

        public void pause() {
            running = false;
            while (true) {
                try {
                    thread.join();
                    break;
                } catch (InterruptedException e) {
                    // retry
                }
            }
        }

        @Override
        public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            screen_width = width;
            screen_height = height;
            ball_x = screen_width / 2;
            ball_y = screen_height / 2;
        }

        @Override
        public void surfaceCreated(SurfaceHolder holder) {
            resume();
        }

        @Override
        public void surfaceDestroyed(SurfaceHolder holder) {
            pause();
        }
    }
}
