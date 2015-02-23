# Released under the MIT license. See the MIT-LICENSE file for details

module BatchInsert
  module ActiveRecordExtension
    module ClassMethods
      def batch_insert(opts={})
        self.batched_inserts = batched_inserts.tap do
          self.batched_inserts = []

          self.batched_insert_opts = batched_insert_opts.tap do
            self.batched_insert_opts = opts
            yield
          end

          flush_batch_insert_queue
        end
      end

      def batch_insert_values_string(column_names)
        self.batched_inserts.collect do |attributes|
          "(#{column_names.map{|n| quote_value(attributes[n], columns_hash[n])}.join(',')})"
        end.join ','
      end

      def flush_batch_insert_queue
        unless self.batched_inserts.empty?
          column_names = columns.map(&:name).sort - [primary_key]
          connection.execute %Q{
            INSERT INTO #{connection.quote_table_name(table_name)}
            (#{column_names.map{|n| connection.quote_column_name(n)}.join(',')})
            VALUES
            #{batch_insert_values_string(column_names)}
          }.gsub(/\s+/,' ').squeeze(' ').strip

          batched_inserts.clear
        end
      end

      def insert(opts={})
        new(opts).tap do |obj|
          raise ActiveRecord::RecordInvalid.new(obj) unless obj.valid?
          self.batched_inserts << obj.attributes

          limit = batched_insert_opts[:batch_size].to_i
          flush_batch_insert_queue if limit > 0 and self.batched_inserts.length >= limit
        end
      end
    end
  end

  class Railtie < Rails::Railtie
    initializer 'batch_insert.install_active_record_mixins' do
      ActiveRecord::Base.instance_eval do
        send :extend, ::BatchInsert::ActiveRecordExtension::ClassMethods
        class_attribute :batched_inserts
        class_attribute :batched_insert_opts
      end
    end
  end
end
