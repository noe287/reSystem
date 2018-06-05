 for D in `ls`;do svn info $D | grep URL  | cut -d " " -f2;done

