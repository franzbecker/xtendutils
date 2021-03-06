package io.franzbecker.xtend.lib

import io.franzbecker.xtend.junit.AssertionHelper
import org.junit.Test

import static java.util.regex.Pattern.CASE_INSENSITIVE

import static extension io.franzbecker.xtend.lib.PatternExtensions.*

/**
 * Tests for {@link PatternExtensions}.
 */
class PatternExtensionsTest {

	extension AssertionHelper = AssertionHelper.instance

	/**
	 * The compile methods are both {@link Inline inlined} so we're testing the
	 * inlined code here, not the real method call.
	 */
	@Test
	def void testCompileInlined() {
		// When
		val wsPattern = '''\s'''.compile
		val xPattern = '''x'''.compile(CASE_INSENSITIVE)

		// Then
		wsPattern.pattern.assertEquals("\\s")
		xPattern.pattern.assertEquals("x")
		xPattern.flags.assertEquals(CASE_INSENSITIVE)
	}

	@Test
	def void testMatches() {
		// Given
		val pattern = "\\s".compile

		// When + Then
		" ".matches(pattern).assertTrue
		"x".matches(pattern).assertFalse
		" x".matches(pattern).assertFalse
		null.matches(pattern).assertFalse
	}

	@Test
	def void testMatchesAny() {
		// Given
		val patterns = #["\\s".compile, "x".compile(CASE_INSENSITIVE)]
		val emptyPatterns = #[]

		// When + Then
		"x".matchesAny().assertFalse
		"x".matchesAny(emptyPatterns).assertFalse
		"x".matchesAny(patterns).assertTrue
		"X".matchesAny(patterns).assertTrue
		null.matchesAny(patterns).assertFalse
	}

	@Test
	def void testMatchesAll() {
		// Given
		val patterns = #[".".compile, ".*".compile]
		val unmatchable = #["\\s".compile, "\\S".compile]
		val emptyPatterns = #[]

		// When + Then
		" ".matchesAll(patterns).assertTrue
		" ".matchesAll(unmatchable).assertFalse
		" ".matchesAll(emptyPatterns).assertTrue
		null.matchesAll(emptyPatterns).assertFalse
	}

}
