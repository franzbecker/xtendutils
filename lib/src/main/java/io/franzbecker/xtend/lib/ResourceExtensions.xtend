package io.franzbecker.xtend.lib

import com.google.common.annotations.Beta
import com.google.common.io.Files
import java.io.File
import java.nio.file.Path
import javax.annotation.ParametersAreNonnullByDefault

import static java.nio.charset.StandardCharsets.UTF_8
import static java.nio.file.StandardOpenOption.*

@Beta
@ParametersAreNonnullByDefault
class ResourceExtensions {

	static def Path <<(Path path, CharSequence text) {
		return java.nio.file.Files.write(path, text.toString.getBytes(UTF_8), CREATE, APPEND)
	}

	static def File <<(File file, CharSequence text) {
		file.toPath << text
		return file
	}

	static def void setText(Path path, CharSequence text) {
		setText(path.toFile, text)
	}

	static def void setText(File file, CharSequence text) {
		val writer = Files.newWriter(file, UTF_8)
		try {
			writer.append(text)
		} finally {
			writer.close
		}
	}

	static def getText(Path path) {
		return path.toFile.text
	}

	static def getText(File file) {
		Files.toString(file, UTF_8)
	}

}
