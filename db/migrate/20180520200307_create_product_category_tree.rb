ROM::SQL.migration do
  change do
    create_table(:product_category_tree) do
      Integer :path_length, null: false
      foreign_key :ancestor, :product_categories,
                  key: :id,
                  null: false,
                  type: Integer
      foreign_key :descendant, :product_categories,
                  key: :id,
                  null: false,
                  type: Integer
      primary_key %i[ancestor descendant], name: :product_category_tree_pk
    end
  end
end
