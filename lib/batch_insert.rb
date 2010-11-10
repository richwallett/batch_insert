# Released under the MIT license. See the MIT-LICENSE file for details
module ActiveRecord
  module BatchInsert
    def self.included(base)
      base.class_inheritable_accessor :batched_inserts
      base.extend ClassMethods
    end

    module ClassMethods
      def batch_insert
        self.batched_inserts = returning(batched_inserts) do
          self.batched_inserts = []
          yield

          unless self.batched_inserts.empty?
            column_names = columns.map(&:name).sort - [primary_key]
            connection.execute %Q{
              INSERT INTO #{connection.quote_table_name(table_name)}
              (#{column_names.map{|n| connection.quote_column_name(n)}.join(',')})
              VALUES
              #{batch_insert_values_string(column_names)}
            }.gsub(/\s+/,' ').squeeze(' ').strip
          end
        end
      end

      def batch_insert_values_string(column_names)
        self.batched_inserts.collect do |attributes|
          "(#{column_names.map{|n| attributes[n]}.collect{|v|quote_value(v)}.join(',')})"
        end.join ','
      end

      def insert(opts={})
        returning new(opts) do |obj|
          raise RecordInvalid.new(obj) unless obj.valid?
          self.batched_inserts << obj.attributes
        end
      end
    end
  end
end
