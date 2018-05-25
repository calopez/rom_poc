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

      def unordered
        order(nil)
      end

      def descendants(parent_id:)
        where(ancestor: parent_id)
      end

      def all_descendants
        exclude(path_length: 0)
      end

      def parent
        exclude(ancestor: all_descendants.pluck(:descendant)).limit(1)
      end

      def tree
        select do
          [ancestor.as(:node),
           string.string_agg(string.cast(descendant), '.').as(:descendants)]
        end
          .where(path_length: 1)
          .group(:ancestor).unordered
      end

      def remove(id)
        where(ancestor: id).changeset(:delete).commit
      end

      def generate(parent_id:, child_id:)

        if limit(1).count.zero?
          return [{ path_length: 0, ancestor: parent_id, descendant: child_id }]
        end

        self_referencing_path = proc do
          [
            `#{child_id}`.as(:ancestor),
            `0`.as(:path_length),
            `#{child_id}`.as(:descendant)
          ]
        end
        path_references = proc do
          [
            ancestor,
            `path_length + 1`.as(:path_length),
            `#{child_id}`.as(:descendant)
          ]
        end
        select(&path_references)
          .where(descendant: parent_id)
          .union(
            select(&self_referencing_path).limit(1),
            all:       true,
            from_self: false
          )
      end
    end
  end
end
