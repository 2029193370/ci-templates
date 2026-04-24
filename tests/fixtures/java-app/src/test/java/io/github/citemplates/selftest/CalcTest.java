package io.github.citemplates.selftest;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CalcTest {

    @Test
    void addSumsTwoIntegers() {
        assertEquals(5, Calc.add(2, 3));
    }

    @Test
    void greetFormatsTheGreeting() {
        assertEquals("hello, world", Calc.greet("world"));
    }
}
