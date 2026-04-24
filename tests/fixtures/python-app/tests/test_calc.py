from selftest_app import add, greet


def test_add_sums_two_integers() -> None:
    assert add(2, 3) == 5


def test_greet_formats_the_greeting() -> None:
    assert greet("world") == "hello, world"
