Batch Insert
============

This plugin adds batch insertion capabilities to ActiveRecord model classes.

The API is very similar to the standard `new` and `create` functions provided
by ActiveRecord, but will not return a saved object to the caller.


License
=======

This plugin is released under the MIT license, and was contributed to the Rails community by the good people at [Software Projects](http://www.sp.com.au)


Example
=======

**Previously:**

	100.times { ModelClass.create! :name => 'Test', :description => 'An example object being created.' }

**Now:**

	ModelClass.batch_insert do
		100.times { ModelClass.insert :name => 'Test', :description => 'An example object being created.' }
	end

**Batch insertions return the same result as new()**

	ModelClass.batch_insert do
		args = {:name => 'Test', :description => 'An example object being created.'}

		ModelClass.insert(args)					# ModelClass instance
		ModelClass.insert(args).new_record?		# true
		ModelClass.insert(args).id				# nil
	end		# The insertion is done at this point in the code.

**Invalid objects will immediately cause an exception**

	ModelClass.batch_insert do
		invalid_args = {}
		ModelClass.insert(invalid_args)			# Exception!
	end

**Constraint violations will cause an exception when the batch is inserted**

	ModelClass.batch_insert do
		conflict = {:unique_value => 'Collide!'}
		ModelClass.insert(conflict)
		ModelClass.insert(conflict)
	end		# Exception!

**Custom batch size is supported (the default is unlimited)**

    ModelClass.batch_insert :batch_size => 10 do
		# This loop will cause 3 INSERT statements
		37.times do |i|
			ModelClass.insert :name => "object #{i}", :description => "The #{i.ordinalize} object"
		end
	end     # And the last 7 objects will be inserted here.
