/*******************************************************************************
 * Copyright (c) 2013-2015 Franz Becker and others.
 * GitHub repository: https://github.com/franzbecker/xtendutils
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package de.xtendutils.junit

import java.math.BigDecimal
import javax.annotation.ParametersAreNullableByDefault
import javax.inject.Singleton
import org.junit.Assert

// TODO proper comment, old one was not good enough
/**
 * 
 * <p>Note that Eclipse users can easily filter the stack trace of this class:<br/>
 * Preferences - Java - JUnit - Add Class - and pick this class.</p>
 */
@Singleton
@ParametersAreNullableByDefault
class AssertionHelper {

	static val INSTANCE = new AssertionHelper

	/**
	 * Static singleton in case dependency injection is not available.
	 */
	static def AssertionHelper getInstance() {
		return INSTANCE
	}

	/** Protected constructor to force user to use dependency injection or the provided singleton. */
	protected new() {
	}

	//////////////////////////////////////////////
	// Methods not included in Assert below
	//////////////////////////////////////////////
	
	/**
	 * Asserts that an iterable is empty.
	 * If it isn't it throws an {@link AssertionError}.
	 * 
	 * @param iterable iterable to be checked
	 */
	def void assertEmpty(Iterable<?> iterable) {
		iterable.assertEmpty(null)
	}

	/**
	 * Asserts that an iterable is empty.
	 * If it isn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param iterable iterable to be checked
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 */
	def void assertEmpty(Iterable<?> iterable, String message) {
		if (iterable === null) {
			Assert.fail(message.format(null, "empty iterable"))
		}
		if (!iterable.empty) {
			val size = iterable.size
			Assert.fail(message.format(size.elementsString, "empty iterable"))
		}
	}

	/**
	 * Asserts that an iterable is non-empty.
	 * If it isn't it throws an {@link AssertionError}.
	 * 
	 * @param iterable iterable to be checked
	 * @return the iterable for chaining
	 */
	def <T> Iterable<T> assertNotEmpty(Iterable<T> iterable) {
		return iterable.assertNotEmpty(null)
	}

	/**
	 * Asserts that an iterable is non-empty.
	 * If it isn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param iterable iterable to be checked
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the iterable for chaining
	 */
	def <T> Iterable<T> assertNotEmpty(Iterable<T> iterable, String message) {
		if (iterable === null) {
			Assert.fail(message.format(null, "non-empty iterable"))
		}
		if (iterable.empty) {
			Assert.fail(message.format("empty", "non-empty iterable"))
		}
		return iterable
	}

	/**
	 * Asserts that an iterable contains a single element.
	 * If it doesn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param iterable the iterable to be checked
	 * @return the single element for chaining
	 */
	def <T> T assertSingleElement(Iterable<T> iterable) {
		return iterable.assertSingleElement(null)
	}

	/**
	 * Asserts that an iterable contains a single element.
	 * If it doesn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param iterable the iterable to be checked
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the single element for chaining
	 */
	def <T> T assertSingleElement(Iterable<T> iterable, String message) {
		iterable.assertSize(1, message)
		return iterable.head
	}

	/**
	 * Asserts that an iterable has a given number of elements.
	 * If it doesn't it throws an {@link AssertionError}.
	 * 
	 * @param iterable the iterable to be checked
	 * @param expectedSize the expected number of elements
	 * @return the iterable for chaining
	 */
	def <T> Iterable<T> assertSize(Iterable<T> iterable, int expectedSize) {
		iterable.assertSize(expectedSize, null)
	}

	/**
	 * Asserts that an iterable has a given number of elements.
	 * If it doesn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param iterable the iterable to be checked
	 * @param expectedSize the expected number of elements
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the iterable for chaining
	 */
	def <T> Iterable<T> assertSize(Iterable<T> iterable, int expectedSize, String message) {
		if (iterable === null) {
			Assert.fail(message.format(null, expectedSize.elementsString))
		}
		val size = iterable.size
		if (size !== expectedSize) {
			Assert.fail(message.format(size.elementsString, expectedSize.elementsString))
		}
		return iterable
	}

	/**
	 * Asserts that an object is of the given type.
	 * If it isn't it throws an {@link AssertionError}.
	 * 
	 * @param object the object to be checked
	 * @param type the type to check against (not {@code null})
	 * @return the object casted to the type
	 */
	def <T> T assertInstanceOf(Object object, Class<T> type) {
		object.assertInstanceOf(type, null)
	}

	/**
	 * Asserts that an object is of the given type.
	 * If it isn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param object the object to be checked
	 * @param type the type to check against (not {@code null})
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the object casted to the type
	 */
	def <T> T assertInstanceOf(Object object, Class<T> type, String message) {
		if (type === null) {
			throw new IllegalArgumentException("The passed type may not be null.")
		}
		if (object === null) {
			Assert.fail(message.format(null, type.name))
		}
		if (!(type.isAssignableFrom(object.class))) {
			Assert.fail(message.format(object.class.name, type.name))
		}
		return object as T
	}

	/**
	 * Asserts that two {@link BigDecimal} objects are equals based on the result of their
	 * {@link BigDecimal#compareTo(BigDecimal) compareTo} method. 
	 * If they are not, an {@link AssertionError} is thrown with the given message. 
	 * 
	 * If {@code actual} and {@code expected} are {@code null}, they are considered equal.
	 * 
	 * @param actual actual value
	 * @param expected expected value
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 */
	def void assertEquals(BigDecimal actual, BigDecimal expected, String message) {
		if (actual === null) {
			if (expected !== null) {
				Assert.fail(message.format(actual, expected))
			}
		} else {
			if (actual.compareTo(expected) !== 0) {
				Assert.fail(message.format(actual, expected))
			}
		}
	}

	/**
	 * Asserts that two {@link BigDecimal} objects are equals based on the result of their
	 * {@link BigDecimal#compareTo(BigDecimal) compareTo} method. 
	 * If they are not, an {@link AssertionError} is thrown. 
	 * 
	 * If {@code actual} and {@code expected} are {@code null}, they are considered equal.
	 * 
	 * @param actual actual value
	 * @param expected expected value
	 */
	def void assertEquals(BigDecimal actual, BigDecimal expected) {
		actual.assertEquals(expected, null)
	}
	
	// TODO should we rather provide assertEquals for subtypes of Comparable?

	/**
	 * Asserts that two {@link BigDecimal} objects are <b>not</b>equals based on the result of their
	 * {@link BigDecimal#compareTo(BigDecimal) compareTo} method. 
	 * If they are not, an {@link AssertionError} is thrown with the given message. 
	 * 
	 * If {@code actual} and {@code expected} are {@code null}, they are considered equal.
	 * 
	 * @param actual the value to check against {@code unexpected}
	 * @param unexpected unexpected value to check
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 */
	def void assertNotEquals(BigDecimal actual, BigDecimal unexpected, String message) {
		if (actual === null) {
			if (unexpected === null) {
				failEquals(message, null)
			}
		}
	}

	/**
	 * Asserts that the exceution of the function results in the expected exception type.
	 * If it isn't it throws an {@link AssertionError}.
	 * 
	 * @param function function to be checked
	 * @return the expection for further inspection
	 */
	def <T extends Throwable> T assertFail((Object)=>Object function, Class<T> throwableClass) {
		return function.assertFail(throwableClass, null)
	}

	/**
	 * Asserts that the exceution of the function results in the expected exception type.
	 * If it isn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param function function to be checked
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the expection for further inspection
	 */
	def <T extends Throwable> T assertFail((Object)=>Object function, Class<T> throwableClass, String message) {
		try {
			function.apply(null)
		} catch (Throwable actual) {
			return actual.assertInstanceOf(throwableClass)
		}
		Assert.fail(message.format("no exception", throwableClass.name))
		throw new IllegalStateException // dead code
	}

	/**
	 * Asserts that the exceution of the procedure results in the expected exception type.
	 * If it isn't it throws an {@link AssertionError}.
	 * 
	 * @param procedure procedure to be checked
	 * @return the expection for further inspection
	 */
	def <T extends Throwable> T assertFail((Object)=>void procedure, Class<T> throwableClass) {
		return procedure.assertFail(throwableClass, null)
	}

	/**
	 * Asserts that the exceution of the procedure results in the expected exception type.
	 * If it isn't it throws an {@link AssertionError} with the given message.
	 * 
	 * @param procedure procedure to be checked
	 * @param message the identifying message for the {@link AssertionError} ({@code null} okay)
	 * @return the expection for further inspection
	 */
	def <T extends Throwable> T assertFail((Object)=>void procedure, Class<T> throwableClass, String message) {
		try {
			procedure.apply(null)
		} catch (Throwable actual) {
			return actual.assertInstanceOf(throwableClass)
		}
		Assert.fail(message.format("no exception", throwableClass.name))
		throw new IllegalStateException // dead code
	}

	//////////////////////////////////////////////
	// Standard JUnit methods below
	//////////////////////////////////////////////

	/** Calls {@link Assert#assertTrue(String, boolean)} */
	def void assertTrue(boolean condition, String message) {
		Assert.assertTrue(message, condition)
	}

	/** Calls {@link Assert#assertTrue(boolean)} */
	def void assertTrue(boolean condition) {
		Assert.assertTrue(condition)
	}

	/** Calls {@link Assert#assertFalse(String, boolean)} */
	def void assertFalse(boolean condition, String message) {
		Assert.assertFalse(message, condition)
	}

	/** Calls {@link Assert#assertFalse(boolean)} */
	def void assertFalse(boolean condition) {
		Assert.assertFalse(condition)
	}

	/** Calls {@link Assert#fail(String)} */
	def void fail(String message) {
		Assert.fail(message)
	}

	/** Calls {@link Assert#fail} */
	def void fail() {
		Assert.fail
	}

	/** Calls {@link Assert#assertEquals(String, Object, Object)} */
	def void assertEquals(Object actual, Object expected, String message) {
		Assert.assertEquals(message, expected, actual)
	}

	/** Calls {@link Assert#assertEquals(Object, Object)} */
	def void assertEquals(Object actual, Object expected) {
		Assert.assertEquals(expected, actual)
	}

	/** Calls {@link Assert#assertNotEquals(String, Object, Object)} */
	def void assertNotEquals(Object actual, Object unexpected, String message) {
		Assert.assertNotEquals(message, unexpected, actual)
	}

	/** Calls {@link Assert#assertNotEquals(Object, Object)} */
	def void assertNotEquals(Object actual, Object unexpected) {
		Assert.assertNotEquals(unexpected, actual)
	}

	/** Calls {@link Assert#assertNotEquals(String, long, long)} */
	def void assertNotEquals(long actual, long unexpected, String message) {
		Assert.assertNotEquals(message, unexpected, actual)
	}

	/** Calls {@link Assert#assertNotEquals(long, long)} */
	def void assertNotEquals(long actual, long unexpected) {
		Assert.assertNotEquals(unexpected, actual)
	}

	/** Calls {@link Assert#assertNotEquals(String, double, double, double)} */
	def void assertNotEquals(double actual, double unexpected, double delta, String message) {
		Assert.assertNotEquals(message, unexpected, actual, delta)
	}

	/** Calls {@link Assert#assertNotEquals(double, double, double)} */
	def void assertNotEquals(double actual, double unexpected, double delta) {
		Assert.assertNotEquals(unexpected, actual, delta)
	}

	/** Calls {@link Assert#assertNotEquals(String, float, float, float)} */
	def void assertNotEquals(float actual, float unexpected, float delta, String message) {
		Assert.assertNotEquals(message, unexpected, actual, delta)
	}

	/** Calls {@link Assert#assertNotEquals(float, float, float)} */
	def void assertNotEquals(float actual, float unexpected, float delta) {
		Assert.assertNotEquals(unexpected, actual, delta)
	}

	/** Calls {@link Assert#assertEquals(String, double, double, double)} */
	def void assertEquals(double actual, double expected, double delta, String message) {
		Assert.assertEquals(message, expected, actual, delta)
	}

	/** Calls {@link Assert#assertEquals(String, float, float, float)} */
	def void assertEquals(float actual, float expected, float delta, String message) {
		Assert.assertEquals(message, expected, actual, delta)
	}

	/** Calls {@link Assert#assertEquals(long, long)} */
	def void assertEquals(long actual, long expected) {
		Assert.assertEquals(expected, actual)
	}

	/** Calls {@link Assert#assertEquals(String, long, long)} */
	def void assertEquals(long actual, long expected, String message) {
		Assert.assertEquals(message, expected, actual)
	}

	/** Calls {@link Assert#assertEquals(double, double, double)} */
	def void assertEquals(double actual, double expected, double delta) {
		Assert.assertEquals(expected, actual, delta)
	}

	/** Calls {@link Assert#assertEquals(float, float, float)} */
	def void assertEquals(float actual, float expected, float delta) {
		Assert.assertEquals(expected, actual, delta)
	}

	/** Calls {@link Assert#assertNotNull(String, Object)} */
	def <T> T assertNotNull(T object, String message) {
		Assert.assertNotNull(message, object)
		return object
	}

	/** Calls {@link Assert#assertNotNull(Object)} */
	def <T> T assertNotNull(T object) {
		Assert.assertNotNull(object)
		return object
	}

	/** Calls {@link Assert#assertNull(String, Object)} */
	def void assertNull(Object object, String message) {
		Assert.assertNull(message, object)
	}

	/** Calls {@link Assert#assertNull(Object)} */
	def void assertNull(Object object) {
		Assert.assertNull(object)
	}

	/** Calls {@link Assert#assertSame(String, Object, Object)} */
	def void assertSame(Object actual, Object expected, String message) {
		Assert.assertSame(message, expected, actual)
	}

	/** Calls {@link Assert#assertSame(Object, Object)} */
	def void assertSame(Object actual, Object expected) {
		Assert.assertSame(expected, actual)
	}

	/** Calls {@link Assert#assertNotSame(String, Object, Object)} */
	def void assertNotSame(Object actual, Object unexpected, String message) {
		Assert.assertNotSame(message, unexpected, actual)
	}

	/** Calls {@link Assert#assertNotSame(Object, Object)} */
	def void assertNotSame(Object actual, Object unexpected) {
		Assert.assertNotSame(unexpected, actual)
	}

	/**
	 * Method from {@link Assert} converted to Xtend since it is package private and not accessible.
	 */
	protected def String format(String messageObj, Object actual, Object expected) {
		val message = if (messageObj.nullOrEmpty) "" else ( messageObj + " ")
		val expectedString = String.valueOf(expected)
		val actualString = String.valueOf(actual)
		if (expectedString == actualString) {
			return '''«message»expected: «expected.formatClassAndValue» but was: «actual.formatClassAndValue»'''
		} else {
			return '''«message»expected: <«expected»> but was: <«actual»>'''
		}
	}

	/**
	 * Method from {@link Assert} converted to Xtend since it is package private and not accessible.
	 */
	protected def String formatClassAndValue(Object value) {
		if (value === null) "<null>" else '''«value.class.name»<«String.valueOf(value)»>'''
	}

	/**
	 * Method from {@link Assert} converted to Xtend since it is private and not accessible.
	 */
	protected def void failEquals(String message, Object actual) {
		val formatted = '''«IF message !== null»«message»«ELSE»Values should be different«ENDIF». Actual: «actual»'''
		fail(formatted)
	}

	/**
	 * Creates a String "x element(s)" with or without a plural s, depending on the passed size.
	 * 
	 * @param size the numer of elements
	 * @return {@code 1 element} if size == 1, {@code <size> elements} otherwise
	 */
	protected def String getElementsString(int size) {
		return '''«size» element«IF size !== 1»s«ENDIF»'''
	}

}