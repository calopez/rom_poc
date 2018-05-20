ROM::SQL.migration do
  change do
    create_table :products do
      primary_key :id
      String :name, null: false
      BigDecimal :price
      Time :created_at
      Time :updated_at
    end
  end
end
