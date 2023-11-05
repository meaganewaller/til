Sequel.migration do
  up do
    create_table(:learnings) do
      primary_key :id
      String :content, as: :text, null: true
    end
  end

  down do
    drop_table(:learnings)
  end
end
