info() {

        echo "<td>`hostname`</td>"
        echo "<td>`sh -c  "top -b -n 1 | grep Cpu | awk '{print $8}'|cut -f 1 -d ".""`</td>"
        echo "<td><pre>`sh -c "df -P | grep /dev | grep -v -E '(tmp|boot)' | awk '{print $5}' | cut -f 1 -d "%"" `</pre></td>"
        echo "</tr>"

}
info
