<?php

/**
 * Copyright (c) 2013 Robin Appelman <icewind@owncloud.com>
 * This file is licensed under the Affero General Public License version 3 or
 * later.
 * See the COPYING-README file.
 */

namespace Test\Session;

abstract class Session extends \Test\TestCase {
	/**
	 * @var \OC\Session\Session
	 */
	protected $instance;

	protected function tearDown() {
		$this->instance->clear();
		parent::tearDown();
	}

	public function testNotExistsEmpty() {
		$this->assertFalse($this->instance->exists('foo'));
	}

	public function testExistsAfterSet() {
		$this->instance->set('foo', 1);
		$this->assertTrue($this->instance->exists('foo'));
	}

	public function testNotExistsAfterRemove() {
		$this->instance->set('foo', 1);
		$this->instance->remove('foo');
		$this->assertFalse($this->instance->exists('foo'));
	}

	public function testGetNonExisting() {
		$this->assertNull($this->instance->get('foo'));
	}

	public function testGetAfterSet() {
		$this->instance->set('foo', 'bar');
		$this->assertEquals('bar', $this->instance->get(('foo')));
	}

	public function testRemoveNonExisting() {
		$this->assertFalse($this->instance->exists('foo'));
		$this->instance->remove('foo');
		$this->assertFalse($this->instance->exists('foo'));
	}

	public function testNotExistsAfterClear() {
		$this->instance->set('foo', 1);
		$this->instance->clear();
		$this->assertFalse($this->instance->exists('foo'));
	}

	public function testArrayInterface() {
		$this->assertArrayNotHasKey('foo', $this->instance);
		$this->instance['foo'] = 'bar';
		$this->assertArrayHasKey('foo', $this->instance);
		$this->assertEquals('bar', $this->instance['foo']);
		unset($this->instance['foo']);
		$this->assertArrayNotHasKey('foo', $this->instance);
		echo "In tests/lib/Session/SessionTest\n";
		echo "memory_get_usage " . \memory_get_usage() . "\n";
		echo "memory_get_peak_usage " . \memory_get_peak_usage() . "\n";
	}
}
