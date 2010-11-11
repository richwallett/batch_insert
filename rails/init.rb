require 'batch_insert'

ActiveRecord::Base.send :include, ActiveRecord::BatchInsert
