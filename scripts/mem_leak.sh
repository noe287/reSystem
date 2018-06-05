#valgrind --leak-check=yes -v $1 $2
valgrind --leak-check=full --show-reachable=yes -v $1 $2
