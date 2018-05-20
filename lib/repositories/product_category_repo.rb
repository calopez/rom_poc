module Persistence
  module Repo
    class ProductCategory < ROM::Repository[:product_categories]
      def create(parent_id: nil, name:)
        @parent_id = parent_id
        @name = name
        if parent_id.nil? && categories.count.zero?
          create_first_category
        elsif parent_id.nil?
          raise ArgumentError, 'Parent id cannot be nil'
        else
          create_category
        end
      end

      private

      def create_category
        categories.transaction do
          parent = categories.select(:rgt).where(id: @parent_id).one.rgt
          categories.where { rgt >= parent }
          # .dataset.update_sql
          .update(
              lft: Sequel.case(
                  { (Sequel.expr(:lft) > parent) => (Sequel.expr(:lft) + 2) },
                  :lft
              ),
              rgt: Sequel.case(
                  { (Sequel.expr(:rgt) >= parent) => (Sequel.expr(:rgt) + 2) },
                  :rgt
              )
          ) #.gsub(/\"/, "")
          categories.changeset(:create,
                               name: @name,
                               lft: parent,
                               rgt: parent + 1,
                               parent_id: @parent_id).map(:add_timestamps).commit
        end
      end

      def create_first_category
        categories.changeset(
          :create,
          lft:       1,
          rgt:       3,
          name:      @name,
          parent_id: nil
        ).map(:add_timestamps).commit
      end

      def categories
        product_categories
      end
    end
  end
end
