#!/bin/bash

# Rename all pasted images
find . -type f -name "Pasted image *.png" | while read -r file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    new=$(echo "$base" | sed 's/Pasted image /pasted-image-/')
    mv "$file" "$dir/$new"
done

# Fix markdown links
find . -type f -name "*.md" | while read -r file; do
    sed -Ei \
        's|!\[\]\(Pasted%20image%20([0-9]+)\.png\)|![](images/pasted-image-\1.png)|g' \
        "$file"

    sed -Ei \
        's|!\[\[Pasted image ([0-9]+)\.png\]\]|![](images/pasted-image-\1.png)|g' \
        "$file"
done

echo "Done!"
