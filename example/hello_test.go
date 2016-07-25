package example

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestHelloWorld(t *testing.T) {
	assert.Equal(t, "Hello, appleboy", helloWorld("appleboy"))
}
