// Package calc is the toy library exercised by calc_test.go.
// It exists purely so reusable-ci.yml has a Go code path to dog-food.
package calc

// Add returns the sum of a and b.
func Add(a, b int) int {
	return a + b
}

// Greet returns a simple greeting for name.
func Greet(name string) string {
	return "hello, " + name
}
