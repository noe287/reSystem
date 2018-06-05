METADATA_DIR="/home/noe287/Development/projects/FOSS_WORK/Create_Commit_Metadata/metadata_create/metadata_dir"
fosstools_dir="tools/fosstools/foss_metadata"


if [ -d $fosstools_dir ];then
	cp $METADATA_DIR/* $fosstools_dir/
else 
	mkdir -p $fosstools_dir
	cp $METADATA_DIR/* $fosstools_dir/
fi
