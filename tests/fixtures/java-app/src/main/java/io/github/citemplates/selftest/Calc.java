package io.github.citemplates.selftest;

/**
 * Trivial helpers exercised by {@code CalcTest}. Exist solely so
 * reusable-ci.yml has a Java code path to dog-food.
 */
public final class Calc {

    private Calc() {
        // utility class, no instantiation
    }

    public static int add(int a, int b) {
        return a + b;
    }

    public static String greet(String name) {
        return "hello, " + name;
    }
}
