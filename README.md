# mls-almanac

The mls-almanac is a member of the opensport and openfootball community.  The goal is to provide query-able, historical data for Major League Soccer in the US and Canada.

This app uses the following open data sets:

* [world.db](https://github.com/openmundi/world.db.git)
* [openfootball/major-league-soccer](https://github.com/openfootball/major-league-soccer)

## Setup Instructions

To initialize the databases, run the create task:

```
$ rake create
```

To seed the database with world and season information, run the init task:

```
$ rake init
```

To update the mls data, run the update task (Note, it is recommended to delete, init, update instead of just updating)

```
$ rake update
```

To delete all entries from all tables, run the delete task

```
$ rake delete
```
