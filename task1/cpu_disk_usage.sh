#!/bin/bash
> output
> Not_reachable_list

echo  "<html>
<body>
<table border="1">" >> output

for i in `cat host_list`;
do

        ping -c2 $i 2>/dev/null
        if [ "$?" != "0" ]
        then
                echo "$i" >> Not_reachable_list
                echo "<tr><td>$i</td>" >> output
        else
                echo "<tr><td>$i</td>" >> output
                ssh alvin@$i  bash < ssh_chk.sh >> output
        fi
done

echo "</tabe>
</body>
</html>" >> output
