#!/usr/bin/env bash

post_dir="content/posts/`date '+%Y-%m-%d'`"

if [ ! -d $post_dir ]
then
  mkdir -p $post_dir
fi

name="$@"
slug=`echo $name | tr '[:upper:]' '[:lower:]' | sed -E 's/ +/-/g'`

filename="$post_dir/$slug.md"

echo "+++" >> $filename
echo "date = \"$(date '+%FT%T%:z')\"" >> $filename
echo "draft = false" >> $filename
echo "title = \"$name\"" >> $filename
echo "slug = \"$slug\"" >> $filename
echo "tags = []" >> $filename
echo "categories = []" >> $filename
echo "+++" >> $filename
echo "Created file $filename"

