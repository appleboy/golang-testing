package example

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHelloWorld(t *testing.T) {
	assert.Equal(t, "Hello, appleboy", helloWorld("appleboy"))
}
