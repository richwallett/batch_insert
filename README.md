Batch Insert
============

This plugin adds batch insertion capabilities to ActiveRecord model classes.

The API is very similar to the standard `new` and `create` functions provided
by ActiveRecord, but will not return a saved object to the caller.


Example
=======

Previously:
-----------

	100.times { ModelClass.create! :name => 'Test', :description => 'An example object being created.' }

Now:
----

	ModelClass.batch_insert do
		100.times { ModelClass.insert :name => 'Test', :description => 'An example object being created.' }
	end

Batch insertions return the same result as new()
------------------------------------------------

	ModelClass.batch_insert do
		args = {:name => 'Test', :description => 'An example object being created.'}

		ModelClass.insert(args)					# ModelClass instance
		ModelClass.insert(args).new_record?		# true
		ModelClass.insert(args).id				# nil
	end		# The insertion is done at this point in the code.

Invalid objects will immediately cause an exception
---------------------------------------------------

	ModelClass.batch_insert do
		invalid_args = {}
		ModelClass.insert(invalid_args)			# Exception!
	end

Constraint violations will cause an exception when the batch is inserted
------------------------------------------------------------------------

	ModelClass.batch_insert do
		conflict = {:unique_value => 'Collide!'}
		ModelClass.insert(args)
		ModelClass.insert(args)
	end		# Exception!

Copyright (c) 2010 Shaun Mangelsdorf, released under the MIT license
