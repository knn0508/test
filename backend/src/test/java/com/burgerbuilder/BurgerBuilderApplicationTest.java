package com.burgerbuilder;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;

class BurgerBuilderApplicationTest {

    @Test
    void parseAllowedOrigins_ShouldTrimValuesAndDropBlanks() {
        String[] allowedOrigins = BurgerBuilderApplication.parseAllowedOrigins(
                " http://localhost:5173 , , https://burger.example.com "
        );

        assertArrayEquals(
                new String[]{"http://localhost:5173", "https://burger.example.com"},
                allowedOrigins
        );
    }

    @Test
    void parseAllowedOrigins_ShouldReturnEmptyArrayForBlankInput() {
        assertArrayEquals(new String[0], BurgerBuilderApplication.parseAllowedOrigins("   "));
    }
}
