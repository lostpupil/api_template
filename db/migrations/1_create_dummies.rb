Sequel.migration do
  change do
    create_table(:dummies) do
      primary_key :id
      String :name
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
