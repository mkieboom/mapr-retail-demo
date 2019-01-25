#!/bin/bash

# Import the Streamsets pipeline
/opt/streamsets-datacollector-*/bin/streamsets cli -U http://localhost:18630 -u admin -p admin store import -n mapr_retail_demo -f "/data/import_pipelines/mapr_retail_demo.json"

# Start the pipeline
/opt/streamsets-datacollector-*/bin/streamsets cli -U http://localhost:18630 -u admin -p admin manager start -n mapr_retail_demo