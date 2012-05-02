# Strategies

* none
    Deletes record, as with usual destroy method.
* column
    Updates deleted_at column of the record. This is default strategy,
    if undestroyable is activated for model.
* table
    Move table into separate column
* database
    Move table into separate database

# Options:

* table_name
    Same as model table.
* table_suffix
    Default prefix is: deleted
* full_table_name
    table_prefix + table_name + table_suffix.

# Simple usage example:

    class Bill < ActiveRecord::Base
      undestroyable
    end

# Complicated usage example:

    class ConceptCat < ActiveRecord::Base
      undstroyable do
        startegy :database
        connection { adapter: "sqlite3", dbfile: ":memory:"}
        table_name :scrap
        table_suffix :metalic
      end
    end