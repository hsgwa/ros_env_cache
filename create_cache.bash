#!/bin/bash

printenv | grep -v ^_= > before.txt

. ~/ros2_foxy/install/setup.bash
. ~/ros2_ws/install/local_setup.bash

printenv | grep -v ^_= > after.txt

vars=`diff before.txt after.txt | cut -d= -f 1 | grep -e \< -e \> | sed -e 's/[<>] //' | sort -u`

echo #!/bin/bash > source_cache.bash

for var in $vars ; do
	# var_before=`diff before.txt after.txt | sed -e 's/< //' | grep ^$var | cut -d= -f 2`
	var_after=`diff before.txt after.txt | sed -e 's/> //' | grep ^$var | cut -d= -f 2`
	echo export $var=$var_after  >> source_cache.bash
done

rm after.txt before.txt
