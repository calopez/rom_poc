ROM::SQL.migration do
  change do
    create_table :product_categories do
      Serial :id
      String :name, null: false
      Time :created_at
      Time :updated_at
    end
  end
end
