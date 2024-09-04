#!/bin/bash

filename="$HOME/desktop/cde/raw/survey.csv"
echo $URL
renamed_file="$HOME/desktop/cde/transformed/renamed_file.csv"
output_directory="$HOME/desktop/cde/transformed"
output_file="$HOME/desktop/cde/transformed/cleaned_file.csv"
load_directory="$HOME/desktop/cde/gold"
load_file="$HOME/desktop/cde/transformed/new_file.csv"

if test -e "$filename"
then
    echo "file exists"
else
    echo "file does not exist"
    curl -o "$filename" "$URL"

fi

if test -e "$output_directory";
then
    echo "directory exists"
else
    mkdir "$output_directory" 
    echo "directory created successfully"
fi

sed -e "1s/Variable_code/variable_code/" "$filename" > "$renamed_file"

if test -e "$renamed_file"
then
    echo "column renamed successfully"
else
echo "error renaming column"

fi

cut  -d "," -f 1,5,6,9 "$renamed_file" > "$output_file"

if test -e "$output_file"
then
    echo "file cleaned and saved in output file"
else
    echo "error creating output file"
fi

if test -e "$load_directory";
then
    echo "load directory exists"
else
    mkdir "$load_directory"
    echo "load directory created successfully"
fi

cp "$output_file" "$load_file"

if test -e "$load_file";
then
    echo "file loaded successfully"
else
    echo "error loading file"
fi

