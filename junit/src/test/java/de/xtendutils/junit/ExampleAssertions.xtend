package de.xtendutils.junit

import java.math.BigDecimal
import org.junit.Test

/**
 * Simple examples on how {@link AssertionHelper} can be used.
 */
class ExampleAssertions extends AbstractTest {
	
	@Test
	def void testEqualsAndSame() {
		val x = "x"
		val y = "y"
		x.assertEquals("x")
		x.assertNotEquals(y)
		x.assertSame(x)
		x.assertNotSame(y)
	}
	
	@Test
	def void testIterable() {
		#[].assertEmpty
		#["test"].assertSingleElement => [
			assertEquals("test")
		]
	}
	
	@Test
	def void testInstanceOf() {
		val Object obj = new String("test")
		obj.assertInstanceOf(String).length.assertEquals(4)
	}
	
	@Test
	def void testLambda() {
		val divide = [BigDecimal it, BigDecimal divisor | it.divide(divisor)]
		
		[divide.apply(1bd, 0bd)].assertFail(ArithmeticException) => [
			message.assertEquals("Division by zero")
		]
	}
	
}