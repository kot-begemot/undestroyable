# General [![Build Status](https://secure.travis-ci.org/kot-begemot/undestroyable.png?branch=master)](http://travis-ci.org/kot-begemot/undestroyable)

An aim for this gem is to provide an agile and comfortable way for Ruby developers to get rid of unnecessary data within their project databases.
Weather I succeed with it or not is up to you. I will appreciate any advice or help.

# System Configuration

  In order to setup system configuration add somewhere in project following code

    require 'undestroyable'

    Undestroyable.config.setup do
      orm :active_record
    end

  After that you may activate undestroyable for specific model

    class Country < ActiveRecord::Base
      undestroyable
    end

  Default strategy is: :column. You may overwrite system strategy by providing a block to `undestroyable`

    class Country < ActiveRecord::Base
      undestroyable do
        strategy :dump
      end
    end

  That will save objects dump into 'dump' table.
  There is also a possibility for setting default system starategy:

    Undestroyable.config.setup do
      orm :active_record
      strategy :table
      table_suffix :old
    end

    class Country < ActiveRecord::Base
      undestroyable
    end

  That will move deleted record from 'countries' table into 'countries_deleted'. In case 'countries_deleted' contains 'deleted_at' filed it will be updated.
  If, due to some reason, a different table name is required it can also be provided:

    Undestroyable.config.setup do
      orm :active_record
      strategy :table
      table_suffix :old
    end

    class Country < ActiveRecord::Base
      undestroyable do
        table_name :scrap
      end
    end

  In that case, the record will be moved from 'countries' table into 'scrap_deleted'.

# Options:

* orm (*ONLY FOR SYSTEM CONFIG*)
    Specifies which orm is used by project
* strategy
    Specifies which strategy should be used
* table_name
    Same as model table.
* table_suffix
    Default prefix is: deleted
* full_table_name
    table_prefix + table_name + table_suffix.
* connection
    Keeps connection information. _NB!_ Compulsary for :database startegy.

# Strategies

* none
    Deletes record, as with usual destroy method.
* column
    Updates deleted_at column of the record. This is default strategy,
    if undestroyable is activated for model.
* table
    Move record into separate table
* database
    Move record into separate table in remote database

# Simple usage example:

    class Bill < ActiveRecord::Base
      undestroyable
    end

# Complicated usage example:

    class ConceptCat < Vehicle
      undstroyable do
        startegy :database
        connection { adapter: "sqlite3", dbfile: ":memory:"}
        table_name :scrap
        table_suffix :metalic
      end
    end
