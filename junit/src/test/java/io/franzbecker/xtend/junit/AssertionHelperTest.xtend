/*******************************************************************************
 * Copyright (c) 2013-2016 Franz Becker and others.
 * GitHub repository: https://github.com/franzbecker/xtendutils
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package io.franzbecker.xtend.junit

import java.math.BigDecimal
import java.util.Optional
import org.junit.Assert
import org.junit.Test

/**
 * Tests the {@link AssertionHelper}.
 * 
 * First, assertFail and assertEquals are tested which are then used to test the
 * other methods.
 */
class AssertionHelperTest extends AbstractTest {

	/**
	 * Trick the compiler.
	 * @throws IllegalArgumentException always
	 */
	protected def void throwIllegalArgumentException() {
		throw new IllegalArgumentException
	}

	/**
	 * Test {@code assertFail} with failing and non-failing procedures.
	 */
	@Test
	def void testAssertFailWithProcedure() {
		// Given
		val (Object)=>void failingProcedure = [throwIllegalArgumentException]
		val (Object)=>void nonFailingProcedure = []

		// When + Then
		failingProcedure.assertFail(IllegalArgumentException)
		try {
			nonFailingProcedure.assertFail(IllegalArgumentException)
		} catch (AssertionError error) {
			// as expected
			Assert.assertEquals("expected: <java.lang.IllegalArgumentException> but was: <no exception>", error.message)
			return
		}
		Assert.fail("Should not have reached this code")
	}

	/**
	 * Test {@code assertFail} with a failing procedure, but wrongly expected exception.
	 */
	@Test
	def void testAssertFailWithProcedureWrongException() {
		// Given
		val (Object)=>void failingProcedure = [throwIllegalArgumentException]

		// When + Then
		try {
			failingProcedure.assertFail(NullPointerException)
		} catch (AssertionError error) {
			// as expected
			Assert.assertEquals(
				"expected: <java.lang.NullPointerException> but was: <java.lang.IllegalArgumentException>",
				error.message)
				return
			}
			Assert.fail("Should not have reached this code")
		}

		/**
		 * Test {@code assertFail} with failing and non-failing functions.
		 */
		@Test
		def void testAssertFailWithFunction() {
			// Given
			val (Object)=>Object failingFunction = [
				throwIllegalArgumentException
				return true
			]
			val (Object)=>Object nonFailingFunction = []

			// When + Then
			failingFunction.assertFail(IllegalArgumentException)
			try {
				nonFailingFunction.assertFail(IllegalArgumentException)
			} catch (AssertionError error) {
				// as expected
				Assert.assertEquals("expected: <java.lang.IllegalArgumentException> but was: <no exception>",
					error.message)
				return
			}
			Assert.fail("Should not have reached this code")
		}

		/**
		 * Test {@code assertFail} with a failing function, but wrongly expected exception.
		 */
		@Test
		def void testAssertFailWithFunctionWrongException() {
			// Given
			val (Object)=>Object failingFunction = [
				throwIllegalArgumentException
				return true
			]

			// When + Then
			try {
				failingFunction.assertFail(NullPointerException)
			} catch (AssertionError error) {
				// as expected
				Assert.assertEquals(
					"expected: <java.lang.NullPointerException> but was: <java.lang.IllegalArgumentException>",
					error.message)
					return
				}
				Assert.fail("Should not have reached this code")
			}

			/**
			 * Test assertEquals so that we can use it in future tests of this class.
			 */
			@Test
			def void testAssertEqualsObject() {
				// Given
				val x = "x"
				val y = "y"

				// When + Then
				[x.assertEquals(y)].assertFail(AssertionError) => [
					Assert.assertEquals("expected:<[y]> but was:<[x]>", message)
				]
				x.assertEquals(x)
			}

			/**
			 * Test assertEmpty with null, empty and non-empty iterables.
			 */
			@Test
			def void testAssertEmpty() {
				// Given
				val nullIterable = null
				val oneElement = #["hello"]
				val twoElements = #["hello", "xtend"]
				val emptyIterable = #[]

				// When + Then
				[nullIterable.assertEmpty].assertFail(AssertionError) => [
					message.assertEquals("expected: <empty iterable> but was: <>")
				]
				[oneElement.assertEmpty].assertFail(AssertionError) => [
					message.assertEquals("expected: <empty iterable> but was: <1 element>")
				]
				[twoElements.assertEmpty("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <empty iterable> but was: <2 elements>")
				]
				emptyIterable.assertEmpty
			}

			/**
			 * Test assertNotEmpty with null, empty and non-empty iterables.
			 */
			@Test
			def void testAssertNotEmpty() {
				// Given
				val nullIterable = null
				val emptyIterable = #[]
				val oneElement = #["hello"]

				// When + Then
				[nullIterable.assertNotEmpty].assertFail(AssertionError) => [
					message.assertEquals("expected: <non-empty iterable> but was: <>")
				]
				[emptyIterable.assertNotEmpty].assertFail(AssertionError) => [
					message.assertEquals("expected: <non-empty iterable> but was: <empty>")
				]
				[emptyIterable.assertNotEmpty("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <non-empty iterable> but was: <empty>")
				]
				oneElement.assertNotEmpty
			}

			/**
			 * Test assertSize with null, empty and non-empty iterables.
			 */
			@Test
			def void testAssertSize() {
				// Given
				val nullIterable = null
				val emptyIterable = #[]
				val oneElement = #["hello"]
				val twoElements = #["hello", "world"]

				// When + Then
				[nullIterable.assertSize(5)].assertFail(AssertionError) => [
					message.assertEquals("expected: <5 elements> but was: <>")
				]
				emptyIterable.assertSize(0);
				[emptyIterable.assertSize(1)].assertFail(AssertionError) => [
					message.assertEquals("expected: <1 element> but was: <0 elements>")
				]
				oneElement.assertSize(1);
				[oneElement.assertSize(3)].assertFail(AssertionError) => [
					message.assertEquals("expected: <3 elements> but was: <1 element>")
				]
				twoElements.assertSize(2);
				[twoElements.assertSize(99, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <99 elements> but was: <2 elements>")
				]
			}

			/**
			 * Test assertSingleElement with null, empty and non-empty iterables.
			 */
			@Test
			def void testAssertSingleElement() {
				// Given
				val nullIterable = null
				val emptyIterable = #[]
				val hello = "hello"
				val oneElement = #[hello]
				val twoElements = #[hello, "world"]

				// When + Then
				[nullIterable.assertSingleElement].assertFail(AssertionError) => [
					message.assertEquals("expected: <1 element> but was: <>")
				]
				[emptyIterable.assertSingleElement].assertFail(AssertionError) => [
					message.assertEquals("expected: <1 element> but was: <0 elements>")
				]
				[twoElements.assertSingleElement].assertFail(AssertionError) => [
					message.assertEquals("expected: <1 element> but was: <2 elements>")
				]
				oneElement.assertSingleElement.assertSame(hello)
			}

			/**
			 * Tests assertEquals and assertNotEquals with long, float and double values. 
			 * Those are delegated to {@link Assert}.
			 */
			@Test
			def void testAssertEqualsNumeric() {
				// assertEquals(long, long)
				0.assertEquals(0)
				0l.assertEquals(0l);
				[0.assertEquals(5)].assertFail(AssertionError) => [
					message.assertEquals("expected:<5> but was:<0>")
				]
				[0.assertEquals(5, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected:<5> but was:<0>")
				]

				// assertNotEquals(long, long)
				2.assertNotEquals(5);
				[3.assertNotEquals(3)].assertFail(AssertionError) => [
					message.assertEquals("Values should be different. Actual: 3")
				]
				[3.assertNotEquals(3, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops. Actual: 3")
				]

				// assertEquals(float, float, delta)
				5f.assertEquals(5f, 0f)
				5f.assertEquals(5.2f, 0.2f);
				[5f.assertEquals(6f, 0f)].assertFail(AssertionError) => [
					message.assertEquals("expected:<6.0> but was:<5.0>")
				]
				[5f.assertEquals(6f, 0f, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected:<6.0> but was:<5.0>")
				]

				// assertNotEquals(float, float, delta)
				5f.assertNotEquals(6f, 0f);
				[5f.assertNotEquals(6f, 1f)].assertFail(AssertionError) => [
					message.assertEquals("Values should be different. Actual: 5.0")
				]
				[5f.assertNotEquals(6f, 1f, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops. Actual: 5.0")
				]

				// assertEquals(double, double, delta)
				7d.assertEquals(7d, 0d)
				7d.assertEquals(7.2d, 0.21d);
				[7d.assertEquals(7.2d, 0.2d)].assertFail(AssertionError) => [
					message.assertEquals("expected:<7.2> but was:<7.0>")
				]
				[7d.assertEquals(7.2d, 0.2d, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected:<7.2> but was:<7.0>")
				]

				// assertNotEquals(double, double, delta)
				7d.assertNotEquals(8d, 0d);
				[7d.assertNotEquals(7d, 1d)].assertFail(AssertionError) => [
					message.assertEquals("Values should be different. Actual: 7.0")
				]
				[7d.assertNotEquals(8d, 1d, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops. Actual: 7.0")
				]
			}

			/**
			 * Tests assertEquals and assertNotEquals for BigDecimal.
			 */
			@Test
			def void testAssertEqualsBigDecimal() {
				// Given
				val x = new BigDecimal("5.1")
				val y = new BigDecimal("6.1")

				// When + Then
				x.assertEquals(x);
				[x.assertEquals(y)].assertFail(AssertionError) => [
					message.assertEquals("expected: <6.1> but was: <5.1>")
				]
				[x.assertEquals(y, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <6.1> but was: <5.1>")
				]
				x.assertNotEquals(y);
				[x.assertNotEquals(x, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops. Actual: 5.1")
				]
			}

			/**
			 * Tests the assertInstanceOf method.
			 */
			@Test
			def void testAssertInstanceOf() {
				// Given
				val x = "x"

				// When + Then
				x.assertInstanceOf(String)
				x.assertInstanceOf(Object);
				[x.assertInstanceOf(Integer)].assertFail(AssertionError) => [
					message.assertEquals("expected: <java.lang.Integer> but was: <java.lang.String>")
				]
				[x.assertInstanceOf(null)].assertFail(IllegalArgumentException) => [
					message.assertEquals("The passed type may not be null.")
				]
				[null.assertInstanceOf(String, "Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <java.lang.String> but was: <>")
				]
			}

			/**
			 * Test the converted format & formatClassAndValue methods.
			 */
			@Test
			def void testFormat() {
				// When + Then
				format(null, "actual", "expected").assertEquals("expected: <expected> but was: <actual>")
				format("", "actual", "expected").assertEquals("expected: <expected> but was: <actual>")
				format("message", "actual", "expected").assertEquals("message expected: <expected> but was: <actual>")
				format("message", 5, new BigDecimal("5")).assertEquals(
					"message expected: java.math.BigDecimal<5> but was: java.lang.Integer<5>")
			}

			/**
			 * Test the chaining for assertEquals and assertNotEquals.
			 */
			@Test
			def void testChainingAssertEquals() {
				// Given
				val aLong = 1l
				val aFloat = 2f
				val aDouble = 3d
				val aBigDecimal = 4bd
				val anObject = new Object

				// When + Then
				// assertEquals
				assertTrue(aLong.assertEquals(aLong) === aLong)
				assertTrue(aFloat.assertEquals(aFloat, 0f) === aFloat)
				assertTrue(aDouble.assertEquals(aDouble, 0d) === aDouble)
				aBigDecimal.assertEquals(aBigDecimal).assertSame(aBigDecimal)
				anObject.assertEquals(anObject).assertSame(anObject)

				// assertNotEquals
				assertTrue(aLong.assertNotEquals(-1) === aLong)
				assertTrue(aFloat.assertNotEquals(-1f, 0f) === aFloat)
				assertTrue(aDouble.assertNotEquals(-1f, 0d) === aDouble)
				aBigDecimal.assertNotEquals(-1bd).assertSame(aBigDecimal)
				anObject.assertNotEquals(new Object).assertSame(anObject)
			}

			@Test
			def void testAssertNullAndAssertNotNull() {
				// Given
				val obj = "xyz"

				// When + Then
				null.assertNull;
				[obj.assertNull("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <null> but was: <xyz>")
				]
				obj.assertNotNull.assertSame(obj); // test chaining as well
				[null.assertNotNull("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <non-null> but was: <null>")
				]
			}

			@Test
			def void testAssertAbsentAndPresent() {
				// Given 
				val present = Optional.of("x")
				val absent = Optional.empty

				// When + Then
				present.assertPresent
				absent.assertAbsent;
				[present.assertAbsent("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <Optional.empty> but was: <x>")
				]
				[absent.assertPresent("Oops")].assertFail(AssertionError) => [
					message.assertEquals("Oops expected: <a value> but was: <Optional.empty>")
				]
			}

		// TODO more tests!
		}
		