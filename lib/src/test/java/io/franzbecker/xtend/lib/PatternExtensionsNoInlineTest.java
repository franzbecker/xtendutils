package io.franzbecker.xtend.lib;

import static io.franzbecker.xtend.lib.PatternExtensions.compile;
import static java.util.regex.Pattern.CASE_INSENSITIVE;
import static org.assertj.core.api.Assertions.assertThat;

import java.util.regex.Pattern;

import org.junit.Test;

/**
 * Perform the tests for methods the Xtend compiler will inline here as well in
 * order to check if the implementation is correct.
 */
public class PatternExtensionsNoInlineTest {

    @Test
    public void testCompile() {
        // When
        Pattern wsPatternString = compile("\\s");
        Pattern xPatternString = compile("x", CASE_INSENSITIVE);
        Pattern wsPatternCharSeq = compile(new StringBuilder().append("\\s"));
        Pattern xPatternCharSeq = compile(new StringBuilder().append("x"), CASE_INSENSITIVE);

        // Then
        assertThat(wsPatternString.pattern()).isEqualTo("\\s");
        assertThat(xPatternString.pattern()).isEqualTo("x");
        assertThat(xPatternString.flags()).isEqualTo(CASE_INSENSITIVE);
        assertThat(wsPatternCharSeq.pattern()).isEqualTo("\\s");
        assertThat(xPatternCharSeq.pattern()).isEqualTo("x");
    }

}
