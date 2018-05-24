require 'rom'
require 'rom-sql'

module Persistence
  module Relations
    class ProductCategoryTree < ROM::Relation[:sql]
      schema(:product_category_tree, infer: true) do
        associations do
          belongs_to :product_categories,
                     as: :descendants,
                     foreign_key: :ancestor
          belongs_to :product_categories,
                     as: :ancestors,
                     foreign_key: :descendant

        end
      end

      def generate_descendant(parent, node)
        # Using Sequel would be
        # [
        #   ancestor,
        #   Sequel.as(Sequel.expr(path_length + 1), :path_length),
        #   Sequel.as(node, :descendant)
        # ]
        self_referencing_path = proc do
          [
            `#{node}`.as(:ancestor),
            `0`.as(:path_length),
            `#{node}`.as(:descendant)
          ]
        end
        path_references = proc do
          [
            ancestor,
            `path_length + 1`.as(:path_length),
            `#{node}`.as(:descendant)
          ]
        end

        select(&path_references)
          .where(descendant: parent)
          .union(
            select(&self_referencing_path).limit(1),
            all:       true,
            from_self: false
          )
      end

      private

    end
  end
end

# rom.relations[:product_uom_categories]
# .command(:create, result: :many)
# .call([{ name: 'weight' }, { name: 'working time' }])
#
# changeset = rom.relations[:product_uom_categories]
#                 .changeset(:create, [{name: 'weight'}, {name: 'working_time'}])
#                 .map(:add_timestamps)
# changeset.commit
