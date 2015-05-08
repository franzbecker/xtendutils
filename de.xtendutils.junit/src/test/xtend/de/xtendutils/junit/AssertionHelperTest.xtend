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

import org.junit.Assert
import org.junit.Test

/**
 * Tests the {@link AssertionHelper}.
 * 
 * First, assertFail and assertEquals are tested which are then used to test the
 * other methods.
 */
class AssertionHelperTest {

	extension AssertionHelper = AssertionHelper.instance

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
		} catch(AssertionError error) {
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
		} catch(AssertionError error) {
			// as expected
			Assert.assertEquals("expected: <java.lang.NullPointerException> but was: <java.lang.IllegalArgumentException>", error.message)
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
		} catch(AssertionError error) {
			// as expected
			Assert.assertEquals("expected: <java.lang.IllegalArgumentException> but was: <no exception>", error.message)
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
		} catch(AssertionError error) {
			// as expected
			Assert.assertEquals("expected: <java.lang.NullPointerException> but was: <java.lang.IllegalArgumentException>", error.message)
			return
		}
		Assert.fail("Should not have reached this code")
	}
	
	/**
	 * Test assertEquals so that we can use it in future tests of this class.
	 */
	@Test
	def void testAssertEquals() {
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
	
	// TODO more tests!

}