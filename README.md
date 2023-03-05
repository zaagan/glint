# Glint Cheat Sheet

Glint is a command-line application that allows you to create, edit, and access your own cheat sheet for programming languages, frameworks, or anything else you might want to keep track of. You can add cheats with a name, description, and code snippet, and then easily search for and view them later.


&nbsp;

## Installation

1. Clone the repository:

```
  git clone https://github.com/YOUR_USERNAME/glint.git
```

2. Navigate to the project directory:

```
cd glint
```


3. Install dependencies using Bundler:
```
bundle install
```


&nbsp;

## Usage

### Initializing the database

Before you can use Glint, you need to initialize the database:

```
bin/glint init
```


This will create a SQLite database file named `glint.db` in the `db` directory.


&nbsp;
### Adding a cheat

To add a cheat, use the `add` command with the cheat's name, description, and code snippet:


```
bin/glint add "Create table" "Create a new table in SQL" "CREATE TABLE table_name (
column1 datatype,
column2 datatype,
...
);"

```


&nbsp;
### Listing cheats

To list all cheats, use the `list` command:

```
bin/glint list
```


This will display a table of all cheats currently stored in the database.


&nbsp;

### Searching for cheats

To search for a cheat, use the `search` command with a search term:

```
bin/glint search "table"
```


This will display a table of all cheats that include the search term "table" in either the name or description.


&nbsp;
### Updating a cheat

To update a cheat, use the `update` command with the cheat's ID, new name, and new code snippet:

```
bin/glint update 1 "Create a new table in SQL" "CREATE TABLE table_name (
column1 datatype,
column2 datatype,
...
);"
```


This will update the cheat with ID 1 to have the new name and code snippet.

&nbsp;
### Deleting a cheat

To delete a cheat, use the `delete` command with the cheat's ID:

```
bin/glint delete 1
```



This will delete the cheat with ID 1 from the database.

&nbsp;
## Technical details

- Glint is built using Ruby and SQLite, with the `sqlite3` and `terminal-table` gems for database management and table formatting, respectively.
- The `bin` directory contains executable scripts for adding, listing, searching, updating, and deleting cheats. These scripts call methods defined in `lib/glint.rb` to interact with the database.
- The `lib` directory contains the main Glint class and a module for colorizing output.
- The database schema is defined in `db/schema.sql`, and the database itself is created and managed using `db/database.rb`.


&nbsp;
## License

This project is licensed under the [MIT License](LICENSE).
