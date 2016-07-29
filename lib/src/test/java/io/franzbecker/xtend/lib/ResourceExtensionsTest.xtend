package io.franzbecker.xtend.lib

import com.google.common.base.Strings
import com.google.common.io.Files
import io.franzbecker.xtend.junit.AssertionHelper
import java.io.File
import java.util.UUID
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

import static java.nio.charset.StandardCharsets.*

import static extension io.franzbecker.xtend.lib.ResourceExtensions.*

class ResourceExtensionsTest {

	static val HELLO_WORLD = '你好世界'

	@Rule public val tempFolder = new TemporaryFolder
	extension AssertionHelper = AssertionHelper.instance

	@Test
	def void getText() {
		// given
		val file = tempFolder.newFile('test.txt')
		Files.newWriter(file, UTF_8).append(HELLO_WORLD).close

		// expect
		file.text.assertEquals(HELLO_WORLD)
	}

	@Test
	def void setTextOnNonExistingFile() {
		// given
		val file = new File(tempFolder.root, 'text.txt')
		file.exists.assertFalse

		// when
		file.text = HELLO_WORLD

		// then
		file.text.assertEquals(HELLO_WORLD)
	}

	@Test
	def void setTextOnPrefilledFile() {
		// given
		val file = tempFolder.newFile('test.txt')
		Files.newWriter(file, UTF_8).append(UUID.randomUUID.toString).close

		// when
		file.text = HELLO_WORLD

		// then
		file.text.assertEquals(HELLO_WORLD)
	}

	@Test
	def void appendOnNonExistingFile() {
		// given
		val file = new File(tempFolder.root, 'text.txt')
		file.exists.assertFalse

		// when
		file << HELLO_WORLD

		// then
		file.text.assertEquals(HELLO_WORLD)
	}

	@Test
	def void appendOnExistingButEmptyFile() {
		// given
		val file = tempFolder.newFile('test.txt')

		// when
		file << HELLO_WORLD

		// then
		file.text.assertEquals(HELLO_WORLD)
	}

	@Test
	def void appendMultipleTimes() {
		// given
		val file = tempFolder.newFile('test.txt')

		// when
		file << HELLO_WORLD
		file << HELLO_WORLD << HELLO_WORLD

		// then
		file.text.assertEquals(Strings.repeat(HELLO_WORLD, 3))
	}

}
