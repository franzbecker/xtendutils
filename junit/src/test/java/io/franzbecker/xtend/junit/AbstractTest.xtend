package io.franzbecker.xtend.junit

/**
 * Super class for all tests that provides {@link AssertionHelper}.
 */
abstract class AbstractTest {

	protected extension AssertionHelper = AssertionHelper.instance

}
