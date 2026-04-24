package calc

import "testing"

func TestAddSumsTwoIntegers(t *testing.T) {
	t.Parallel()
	if got := Add(2, 3); got != 5 {
		t.Fatalf("Add(2, 3) = %d, want 5", got)
	}
}

func TestGreetFormatsTheGreeting(t *testing.T) {
	t.Parallel()
	if got := Greet("world"); got != "hello, world" {
		t.Fatalf("Greet(%q) = %q, want %q", "world", got, "hello, world")
	}
}
