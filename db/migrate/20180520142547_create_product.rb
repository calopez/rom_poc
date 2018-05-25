ROM::SQL.migration do
  change do
    create_table :products do
      Serial :id
      String :name, null: false
      BigDecimal :price
      Time :created_at
      Time :updated_at
    end
  end
end
