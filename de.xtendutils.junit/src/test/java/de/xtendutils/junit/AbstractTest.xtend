package de.xtendutils.junit

/**
 * Super class for all tests that provides {@link AssertionHelper}.
 */
class AbstractTest {
	
	protected extension AssertionHelper = AssertionHelper.instance
	
}