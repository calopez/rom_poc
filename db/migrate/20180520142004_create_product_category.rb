ROM::SQL.migration do
  change do
    create_table :product_categories do
      primary_key :id
      Integer :lft
      Integer :rgh
      String :name, null: false
      Integer :parent_id
      BigDecimal :price, null: false
      Time :created_at
      Time :updated_at
    end
  end
end
