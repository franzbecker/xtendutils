xtendutils
==========

[![License](http://img.shields.io/badge/license-EPL-blue.svg?style=flat)](https://www.eclipse.org/legal/epl-v10.html)
[![Build Status](https://travis-ci.org/franzbecker/xtendutils.svg?branch=master)](https://travis-ci.org/franzbecker/xtendutils)

This is a collection of stuff I implemented for Xtend (currently 2.8.2) and find useful to share with myself and others ;-)
Feel free to copy&paste parts into your project or send me a pull request if you have useful enhancements.


## JUnit ##
`de.xtendutils.junit`
This package provides utilities for unit testing.

### AssertionHelper ###
-----------------------
In Xtend it is possible to use extension methods that allow us to "add" new methods to existing types without modifying them. 
In testing this becomes quite handy since we can "add" the assertion methods to the types we want to test.

Instead of writing: ```assertEquals(expected, actual)``` we could think about writing ```actual.assertEquals(expected)```.

Using this pattern assertions become much more readable than JUnit's default assertions and simple ones become slightly more readable than using [truth](http://google.github.io/truth) or [assertj](http://joel-costigliola.github.io/assertj/).
The methods of AssertionHelper were designed to allow chaining, but unlike pure-Java we don't need verbose fluent APIs as we can simply pass objects to a lambda using the with-operator.

Here are some sample assertions that you can do:

```xtend
  // simple assertions
  val x = "x"
  val y = "y"
  x.assertEquals("x")
  x.assertNotEquals(y)
  x.assertSame(x)
  x.assertNotSame(y)
	
  // instance of assertion
  obj.assertInstanceOf(String).length.assertEquals(4)
  
  // assertions on iterable
  #[].assertEmpty
  #["test"].assertSingleElement => [
    assertEquals("test")
  ]
```

Assertions on lambdas:
```xtend
	val divide = [BigDecimal x, BigDecimal y | x.divide(y)]
		
	[divide.apply(1bd, 0bd)].assertFail(ArithmeticException) => [
		message.assertEquals("Division by zero")
	]
```

In AssertJ with Java 8 you would write:
```java
	final BiFunction<BigDecimal, BigDecimal, BigDecimal> divide = (BigDecimal x, BigDecimal y) -> x.divide(y);
		
	assertThatThrownBy(() -> divide.apply(BigDecimal.ONE, BigDecimal.ZERO))
		.isInstanceOf(ArithmeticException.class)
		.hasMessage("Division by zero");
```

Note that the methods of `AssertionHelper` are non-static. This feels kind of strange but is has one major advantage which I found superior: we can declare it as an [extension](https://eclipse.org/xtend/documentation/202_xtend_classes_members.html#extension-methods) [provider](http://blog.efftinge.de/2013/06/xtends-extension-providers.html) in a super class of all our tests.
This way we don't need to add a static import everytime we create a new test class and also could exchange the implementation in the future.

## Lib ##
`de.xtendutils.lib`
This package provides utilities for the standard Java library.

### Extensions ###
Xtend already comes with a great default for extension methods. This package contains some more extensions that can be included on demand.
