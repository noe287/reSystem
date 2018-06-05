#!/bin/bash

release/revision $BSPROOT/. .config | sed -ne 's/^.*][[:space:]]\(.*\)[[:space:]](.*/\1/p' | grep -vie filesystem_product -e filesystem_base -e filesystem_platform -e kernel -e asp_xmls -e device_tables -e buildsys -e libverify_keys -e bcm9535x

