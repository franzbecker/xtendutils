package de.xtendutils.lib.extensions;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Nullable;
import javax.annotation.ParametersAreNonnullByDefault;

import org.eclipse.xtext.xbase.lib.Inline;
import org.eclipse.xtext.xbase.lib.Pure;

/**
 * This is an extension library for {@link Pattern}.
 */
@ParametersAreNonnullByDefault
public class PatternExtensions {

	/**
	 * Returns a compiled {@link Pattern} with the given regex.
	 * In contrast to {@link Pattern#compile(String)} passing {@link CharSequence} is supported.
	 * 
	 * @param regex a {@link CharSequence}, may not be {@code null}.
	 * @return the compiled {@link Pattern}.
	 */
	@Pure
	@Inline(value="Pattern.compile($1.toString())", imported=Pattern.class)
	public static Pattern compile(CharSequence regex) {
		return Pattern.compile(regex.toString());
	}
	
	/**
	 * Returns a compiled {@link Pattern} with the given regex and flags.
	 * In contrast to {@link Pattern#compile(String, int)} passing {@link CharSequence} is supported.
	 * 
	 * @param regex a {@link CharSequence}, may not be {@code null}.
	 * @param flags see {@link Pattern#compile(String, int)}.
	 * @return the compiled {@link Pattern}.
	 */
	@Pure
	@Inline(value="Pattern.compile($1.toString(), $2)", imported=Pattern.class)
	public static Pattern compile(CharSequence regex, int flags) {
		return Pattern.compile(regex.toString(), flags);
	}
	
	/**
	 * Returns {@code true} if the pattern matches against the input, {@code false} if not
	 * or if the input was {@code null}.
	 * <p/>
	 * Method is null-safe for the passed character sequence, pattern may not be {@code null}.
	 * 
	 * @param input the character sequence to be matched, may be {@code null}.
	 * @param pattern the pattern to be matched against, may not be {@code null}. 
	 * @return {@code true} if the pattern matches against the input, {@code false} if not
	 * 			or if the input was {@code null}.
	 */
	public static boolean matches(@Nullable CharSequence input, Pattern pattern) {
		if (input == null) {
			return false;
		}
		Matcher matcher = pattern.matcher(input);
		return matcher.find();
	}
	
	/**
	 * Returns {@code true} if any of the given patterns matches against the input, {@code false}
	 * if none matches, the input was {@code null} or the list patterns was empty.
	 * <p/>
	 * Method is null-safe for the passed character sequence, pattern may not be {@code null}.
	 * 
	 * @param input the character sequence to be matched, may be {@code null}.
	 * @param patterns the pattern to be matched against, may not be {@code null}. 
	 * @return {@code true} if any of the given patterns matches against the input, {@code false}
	 * 			if none matches, the input was {@code null} or the list patterns was empty.
	 */
	public static boolean matchesAny(@Nullable CharSequence input, Pattern... patterns) {
		if (input == null) {
			return false;
		}
		for (Pattern pattern : patterns) {
			Matcher matcher = pattern.matcher(input);
			if (matcher.find()) {
				return true;
			}
		}
		return false;
	}
	
}
