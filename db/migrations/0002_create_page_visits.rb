# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:page_visits) do
      primary_key(:id)
      DateTime :visited_at
      foreign_key(:page_id, :pages)
    end
  end
end
