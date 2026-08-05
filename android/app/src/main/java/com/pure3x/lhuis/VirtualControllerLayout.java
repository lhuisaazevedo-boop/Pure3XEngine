package com.pure3x.lhuis;

public class VirtualControllerLayout {

    private final VirtualAnalog leftAnalog;
    private final VirtualAnalog rightAnalog;

    private final VirtualButton up;
    private final VirtualButton down;
    private final VirtualButton left;
    private final VirtualButton right;

    private final VirtualButton triangle;
    private final VirtualButton circle;
    private final VirtualButton cross;
    private final VirtualButton square;

    private final VirtualButton l1;
    private final VirtualButton l2;
    private final VirtualButton r1;
    private final VirtualButton r2;

    private final VirtualButton start;
    private final VirtualButton select;
    private final VirtualButton ps;

    public VirtualControllerLayout(int width, int height) {

        float analogRadius = 90f;
        float buttonRadius = 45f;

        leftAnalog =
                new VirtualAnalog(220f, height - 260f, analogRadius);

        rightAnalog =
                new VirtualAnalog(width - 220f, height - 260f, analogRadius);

        up =
                new VirtualButton("UP",120f,height-470f,buttonRadius);

        down =
                new VirtualButton("DOWN",120f,height-310f,buttonRadius);

        left =
                new VirtualButton("LEFT",40f,height-390f,buttonRadius);

        right =
                new VirtualButton("RIGHT",200f,height-390f,buttonRadius);

        triangle =
                new VirtualButton("TRIANGLE",width-120f,height-470f,buttonRadius);

        circle =
                new VirtualButton("CIRCLE",width-40f,height-390f,buttonRadius);

        cross =
                new VirtualButton("CROSS",width-120f,height-310f,buttonRadius);

        square =
                new VirtualButton("SQUARE",width-200f,height-390f,buttonRadius);

        l1 =
                new VirtualButton("L1",120f,80f,55f);

        l2 =
                new VirtualButton("L2",120f,170f,55f);

        r1 =
                new VirtualButton("R1",width-120f,80f,55f);

        r2 =
                new VirtualButton("R2",width-120f,170f,55f);

        select =
                new VirtualButton("SELECT",width/2f-90f,height-180f,40f);

        start =
                new VirtualButton("START",width/2f+90f,height-180f,40f);

        ps =
                new VirtualButton("PS",width/2f,height-90f,45f);
    }

    public VirtualAnalog getLeftAnalog() {
        return leftAnalog;
    }

    public VirtualAnalog getRightAnalog() {
        return rightAnalog;
    }

    public VirtualButton getUp() { return up; }

    public VirtualButton getDown() { return down; }

    public VirtualButton getLeft() { return left; }

    public VirtualButton getRight() { return right; }

    public VirtualButton getTriangle() { return triangle; }

    public VirtualButton getCircle() { return circle; }

    public VirtualButton getCross() { return cross; }

    public VirtualButton getSquare() { return square; }

    public VirtualButton getL1() { return l1; }

    public VirtualButton getL2() { return l2; }

    public VirtualButton getR1() { return r1; }

    public VirtualButton getR2() { return r2; }

    public VirtualButton getStart() { return start; }

    public VirtualButton getSelect() { return select; }

    public VirtualButton getPS() { return ps; }
}
