#!/bin/bash

jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"MAIN": {"groups": {"dell":.[1]}}}}}}}' sys_config_block.json ./dell.json >& consum_modified_config.json
