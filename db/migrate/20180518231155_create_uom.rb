ROM::SQL.migration do
  change do
    create_table :product_uom_categories do
      primary_key :id
      String :name
      Time :created_at
      Time :updated_at
    end

    create_table :product_uom do
      primary_key :id
      foreign_key :category_id,
                  :product_uom_categories,
                  on_delete: :restrict,
                  on_update: :cascade
      String :name, null: false
      # "product_uom_factor_gt_zero" CHECK (factor <> 0::numeric)
      BigDecimal :factor, null: false
      # "product_uom_rounding_gt_zero" CHECK (rounding > 0::numeric)
      BigDecimal :rounding, null: false
      Boolean :active
      String :uom_type, null: false
      Time :created_at
      Time :updated_at
    end
  end
end
