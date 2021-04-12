#!/bin/bash
for value in {0..10299}
do
    echo "starting run '$value'"
    python Run.py Experiment_list.csv $value 
    echo "finished run '$value'"
done

echo All Done
