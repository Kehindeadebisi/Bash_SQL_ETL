#!/bin/bash

DB_NAME="posey"
echo $DB_USER
DB_HOST="localhost"
DB_PORT="5432"
echo $CSV_DIR

# checking if database exists
psql -h $DB_HOST -U $DB_USER -d postgres -c "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Function to determine the data type of a column
infer_column_type() {
    local column_data=("$@")
    local column_type="VARCHAR(255)" 

    # Checking if the column has only integers
    if [[ "${column_data[@]}" =~ ^[0-9]+$ ]]; then
        column_type="INTEGER"
    fi

    # Checking if the column has date-like values
    if [[ "${column_data[@]}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        column_type="DATE"
    fi

    echo "$column_type"
}

# Looping through each CSV file in the directory
for csv_file in "$CSV_DIR"/*.csv
do
    # Extracting table name from CSV file
    table_name=$(basename "$csv_file" .csv)

    echo "Processing $csv_file and creating table $table_name"

    header=$(head -n 1 "$csv_file")

    # Splitting the header into individual column names
    IFS=',' read -ra columns <<< "$header"

    # checking the first 10 rows of the CSV to infer column types
    sample_data=$(tail -n +2 "$csv_file" | head -n 10)

    # dynamically creating tables
    create_table_stmt="CREATE TABLE IF NOT EXISTS $table_name ("

    # Looping over each column in the header
    for i in "${!columns[@]}"; do
        col="${columns[$i]}"

        # Extracting data for this column from the sample rows
        column_data=($(echo "$sample_data" | cut -d ',' -f $(($i + 1))))

      
        column_type=$(infer_column_type "${column_data[@]}")

       
        create_table_stmt
