package hello

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestHello(t *testing.T) {
	assert.Equal(t, "Hello, appleboy1", hello("appleboy"))
}
