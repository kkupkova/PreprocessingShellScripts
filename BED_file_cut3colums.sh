#!/bin/bash
# go through all bed files and tak only the first 3 columns
mkdir threeColumns
for f in *.bed
 do  
   cut -f1-3 < "$f" > "threeColumns/${f}"
done

