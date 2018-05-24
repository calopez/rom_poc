ROM::SQL.migration do
  change do
    create_table :product_categories do
      primary_key :id
      String :name, null: false
      Time :created_at
      Time :updated_at
    end
  end
end
