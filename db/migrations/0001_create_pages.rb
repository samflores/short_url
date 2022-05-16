Sequel.migration do
  change do
    create_table(:pages) do
      primary_key(:id)
      String :target_url, null: false
    end
  end
end
