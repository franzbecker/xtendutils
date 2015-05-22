package de.xtendutils.lib

import de.xtendutils.junit.AssertionHelper
import de.xtendutils.lib.extensions.PatternExtensions
import org.junit.Test

import static java.util.regex.Pattern.CASE_INSENSITIVE

import static extension de.xtendutils.lib.extensions.PatternExtensions.*

/**
 * Tests for {@link PatternExtensions}.
 */
class PatternExtensionsTest {
	
	extension AssertionHelper = AssertionHelper.instance
	
	@Test
	def void testCompile() {
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
	
}